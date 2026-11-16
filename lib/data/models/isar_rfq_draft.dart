import 'package:isar/isar.dart';
import '../../domain/models/rfq_draft.dart';

part 'isar_rfq_draft.g.dart';

@collection
class IsarRfqDraft {
  Id id = 1;

  List<IsarDraftItem> items = [];

  String? attachmentPath;

  int? originalSizeBytes;

  int? compressedSizeBytes;

  String syncStatus = 'editing';

  late DateTime updatedAt;

  RfqDraft toDomain() {
    return RfqDraft(
      items: items
          .map((e) => DraftLineItem(
                productId: e.productId,
                quantity: e.quantity,
              ))
          .toList(),
      attachmentPath: attachmentPath,
      originalSizeBytes: originalSizeBytes,
      compressedSizeBytes: compressedSizeBytes,
      syncStatus: RfqSyncStatus.fromStorageString(syncStatus),
      updatedAt: updatedAt,
    );
  }

  static IsarRfqDraft fromDomain(RfqDraft draft) {
    return IsarRfqDraft()
      ..id = 1
      ..items = draft.items
          .map((i) => IsarDraftItem()
            ..productId = i.productId
            ..quantity = i.quantity)
          .toList()
      ..attachmentPath = draft.attachmentPath
      ..originalSizeBytes = draft.originalSizeBytes
      ..compressedSizeBytes = draft.compressedSizeBytes
      ..syncStatus = draft.syncStatus.toStorageString()
      ..updatedAt = draft.updatedAt;
  }

  SubmittedRfqQuote toSubmittedDomain() {
    return SubmittedRfqQuote(
      id: id,
      quoteCode: 'RFQ-TMF-$id',
      items: items
          .map((e) => DraftLineItem(
                productId: e.productId,
                quantity: e.quantity,
              ))
          .toList(),
      attachmentPath: attachmentPath,
      originalSizeBytes: originalSizeBytes,
      compressedSizeBytes: compressedSizeBytes,
      submittedAt: updatedAt,
    );
  }

  static IsarRfqDraft fromSubmittedDomain(SubmittedRfqQuote submitted) {
    return IsarRfqDraft()
      ..id = submitted.id
      ..items = submitted.items
          .map((i) => IsarDraftItem()
            ..productId = i.productId
            ..quantity = i.quantity)
          .toList()
      ..attachmentPath = submitted.attachmentPath
      ..originalSizeBytes = submitted.originalSizeBytes
      ..compressedSizeBytes = submitted.compressedSizeBytes
      ..syncStatus = RfqSyncStatus.synced.toStorageString()
      ..updatedAt = submitted.submittedAt;
  }
}

@embedded
class IsarDraftItem {
  late String productId;
  late int quantity;
}
