import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/file_size_formatter.dart';

class ImageCompressionResult {
  final String savedFilePath;
  final int originalSizeBytes;
  final int compressedSizeBytes;

  const ImageCompressionResult({
    required this.savedFilePath,
    required this.originalSizeBytes,
    required this.compressedSizeBytes,
  });

  String get summaryLabel => FileSizeFormatter.formatCompressionSummary(
        originalBytes: originalSizeBytes,
        compressedBytes: compressedSizeBytes,
      );

  double get reductionPercentage =>
      FileSizeFormatter.calculateReductionPercentage(
        originalBytes: originalSizeBytes,
        compressedBytes: compressedSizeBytes,
      );
}

Uint8List _decodeResizeAndEncodeJpg(
  Uint8List rawBytes, {
  required int maxDimension,
  required int jpegQuality,
}) {
  final decoded = img.decodeImage(rawBytes);
  if (decoded == null) {
    throw const FormatException('No se pudo decodificar la imagen seleccionada.');
  }

  img.Image processed = decoded;
  if (decoded.width > maxDimension || decoded.height > maxDimension) {
    if (decoded.width >= decoded.height) {
      processed = img.copyResize(
        decoded,
        width: maxDimension,
        interpolation: img.Interpolation.linear,
      );
    } else {
      processed = img.copyResize(
        decoded,
        height: maxDimension,
        interpolation: img.Interpolation.linear,
      );
    }
  }

  final compressedJpg = img.encodeJpg(processed, quality: jpegQuality);
  return Uint8List.fromList(compressedJpg);
}

ImageCompressionResult _processPickedFileInSingleIsolate(
  Map<String, dynamic> params,
) {
  final sourcePath = params['sourcePath'] as String;
  final destPath = params['destPath'] as String;
  final maxDimension = params['maxDimension'] as int;
  final quality = params['quality'] as int;

  final rawBytes = File(sourcePath).readAsBytesSync();
  final originalSizeBytes = rawBytes.length;

  final compressedBytes = _decodeResizeAndEncodeJpg(
    rawBytes,
    maxDimension: maxDimension,
    jpegQuality: quality,
  );

  File(destPath).writeAsBytesSync(compressedBytes, flush: true);

  return ImageCompressionResult(
    savedFilePath: destPath,
    originalSizeBytes: originalSizeBytes,
    compressedSizeBytes: compressedBytes.length,
  );
}

ImageCompressionResult _generateAndCompressDemoRifInSingleIsolate(
  Map<String, dynamic> params,
) {
  final destPath = params['destPath'] as String;
  final maxDimension = params['maxDimension'] as int;
  final quality = params['quality'] as int;

  const width = 1200;
  const height = 800;
  final canvas = img.Image(width: width, height: height);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final r = (235 + ((x + y) % 18)).clamp(0, 255);
      final g = (240 + ((x * 2 + y) % 14)).clamp(0, 255);
      final b = (248 + ((x + y * 3) % 7)).clamp(0, 255);
      canvas.setPixelRgb(x, y, r, g, b);
    }
  }

  img.fillRect(
    canvas,
    x1: 40,
    y1: 40,
    x2: width - 40,
    y2: 150,
    color: img.ColorRgb8(21, 101, 192),
  );

  img.fillRect(
    canvas,
    x1: 60,
    y1: 200,
    x2: 820,
    y2: 260,
    color: img.ColorRgb8(60, 72, 88),
  );
  img.fillRect(
    canvas,
    x1: 60,
    y1: 300,
    x2: 720,
    y2: 345,
    color: img.ColorRgb8(100, 116, 139),
  );
  img.fillRect(
    canvas,
    x1: 60,
    y1: 380,
    x2: 780,
    y2: 425,
    color: img.ColorRgb8(100, 116, 139),
  );
  img.fillRect(
    canvas,
    x1: 880,
    y1: 200,
    x2: 1120,
    y2: 440,
    color: img.ColorRgb8(30, 41, 59),
  );

  final rawBmpBytes = Uint8List.fromList(img.encodeBmp(canvas));
  final originalSizeBytes = rawBmpBytes.length;

  final resized = img.copyResize(
    canvas,
    width: maxDimension,
    interpolation: img.Interpolation.linear,
  );
  final compressedBytes =
      Uint8List.fromList(img.encodeJpg(resized, quality: quality));

  File(destPath).writeAsBytesSync(compressedBytes, flush: true);

  return ImageCompressionResult(
    savedFilePath: destPath,
    originalSizeBytes: originalSizeBytes,
    compressedSizeBytes: compressedBytes.length,
  );
}

class ImageCompressionService {
  final ImagePicker _picker;

  ImageCompressionService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  Future<Uint8List> compressImageBytes(
    Uint8List rawBytes, {
    int maxDimension = 1024,
    int quality = 65,
  }) async {
    return Isolate.run(
      () => _decodeResizeAndEncodeJpg(
        rawBytes,
        maxDimension: maxDimension,
        jpegQuality: quality,
      ),
    );
  }

  Future<ImageCompressionResult?> pickAndCompress({
    required ImageSource source,
    String? customSaveDirectoryPath,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return null;

    final dirPath = customSaveDirectoryPath ??
        (await getApplicationDocumentsDirectory()).path;
    final destPath =
        '$dirPath/rif_comprobante_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return Isolate.run(
      () => _processPickedFileInSingleIsolate({
        'sourcePath': pickedFile.path,
        'destPath': destPath,
        'maxDimension': 1024,
        'quality': 65,
      }),
    );
  }

  Future<ImageCompressionResult> generateAndCompressSampleRif({
    String? customSaveDirectoryPath,
  }) async {
    final dirPath = customSaveDirectoryPath ??
        (await getApplicationDocumentsDirectory()).path;
    final destPath =
        '$dirPath/rif_demo_opt_${DateTime.now().millisecondsSinceEpoch}.jpg';

    return Isolate.run(
      () => _generateAndCompressDemoRifInSingleIsolate({
        'destPath': destPath,
        'maxDimension': 960,
        'quality': 65,
      }),
    );
  }
}
