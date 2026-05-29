import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/certificate/certificate_request_screen.dart';
import '../../features/collection/collection_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/identify/identify_result_screen.dart';
import '../../features/postman/postman_chat_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/scanner/scanner_screen.dart';
import '../models/identification_result.dart';

final _shellKey = GlobalKey<NavigatorState>();
final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) =>
            HomeShell(navigationShell: navShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scanner',
                builder: (_, __) => const ScannerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/collection',
                builder: (_, __) => const CollectionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/postman',
                builder: (_, __) => const PostmanChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/identify',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra;
          if (extra is IdentificationResult) {
            return IdentifyResultScreen(result: extra);
          }
          return IdentifyResultScreen(result: IdentificationResult.demo());
        },
      ),
      GoRoute(
        path: '/certificate',
        parentNavigatorKey: _rootKey,
        builder: (_, state) {
          final extra = state.extra;
          return CertificateRequestScreen(
            stamp: extra is IdentificationResult ? extra : null,
          );
        },
      ),
    ],
  );
});
