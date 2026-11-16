import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica/data/repositories/catalog_repository.dart';
import 'package:prueba_tecnica/domain/models/rfq_draft.dart';
import 'package:prueba_tecnica/presentation/providers/rfq_providers.dart';

void main() {
  group('Módulo 4 — Switch "Simular Sin Señal", Pendiente de Sincronización e Idempotencia', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(
            const CatalogRepository(simulatedLatency: Duration(milliseconds: 20)),
          ),
          submissionLatencyProvider.overrideWithValue(
            const Duration(milliseconds: 60),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('1. Con Switch "Simular Sin Señal" activo guarda como "Pendiente de Sincronización" y permite reintentar al volver la señal', () async {
      await container.read(catalogProvider.notifier).loadCatalog();
      final draftNotifier = container.read(rfqDraftProvider.notifier);
      await draftNotifier.loadPersistedDraft();

      await draftNotifier.updateProductQuantity('prod-01', 20);

      draftNotifier.setSimulateNoSignal(true);

      final offlineOutcome = await draftNotifier.submitQuote();

      expect(offlineOutcome, QuoteSubmissionOutcome.savedPendingOffline);
      final stateAfterOffline = container.read(rfqDraftProvider);
      expect(stateAfterOffline.draft.items.length, 1);
      expect(stateAfterOffline.draft.quantityFor('prod-01'), 20);
      expect(stateAfterOffline.draft.syncStatus, RfqSyncStatus.pendingSync);
      expect(stateAfterOffline.successfulSubmissionsCount, 0);

      draftNotifier.setSimulateNoSignal(false);
      final retryOutcome = await draftNotifier.submitQuote();

      expect(retryOutcome, QuoteSubmissionOutcome.sentOnline);
      final stateAfterRetry = container.read(rfqDraftProvider);
      expect(stateAfterRetry.successfulSubmissionsCount, 1);
      expect(stateAfterRetry.draft.isEmpty, isTrue);
    });

    test('2. Escudo de Idempotencia: evita envíos duplicados ante múltiples toques rápidos al botón', () async {
      await container.read(catalogProvider.notifier).loadCatalog();
      final draftNotifier = container.read(rfqDraftProvider.notifier);
      await draftNotifier.loadPersistedDraft();

      await draftNotifier.updateProductQuantity('prod-02', 50);

      final results = await Future.wait([
        draftNotifier.submitQuote(),
        draftNotifier.submitQuote(),
        draftNotifier.submitQuote(),
        draftNotifier.submitQuote(),
        draftNotifier.submitQuote(),
      ]);

      final sentCount =
          results.where((r) => r == QuoteSubmissionOutcome.sentOnline).length;
      final ignoredCount = results
          .where((r) => r == QuoteSubmissionOutcome.ignoredDuplicateTap)
          .length;

      expect(sentCount, 1);
      expect(ignoredCount, 4);
      expect(container.read(rfqDraftProvider).successfulSubmissionsCount, 1);
    });

    test('3. Impide enviar si algún producto tiene cantidad inferior al MOQ', () async {
      await container.read(catalogProvider.notifier).loadCatalog();
      final draftNotifier = container.read(rfqDraftProvider.notifier);
      await draftNotifier.loadPersistedDraft();

      await draftNotifier.updateProductQuantity('prod-01', 3);

      final outcome = await draftNotifier.submitQuote();
      expect(outcome, QuoteSubmissionOutcome.validationFailed);
      expect(container.read(rfqDraftProvider).successfulSubmissionsCount, 0);
    });
  });
}

