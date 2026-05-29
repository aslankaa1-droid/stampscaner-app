import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/identification_result.dart';

/// Local SQLite-backed storage for the user's stamp collection.
///
/// Schema: a single `stamps` table indexed by insertion order. When sync with
/// the backend is added in Sprint 4, we will mirror records into a server-side
/// table keyed by a stable UUID rather than rowid.
class StorageService {
  static const _dbName = 'stampscaner.db';
  static const _table = 'stamps';

  Database? _db;

  Future<Database> _open() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    _db = await openDatabase(
      p.join(dir.path, _dbName),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE $_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            captured_at INTEGER NOT NULL,
            country TEXT NOT NULL,
            year INTEGER NOT NULL,
            series TEXT NOT NULL,
            catalog_ref TEXT NOT NULL,
            grade TEXT NOT NULL,
            estimate_low INTEGER NOT NULL,
            estimate_high INTEGER NOT NULL,
            condition TEXT NOT NULL,
            confidence REAL NOT NULL,
            image_path TEXT,
            notes TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  Future<int> addStamp(IdentificationResult r) async {
    final db = await _open();
    return db.insert(_table, {
      'captured_at': DateTime.now().millisecondsSinceEpoch,
      'country': r.country,
      'year': r.year,
      'series': r.series,
      'catalog_ref': r.catalogRef,
      'grade': r.grade,
      'estimate_low': r.estimateLow,
      'estimate_high': r.estimateHigh,
      'condition': r.condition,
      'confidence': r.confidence,
      'image_path': r.imagePath,
      'notes': r.notes,
    });
  }

  Future<List<StoredStamp>> list() async {
    final db = await _open();
    final rows = await db.query(_table, orderBy: 'captured_at DESC');
    return rows.map(StoredStamp.fromRow).toList();
  }

  Future<int> remove(int id) async {
    final db = await _open();
    return db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> totalEstimateMidpoint() async {
    final db = await _open();
    final rows = await db.rawQuery(
      'SELECT SUM((estimate_low + estimate_high) / 2) AS s FROM $_table',
    );
    return (rows.first['s'] as num?)?.toInt() ?? 0;
  }
}

class StoredStamp {
  StoredStamp({
    required this.id,
    required this.capturedAt,
    required this.result,
  });

  final int id;
  final DateTime capturedAt;
  final IdentificationResult result;

  factory StoredStamp.fromRow(Map<String, Object?> row) => StoredStamp(
        id: row['id'] as int,
        capturedAt:
            DateTime.fromMillisecondsSinceEpoch(row['captured_at'] as int),
        result: IdentificationResult(
          country: row['country'] as String,
          year: row['year'] as int,
          series: row['series'] as String,
          catalogRef: row['catalog_ref'] as String,
          grade: row['grade'] as String,
          estimateLow: row['estimate_low'] as int,
          estimateHigh: row['estimate_high'] as int,
          condition: row['condition'] as String,
          confidence: (row['confidence'] as num).toDouble(),
          imagePath: row['image_path'] as String?,
          notes: row['notes'] as String?,
        ),
      );
}

final storageServiceProvider = Provider<StorageService>((_) => StorageService());
