class PriceTier {
  final int minQty;
  final int? maxQty;
  final double unitPrice;

  const PriceTier({
    required this.minQty,
    this.maxQty,
    required this.unitPrice,
  });

  factory PriceTier.fromJson(Map<String, dynamic> json) {
    return PriceTier(
      minQty: (json['minQty'] as num).toInt(),
      maxQty: json['maxQty'] != null ? (json['maxQty'] as num).toInt() : null,
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minQty': minQty,
      'maxQty': maxQty,
      'unitPrice': unitPrice,
    };
  }

  String get rangeLabel {
    if (maxQty == null) {
      return '$minQty+';
    }
    return '$minQty - $maxQty';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PriceTier &&
        other.minQty == minQty &&
        other.maxQty == maxQty &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode => Object.hash(minQty, maxQty, unitPrice);
}

class B2BProduct {
  final String id;
  final String sku;
  final String name;
  final String brand;
  final String unit;
  final int moq;
  final int stock;
  final List<PriceTier> tiers;

  const B2BProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.brand,
    required this.unit,
    required this.moq,
    required this.stock,
    required this.tiers,
  });

  factory B2BProduct.fromJson(Map<String, dynamic> json) {
    final tiersList = (json['tiers'] as List<dynamic>)
        .map((t) => PriceTier.fromJson(t as Map<String, dynamic>))
        .toList();

    return B2BProduct(
      id: json['id'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      unit: json['unit'] as String,
      moq: (json['moq'] as num).toInt(),
      stock: (json['stock'] as num).toInt(),
      tiers: tiersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'brand': brand,
      'unit': unit,
      'moq': moq,
      'stock': stock,
      'tiers': tiers.map((t) => t.toJson()).toList(),
    };
  }

  double get baseUnitPrice => tiers.isNotEmpty ? tiers.first.unitPrice : 0.0;

  double get bestUnitPrice => tiers.isNotEmpty ? tiers.last.unitPrice : 0.0;
}
