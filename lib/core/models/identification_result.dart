/// Result of a stamp identification — returned by the API or built locally for demos.
class IdentificationResult {
  const IdentificationResult({
    required this.country,
    required this.year,
    required this.series,
    required this.catalogRef,
    required this.grade,
    required this.estimateLow,
    required this.estimateHigh,
    required this.condition,
    required this.confidence,
    this.imagePath,
    this.notes,
  });

  /// Country of issue, in the active locale.
  final String country;

  /// Year of issue.
  final int year;

  /// Series or theme name.
  final String series;

  /// Cross-reference catalogue (Scott / SG / Michel / Zagorsky).
  final String catalogRef;

  /// APS grade abbreviation (Superb / XF / VF / F / Avg / Poor).
  final String grade;

  /// Estimate range in USD.
  final int estimateLow;
  final int estimateHigh;

  /// Used / Mint / etc.
  final String condition;

  /// 0..1 confidence value from Postman.
  final double confidence;

  /// Local file path of the captured / picked photo.
  final String? imagePath;

  /// Free-form notes (varieties, postmarks, expert remarks).
  final String? notes;

  /// Demonstration record matching the public-site mockup.
  factory IdentificationResult.demo() => const IdentificationResult(
        country: 'СССР',
        year: 1934,
        series: 'Авиапочта · Десятилетие революции (демо)',
        catalogRef: 'Зг. 384',
        grade: 'VF',
        estimateLow: 420,
        estimateHigh: 550,
        condition: 'Гашёная, без дефектов',
        confidence: 0.84,
      );

  IdentificationResult copyWith({String? imagePath}) => IdentificationResult(
        country: country,
        year: year,
        series: series,
        catalogRef: catalogRef,
        grade: grade,
        estimateLow: estimateLow,
        estimateHigh: estimateHigh,
        condition: condition,
        confidence: confidence,
        imagePath: imagePath ?? this.imagePath,
        notes: notes,
      );

  Map<String, dynamic> toJson() => {
        'country': country,
        'year': year,
        'series': series,
        'catalog_ref': catalogRef,
        'grade': grade,
        'estimate_low': estimateLow,
        'estimate_high': estimateHigh,
        'condition': condition,
        'confidence': confidence,
        'image_path': imagePath,
        'notes': notes,
      };

  factory IdentificationResult.fromJson(Map<String, dynamic> j) =>
      IdentificationResult(
        country: j['country'] as String? ?? '',
        year: (j['year'] as num?)?.toInt() ?? 0,
        series: j['series'] as String? ?? '',
        catalogRef: j['catalog_ref'] as String? ?? '',
        grade: j['grade'] as String? ?? '',
        estimateLow: (j['estimate_low'] as num?)?.toInt() ?? 0,
        estimateHigh: (j['estimate_high'] as num?)?.toInt() ?? 0,
        condition: j['condition'] as String? ?? '',
        confidence: (j['confidence'] as num?)?.toDouble() ?? 0,
        imagePath: j['image_path'] as String?,
        notes: j['notes'] as String?,
      );
}
