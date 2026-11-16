enum RfqSyncStatus {
  editing,
  pendingSync,
  synced;

  String toStorageString() {
    switch (this) {
      case RfqSyncStatus.editing:
        return 'editing';
      case RfqSyncStatus.pendingSync:
        return 'pending_sync';
      case RfqSyncStatus.synced:
        return 'synced';
    }
  }

  static RfqSyncStatus fromStorageString(String value) {
    switch (value) {
      case 'pending_sync':
        return RfqSyncStatus.pendingSync;
      case 'synced':
        return RfqSyncStatus.synced;
      case 'editing':
      default:
        return RfqSyncStatus.editing;
    }
  }
}

class DraftLineItem {
  final String productId;
  final int quantity;

  const DraftLineItem({
    required this.productId,
    required this.quantity,
  });

  DraftLineItem copyWith({
    String? productId,
    int? quantity,
  }) {
    return DraftLineItem(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DraftLineItem &&
        other.productId == productId &&
        other.quantity == quantity;
  }

  @override
  int get hashCode => Object.hash(productId, quantity);
}

class RfqDraft {
  final List<DraftLineItem> items;
  final String? attachmentPath;
  final int? originalSizeBytes;
  final int? compressedSizeBytes;
  final RfqSyncStatus syncStatus;
  final DateTime updatedAt;

  const RfqDraft({
    required this.items,
    this.attachmentPath,
    this.originalSizeBytes,
    this.compressedSizeBytes,
    required this.syncStatus,
    required this.updatedAt,
  });

  factory RfqDraft.empty() {
    return RfqDraft(
      items: const [],
      syncStatus: RfqSyncStatus.editing,
      updatedAt: DateTime.now(),
    );
  }

  bool get isEmpty => items.isEmpty && attachmentPath == null;

  bool get hasAttachment =>
      attachmentPath != null &&
      attachmentPath!.isNotEmpty &&
      originalSizeBytes != null &&
      compressedSizeBytes != null;

  bool get isPendingSync => syncStatus == RfqSyncStatus.pendingSync;

  int quantityFor(String productId) {
    for (final item in items) {
      if (item.productId == productId) return item.quantity;
    }
    return 0;
  }

  RfqDraft copyWith({
    List<DraftLineItem>? items,
    String? attachmentPath,
    bool clearAttachment = false,
    int? originalSizeBytes,
    int? compressedSizeBytes,
    RfqSyncStatus? syncStatus,
    DateTime? updatedAt,
  }) {
    return RfqDraft(
      items: items ?? this.items,
      attachmentPath:
          clearAttachment ? null : (attachmentPath ?? this.attachmentPath),
      originalSizeBytes: clearAttachment
          ? null
          : (originalSizeBytes ?? this.originalSizeBytes),
      compressedSizeBytes: clearAttachment
          ? null
          : (compressedSizeBytes ?? this.compressedSizeBytes),
      syncStatus: syncStatus ?? this.syncStatus,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}

class SubmittedRfqQuote {
  final int id;
  final String quoteCode;
  final List<DraftLineItem> items;
  final String? attachmentPath;
  final int? originalSizeBytes;
  final int? compressedSizeBytes;
  final DateTime submittedAt;

  const SubmittedRfqQuote({
    required this.id,
    required this.quoteCode,
    required this.items,
    this.attachmentPath,
    this.originalSizeBytes,
    this.compressedSizeBytes,
    required this.submittedAt,
  });

  bool get hasAttachment =>
      attachmentPath != null &&
      attachmentPath!.isNotEmpty &&
      originalSizeBytes != null &&
      compressedSizeBytes != null;
}
