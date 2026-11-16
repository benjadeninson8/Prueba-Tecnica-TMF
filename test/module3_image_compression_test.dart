import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica/core/utils/file_size_formatter.dart';
import 'package:prueba_tecnica/data/services/image_compression_service.dart';

void main() {
  group('Módulo 3 — Captura, Redimensionado y Compresión de Imagen en Isolate', () {
    test('1. Formatea exactamente el texto exigido: "Peso original: X MB → Peso optimizado: Y KB"', () {
      const originalBytes = 2621440;
      const compressedBytes = 153600;

      final formatted = FileSizeFormatter.formatCompressionSummary(
        originalBytes: originalBytes,
        compressedBytes: compressedBytes,
      );

      expect(
        formatted,
        'Peso original: 2.50 MB → Peso optimizado: 150.0 KB',
      );

      final reduction = FileSizeFormatter.calculateReductionPercentage(
        originalBytes: originalBytes,
        compressedBytes: compressedBytes,
      );
      expect(reduction, greaterThan(90.0));
    });

    test('2. Comprime en un Isolate real una imagen de >2.5 MB a pocos KB y persiste el archivo', () async {
      final tempDir = await Directory.systemTemp.createTemp('tmf_img_test_');
      final service = ImageCompressionService();

      try {
        final result = await service.generateAndCompressSampleRif(
          customSaveDirectoryPath: tempDir.path,
        );

        expect(result.originalSizeBytes, greaterThan(2 * 1024 * 1024));

        expect(result.compressedSizeBytes, lessThan(200 * 1024));
        expect(result.reductionPercentage, greaterThan(90.0));

        final savedFile = File(result.savedFilePath);
        expect(await savedFile.exists(), isTrue);
        expect(await savedFile.length(), result.compressedSizeBytes);

        expect(result.summaryLabel, startsWith('Peso original: '));
        expect(result.summaryLabel, contains(' MB → Peso optimizado: '));
        expect(result.summaryLabel, endsWith(' KB'));
      } finally {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    });
  });
}

