import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/rfq_draft.dart';
import '../models/isar_rfq_draft.dart';

abstract class DraftLocalDataSource {
  Future<RfqDraft> readDraft();
  Future<void> writeDraft(RfqDraft draft);
  Future<void> deleteDraft();
  Future<List<SubmittedRfqQuote>> readSubmittedQuotes();
  Future<SubmittedRfqQuote> archiveSubmittedDraft(RfqDraft draft);
}

class IsarDraftLocalDataSource implements DraftLocalDataSource {
  static const String _dbName = 'tmf_b2b_rfq';

  Isar? _isar;
  Future<Isar?>? _openingFuture;
  SimulatedDiskDraftDataSource? _fallback;

  IsarDraftLocalDataSource([this._isar]);

  SimulatedDiskDraftDataSource get _safeFallback =>
      _fallback ??= SimulatedDiskDraftDataSource();

  Future<Isar?> _getIsar() async {
    if (_isar != null && _isar!.isOpen) return _isar;

    final existing = Isar.getInstance(_dbName) ?? Isar.getInstance();
    if (existing != null && existing.isOpen) {
      _isar = existing;
      return existing;
    }

    _openingFuture ??= _openSafely();
    _isar = await _openingFuture;
    return _isar;
  }

  Future<Isar?> _openSafely() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [IsarRfqDraftSchema],
        directory: dir.path,
        name: _dbName,
        inspector: false,
        compactOnLaunch: const CompactCondition(
          minFileSize: 1024 * 1024,
          minBytes: 256 * 1024,
          minRatio: 2.0,
        ),
      ).timeout(const Duration(seconds: 3));
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RfqDraft> readDraft() async {
    final isar = await _getIsar();
    if (isar == null) return _safeFallback.readDraft();

    final record = await isar.isarRfqDrafts.get(1);
    if (record == null) {
      return RfqDraft.empty();
    }
    return record.toDomain();
  }

  @override
  Future<void> writeDraft(RfqDraft draft) async {
    final isar = await _getIsar();
    if (isar == null) {
      await _safeFallback.writeDraft(draft);
      return;
    }

    final record = IsarRfqDraft.fromDomain(draft);
    await isar.writeTxn(() async {
      await isar.isarRfqDrafts.put(record);
    });
  }

  @override
  Future<void> deleteDraft() async {
    final isar = await _getIsar();
    if (isar == null) {
      await _safeFallback.deleteDraft();
      return;
    }

    await isar.writeTxn(() async {
      await isar.isarRfqDrafts.delete(1);
    });
  }

  @override
  Future<List<SubmittedRfqQuote>> readSubmittedQuotes() async {
    final isar = await _getIsar();
    if (isar == null) return _safeFallback.readSubmittedQuotes();

    final records =
        await isar.isarRfqDrafts.where().idGreaterThan(1000).findAll();
    final submitted = records.map((r) => r.toSubmittedDomain()).toList();
    submitted.sort((a, b) => b.id.compareTo(a.id));
    return submitted;
  }

  @override
  Future<SubmittedRfqQuote> archiveSubmittedDraft(RfqDraft draft) async {
    final isar = await _getIsar();
    if (isar == null) {
      return _safeFallback.archiveSubmittedDraft(draft);
    }

    final existing =
        await isar.isarRfqDrafts.where().idGreaterThan(1000).findAll();
    int maxId = 1000;
    for (final rec in existing) {
      if (rec.id > maxId) maxId = rec.id;
    }
    final nextId = maxId + 1;

    final submitted = SubmittedRfqQuote(
      id: nextId,
      quoteCode: 'RFQ-TMF-$nextId',
      items: List<DraftLineItem>.from(draft.items),
      attachmentPath: draft.attachmentPath,
      originalSizeBytes: draft.originalSizeBytes,
      compressedSizeBytes: draft.compressedSizeBytes,
      submittedAt: DateTime.now(),
    );

    final record = IsarRfqDraft.fromSubmittedDomain(submitted);
    await isar.writeTxn(() async {
      await isar.isarRfqDrafts.put(record);
      await isar.isarRfqDrafts.delete(1);
    });

    return submitted;
  }
}

class SimulatedDiskDraftDataSource implements DraftLocalDataSource {
  IsarRfqDraft? _persistedRecord;
  final List<IsarRfqDraft> _submittedRecords = [];

  @override
  Future<RfqDraft> readDraft() async {
    if (_persistedRecord == null) {
      return RfqDraft.empty();
    }
    return _persistedRecord!.toDomain();
  }

  @override
  Future<void> writeDraft(RfqDraft draft) async {
    _persistedRecord = IsarRfqDraft.fromDomain(draft);
  }

  @override
  Future<void> deleteDraft() async {
    _persistedRecord = null;
  }

  @override
  Future<List<SubmittedRfqQuote>> readSubmittedQuotes() async {
    final list = _submittedRecords.map((r) => r.toSubmittedDomain()).toList();
    list.sort((a, b) => b.id.compareTo(a.id));
    return list;
  }

  @override
  Future<SubmittedRfqQuote> archiveSubmittedDraft(RfqDraft draft) async {
    final nextId = 1001 + _submittedRecords.length;
    final submitted = SubmittedRfqQuote(
      id: nextId,
      quoteCode: 'RFQ-TMF-$nextId',
      items: List<DraftLineItem>.from(draft.items),
      attachmentPath: draft.attachmentPath,
      originalSizeBytes: draft.originalSizeBytes,
      compressedSizeBytes: draft.compressedSizeBytes,
      submittedAt: DateTime.now(),
    );
    _submittedRecords.add(IsarRfqDraft.fromSubmittedDomain(submitted));
    _persistedRecord = null;
    return submitted;
  }
}

class DraftRepository {
  final DraftLocalDataSource _dataSource;

  const DraftRepository(this._dataSource);

  Future<RfqDraft> loadDraft() async {
    return _dataSource.readDraft();
  }

  Future<RfqDraft> setProductQuantity(String productId, int quantity) async {
    final current = await _dataSource.readDraft();
    final updatedItems = List<DraftLineItem>.from(current.items);

    final existingIndex =
        updatedItems.indexWhere((item) => item.productId == productId);

    if (quantity <= 0) {
      if (existingIndex != -1) {
        updatedItems.removeAt(existingIndex);
      }
    } else {
      final newItem = DraftLineItem(productId: productId, quantity: quantity);
      if (existingIndex != -1) {
        updatedItems[existingIndex] = newItem;
      } else {
        updatedItems.add(newItem);
      }
    }

    final nextDraft = current.copyWith(
      items: updatedItems,
      updatedAt: DateTime.now(),
    );

    await _dataSource.writeDraft(nextDraft);
    return nextDraft;
  }

  Future<RfqDraft> saveCompressedAttachment({
    required String path,
    required int originalSizeBytes,
    required int compressedSizeBytes,
  }) async {
    final current = await _dataSource.readDraft();
    final nextDraft = current.copyWith(
      attachmentPath: path,
      originalSizeBytes: originalSizeBytes,
      compressedSizeBytes: compressedSizeBytes,
      updatedAt: DateTime.now(),
    );

    await _dataSource.writeDraft(nextDraft);
    return nextDraft;
  }

  Future<RfqDraft> removeAttachment() async {
    final current = await _dataSource.readDraft();
    final nextDraft = current.copyWith(
      clearAttachment: true,
      updatedAt: DateTime.now(),
    );

    await _dataSource.writeDraft(nextDraft);
    return nextDraft;
  }

  Future<RfqDraft> markAsPendingSync() async {
    final current = await _dataSource.readDraft();
    final nextDraft = current.copyWith(
      syncStatus: RfqSyncStatus.pendingSync,
      updatedAt: DateTime.now(),
    );

    await _dataSource.writeDraft(nextDraft);
    return nextDraft;
  }

  Future<RfqDraft> clearDraft() async {
    await _dataSource.deleteDraft();
    return RfqDraft.empty();
  }

  Future<List<SubmittedRfqQuote>> loadSubmittedQuotes() async {
    return _dataSource.readSubmittedQuotes();
  }

  Future<SubmittedRfqQuote> archiveAndClearDraft(RfqDraft draft) async {
    return _dataSource.archiveSubmittedDraft(draft);
  }
}
