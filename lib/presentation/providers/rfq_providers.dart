import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';

import '../../data/repositories/catalog_repository.dart';
import '../../data/repositories/draft_repository.dart';
import '../../data/services/image_compression_service.dart';
import '../../domain/models/b2b_product.dart';
import '../../domain/models/rfq_draft.dart';
import '../../domain/services/pricing_engine.dart';

final isarInstanceProvider = Provider<Isar?>((ref) => null);

final draftDataSourceProvider = Provider<DraftLocalDataSource>((ref) {
  final isar = ref.watch(isarInstanceProvider);
  if (isar != null) {
    return IsarDraftLocalDataSource(isar);
  }
  return SimulatedDiskDraftDataSource();
});

final draftRepositoryProvider = Provider<DraftRepository>((ref) {
  return DraftRepository(ref.watch(draftDataSourceProvider));
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return const CatalogRepository(
    simulatedLatency: Duration(milliseconds: 1500),
  );
});

final imageCompressionServiceProvider = Provider<ImageCompressionService>((ref) {
  return ImageCompressionService();
});

class CatalogState {
  final List<B2BProduct> allProducts;
  final List<B2BProduct> filteredProducts;
  final bool isLoading;
  final String searchQuery;
  final String? errorMessage;

  const CatalogState({
    required this.allProducts,
    required this.filteredProducts,
    required this.isLoading,
    required this.searchQuery,
    this.errorMessage,
  });

  factory CatalogState.initial() {
    return const CatalogState(
      allProducts: [],
      filteredProducts: [],
      isLoading: true,
      searchQuery: '',
    );
  }

  B2BProduct? findById(String id) {
    for (final p in allProducts) {
      if (p.id == id) return p;
    }
    return null;
  }

  CatalogState copyWith({
    List<B2BProduct>? allProducts,
    List<B2BProduct>? filteredProducts,
    bool? isLoading,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CatalogState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class CatalogNotifier extends Notifier<CatalogState> {
  @override
  CatalogState build() {
    Future.microtask(loadCatalog);
    return CatalogState.initial();
  }

  Future<void> loadCatalog() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = ref.read(catalogRepositoryProvider);
      final products = await repo.fetchCatalogProducts();
      final filtered = CatalogRepository.filterByNameOrSku(
        products,
        state.searchQuery,
      );
      state = state.copyWith(
        allProducts: products,
        filteredProducts: filtered,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error cargando el catálogo: $e',
      );
    }
  }

  void setSearchQuery(String query) {
    final filtered = CatalogRepository.filterByNameOrSku(
      state.allProducts,
      query,
    );
    state = state.copyWith(
      searchQuery: query,
      filteredProducts: filtered,
    );
  }
}

final catalogProvider = NotifierProvider<CatalogNotifier, CatalogState>(() {
  return CatalogNotifier();
});

enum QuoteSubmissionOutcome {
  sentOnline,
  savedPendingOffline,
  validationFailed,
  ignoredDuplicateTap,
}

class RfqDraftState {
  final RfqDraft draft;
  final bool isLoadingDraft;
  final bool simulateNoSignal;
  final bool isSubmitting;
  final bool isCompressingPhoto;
  final int successfulSubmissionsCount;
  final String? lastFeedbackMessage;
  final String? lastSubmittedQuoteCode;
  final List<SubmittedRfqQuote> submittedQuotes;

  const RfqDraftState({
    required this.draft,
    this.isLoadingDraft = false,
    this.simulateNoSignal = false,
    this.isSubmitting = false,
    this.isCompressingPhoto = false,
    this.successfulSubmissionsCount = 0,
    this.lastFeedbackMessage,
    this.lastSubmittedQuoteCode,
    this.submittedQuotes = const [],
  });

  factory RfqDraftState.initial() {
    return RfqDraftState(
      draft: RfqDraft.empty(),
      isLoadingDraft: true,
      submittedQuotes: const [],
    );
  }

  int get distinctProductsCount => draft.items.length;

  double calculateGrandTotal(List<B2BProduct> catalog) {
    double total = 0.0;
    for (final item in draft.items) {
      final product = catalog.where((p) => p.id == item.productId).firstOrNull;
      if (product != null) {
        final eval = PricingEngine.evaluate(product, item.quantity);
        total += eval.subtotal;
      }
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateTotalVolumeSavings(List<B2BProduct> catalog) {
    double savings = 0.0;
    for (final item in draft.items) {
      final product = catalog.where((p) => p.id == item.productId).firstOrNull;
      if (product != null) {
        final eval = PricingEngine.evaluate(product, item.quantity);
        savings += eval.totalSavings;
      }
    }
    return double.parse(savings.toStringAsFixed(2));
  }

  bool hasAnyInvalidQuantity(List<B2BProduct> catalog) {
    for (final item in draft.items) {
      final product = catalog.where((p) => p.id == item.productId).firstOrNull;
      if (product != null) {
        final eval = PricingEngine.evaluate(product, item.quantity);
        if (!eval.isValidForQuote) return true;
      }
    }
    return false;
  }

  RfqDraftState copyWith({
    RfqDraft? draft,
    bool? isLoadingDraft,
    bool? simulateNoSignal,
    bool? isSubmitting,
    bool? isCompressingPhoto,
    int? successfulSubmissionsCount,
    String? lastFeedbackMessage,
    bool clearFeedback = false,
    String? lastSubmittedQuoteCode,
    List<SubmittedRfqQuote>? submittedQuotes,
  }) {
    return RfqDraftState(
      draft: draft ?? this.draft,
      isLoadingDraft: isLoadingDraft ?? this.isLoadingDraft,
      simulateNoSignal: simulateNoSignal ?? this.simulateNoSignal,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCompressingPhoto: isCompressingPhoto ?? this.isCompressingPhoto,
      successfulSubmissionsCount:
          successfulSubmissionsCount ?? this.successfulSubmissionsCount,
      lastFeedbackMessage: clearFeedback
          ? null
          : (lastFeedbackMessage ?? this.lastFeedbackMessage),
      lastSubmittedQuoteCode:
          lastSubmittedQuoteCode ?? this.lastSubmittedQuoteCode,
      submittedQuotes: submittedQuotes ?? this.submittedQuotes,
    );
  }
}

final submissionLatencyProvider = Provider<Duration>((ref) {
  return const Duration(milliseconds: 1500);
});

class RfqDraftNotifier extends Notifier<RfqDraftState> {
  bool _isSubmittingMutex = false;

  @override
  RfqDraftState build() {
    Future.microtask(loadPersistedDraft);
    return RfqDraftState.initial();
  }

  Future<void> loadPersistedDraft() async {
    final repo = ref.read(draftRepositoryProvider);
    final persisted = await repo.loadDraft();
    final history = await repo.loadSubmittedQuotes();
    state = state.copyWith(
      draft: persisted,
      isLoadingDraft: false,
      submittedQuotes: history,
      successfulSubmissionsCount: history.length,
    );
  }

  void setSimulateNoSignal(bool value) {
    state = state.copyWith(
      simulateNoSignal: value,
      clearFeedback: true,
    );
  }

  Future<void> updateProductQuantity(String productId, int quantity) async {
    final repo = ref.read(draftRepositoryProvider);
    final updatedDraft = await repo.setProductQuantity(productId, quantity);
    state = state.copyWith(draft: updatedDraft, clearFeedback: true);
  }

  Future<void> pickAndCompressPhoto(ImageSource source) async {
    if (state.isCompressingPhoto) return;
    state = state.copyWith(isCompressingPhoto: true, clearFeedback: true);

    try {
      final compressor = ref.read(imageCompressionServiceProvider);
      final result = await compressor.pickAndCompress(source: source);
      if (result == null) {
        state = state.copyWith(isCompressingPhoto: false);
        return;
      }

      final repo = ref.read(draftRepositoryProvider);
      final updatedDraft = await repo.saveCompressedAttachment(
        path: result.savedFilePath,
        originalSizeBytes: result.originalSizeBytes,
        compressedSizeBytes: result.compressedSizeBytes,
      );

      state = state.copyWith(
        draft: updatedDraft,
        isCompressingPhoto: false,
        lastFeedbackMessage: '✓ Comprobante comprimido: ${result.summaryLabel}',
      );
    } catch (e) {
      state = state.copyWith(
        isCompressingPhoto: false,
        lastFeedbackMessage: 'No se pudo procesar la imagen: $e',
      );
    }
  }

  Future<void> attachDemoCompressedRif({String? customSaveDirectoryPath}) async {
    if (state.isCompressingPhoto) return;
    state = state.copyWith(isCompressingPhoto: true, clearFeedback: true);

    try {
      final compressor = ref.read(imageCompressionServiceProvider);
      final result = await compressor.generateAndCompressSampleRif(
        customSaveDirectoryPath: customSaveDirectoryPath,
      );

      final repo = ref.read(draftRepositoryProvider);
      final updatedDraft = await repo.saveCompressedAttachment(
        path: result.savedFilePath,
        originalSizeBytes: result.originalSizeBytes,
        compressedSizeBytes: result.compressedSizeBytes,
      );

      state = state.copyWith(
        draft: updatedDraft,
        isCompressingPhoto: false,
        lastFeedbackMessage: '✓ RIF optimizado: ${result.summaryLabel}',
      );
    } catch (e) {
      state = state.copyWith(
        isCompressingPhoto: false,
        lastFeedbackMessage: 'Error comprimiendo RIF de prueba: $e',
      );
    }
  }

  Future<void> removePhoto() async {
    final repo = ref.read(draftRepositoryProvider);
    final updatedDraft = await repo.removeAttachment();
    state = state.copyWith(draft: updatedDraft);
  }

  Future<QuoteSubmissionOutcome> submitQuote() async {
    if (_isSubmittingMutex || state.isSubmitting) {
      return QuoteSubmissionOutcome.ignoredDuplicateTap;
    }

    if (state.draft.items.isEmpty) {
      state = state.copyWith(
        lastFeedbackMessage: 'Agrega al menos un producto antes de enviar la cotización.',
      );
      return QuoteSubmissionOutcome.validationFailed;
    }

    final catalog = ref.read(catalogProvider).allProducts;
    if (catalog.isNotEmpty && state.hasAnyInvalidQuantity(catalog)) {
      state = state.copyWith(
        lastFeedbackMessage:
            'Revisa las cantidades: todos los productos deben cumplir el pedido mínimo (MOQ) y stock.',
      );
      return QuoteSubmissionOutcome.validationFailed;
    }

    _isSubmittingMutex = true;
    state = state.copyWith(isSubmitting: true, clearFeedback: true);

    try {
      final latency = ref.read(submissionLatencyProvider);
      await Future.delayed(latency);

      final repo = ref.read(draftRepositoryProvider);

      if (state.simulateNoSignal) {
        final pendingDraft = await repo.markAsPendingSync();
        state = state.copyWith(
          draft: pendingDraft,
          isSubmitting: false,
          lastFeedbackMessage:
              '📡 Sin señal: Tu pedido fue resguardado localmente como "Pendiente de Sincronización".',
        );
        return QuoteSubmissionOutcome.savedPendingOffline;
      }

      final submittedRecord = await repo.archiveAndClearDraft(state.draft);
      final updatedHistory = [submittedRecord, ...state.submittedQuotes];
      final newCount = state.successfulSubmissionsCount + 1;
      final quoteCode = submittedRecord.quoteCode;

      state = state.copyWith(
        draft: RfqDraft.empty(),
        isSubmitting: false,
        successfulSubmissionsCount: newCount,
        lastSubmittedQuoteCode: quoteCode,
        submittedQuotes: updatedHistory,
        lastFeedbackMessage:
            '✅ ¡Cotización $quoteCode enviada exitosamente a Tu Mercado Ferretero!',
      );
      return QuoteSubmissionOutcome.sentOnline;
    } finally {
      _isSubmittingMutex = false;
    }
  }
}

final rfqDraftProvider = NotifierProvider<RfqDraftNotifier, RfqDraftState>(() {
  return RfqDraftNotifier();
});
