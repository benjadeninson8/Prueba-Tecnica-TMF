class FileSizeFormatter {
  const FileSizeFormatter._();

  static const int _bytesPerKb = 1024;
  static const int _bytesPerMb = 1024 * 1024;

  static String formatMb(int bytes) {
    final mb = bytes / _bytesPerMb;
    return '${mb.toStringAsFixed(2)} MB';
  }

  static String formatKb(int bytes) {
    final kb = bytes / _bytesPerKb;
    return '${kb.toStringAsFixed(1)} KB';
  }

  static String formatCompressionSummary({
    required int originalBytes,
    required int compressedBytes,
  }) {
    final originalMb = formatMb(originalBytes);
    final optimizedKb = formatKb(compressedBytes);
    return 'Peso original: $originalMb → Peso optimizado: $optimizedKb';
  }

  static double calculateReductionPercentage({
    required int originalBytes,
    required int compressedBytes,
  }) {
    if (originalBytes <= 0) return 0.0;
    final saved = originalBytes - compressedBytes;
    final ratio = (saved / originalBytes) * 100.0;
    return double.parse(ratio.clamp(0.0, 99.9).toStringAsFixed(1));
  }
}
