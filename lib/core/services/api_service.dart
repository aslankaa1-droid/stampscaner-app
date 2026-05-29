import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/identification_result.dart';

/// Networking layer for StampScaner.
///
/// V1 of the mobile app talks to a Cloudflare Worker that wraps Claude Vision
/// with the Postman system prompt. The endpoint is configurable, so during
/// local development we can swap in a different host without rebuilding.
///
/// Until the backend is live (Sprint 2), the [identifyStamp] call falls back
/// to a deterministic demo response after a short delay so the rest of the
/// UI can be exercised on real devices.
class ApiService {
  ApiService({Dio? dio, this.baseUrl = _defaultBaseUrl})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 60),
            ));

  static const _defaultBaseUrl = 'https://api.stampscaner.com';
  final String baseUrl;
  final Dio _dio;

  Future<IdentificationResult> identifyStamp(File image) async {
    try {
      final form = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path),
      });
      final resp = await _dio.post(
        '$baseUrl/v1/identify',
        data: form,
      );
      final body = resp.data;
      if (body is Map<String, dynamic>) {
        return IdentificationResult.fromJson(body);
      }
      throw const FormatException('Unexpected response shape');
    } catch (_) {
      // Sprint 2 will replace this with a real backend round-trip.
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      return IdentificationResult.demo();
    }
  }

  Future<void> requestCertificate({
    required IdentificationResult stamp,
    required String tier,
    required String contactEmail,
    String? notes,
  }) async {
    try {
      await _dio.post(
        '$baseUrl/v1/certificate-request',
        data: {
          'tier': tier,
          'contact_email': contactEmail,
          'stamp': stamp.toJson(),
          if (notes != null) 'notes': notes,
        },
      );
    } catch (_) {
      // Sprint 2: queue locally and retry. For now silently swallow so the
      // demo UI does not crash on devices without a backend.
    }
  }
}

final apiServiceProvider = Provider<ApiService>((_) => ApiService());
