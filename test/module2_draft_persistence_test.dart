import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica/data/repositories/draft_repository.dart';
import 'package:prueba_tecnica/domain/models/rfq_draft.dart';

void main() {
  group('Módulo 2 — Persistencia Local Resiliente del Borrador (Force Close & Offline)', () {
    late SimulatedDiskDraftDataSource simulatedDisk;

    setUp(() {
      simulatedDisk = SimulatedDiskDraftDataSource();
    });

    test('1. Persiste múltiples productos y sobrevive intacto a un Force Close de la app', () async {
      final repoSession1 = DraftRepository(simulatedDisk);
      await repoSession1.setProductQuantity('prod-01', 25);
      await repoSession1.setProductQuantity('prod-03', 100);

      final repoAfterForceClose = DraftRepository(simulatedDisk);
      final recoveredDraft = await repoAfterForceClose.loadDraft();

      expect(recoveredDraft.items.length, 2);
      expect(recoveredDraft.quantityFor('prod-01'), 25);
      expect(recoveredDraft.quantityFor('prod-03'), 100);
      expect(recoveredDraft.syncStatus, RfqSyncStatus.editing);
    });

    test('2. Eliminar un producto (cantidad <= 0) actualiza el disco inmediatamente', () async {
      final repo = DraftRepository(simulatedDisk);
      await repo.setProductQuantity('prod-01', 10);
      await repo.setProductQuantity('prod-02', 50);

      final afterRemoval = await repo.setProductQuantity('prod-01', 0);

      expect(afterRemoval.items.length, 1);
      expect(afterRemoval.quantityFor('prod-01'), 0);
      expect(afterRemoval.quantityFor('prod-02'), 50);
    });

    test('3. Persiste la foto comprimida (RIF/Comprobante) y sus métricas tras Force Close', () async {
      final repoSession1 = DraftRepository(simulatedDisk);
      await repoSession1.setProductQuantity('prod-02', 20);
      await repoSession1.saveCompressedAttachment(
        path: '/data/user/0/com.tmf/cache/rif_compressed.jpg',
        originalSizeBytes: 3450000,
        compressedSizeBytes: 148000,
      );

      final repoSession2 = DraftRepository(simulatedDisk);
      final recovered = await repoSession2.loadDraft();

      expect(recovered.hasAttachment, isTrue);
      expect(recovered.attachmentPath, '/data/user/0/com.tmf/cache/rif_compressed.jpg');
      expect(recovered.originalSizeBytes, 3450000);
      expect(recovered.compressedSizeBytes, 148000);
    });

    test('4. Conserva el estado "Pendiente de Sincronización" si se intenta enviar Sin Señal', () async {
      final repoSession1 = DraftRepository(simulatedDisk);
      await repoSession1.setProductQuantity('prod-01', 50);

      await repoSession1.markAsPendingSync();

      final repoSession2 = DraftRepository(simulatedDisk);
      final recovered = await repoSession2.loadDraft();

      expect(recovered.isPendingSync, isTrue);
      expect(recovered.syncStatus, RfqSyncStatus.pendingSync);
      expect(recovered.quantityFor('prod-01'), 50);

      final cleared = await repoSession2.clearDraft();
      expect(cleared.isEmpty, isTrue);
    });
  });
}

