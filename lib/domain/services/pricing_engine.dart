import '../models/b2b_product.dart';

class PricingEvaluation {
  final int quantity;
  final PriceTier? applicableTier;
  final int? reachedTierIndex;
  final double unitPrice;
  final double subtotal;
  final bool isBelowMoq;
  final bool exceedsStock;
  final String? moqWarningMessage;
  final String? stockWarningMessage;
  final double savingsPerUnit;
  final double totalSavings;

  const PricingEvaluation({
    required this.quantity,
    required this.applicableTier,
    required this.reachedTierIndex,
    required this.unitPrice,
    required this.subtotal,
    required this.isBelowMoq,
    required this.exceedsStock,
    this.moqWarningMessage,
    this.stockWarningMessage,
    required this.savingsPerUnit,
    required this.totalSavings,
  });

  bool get isValidForQuote => quantity > 0 && !isBelowMoq && !exceedsStock;
}

class PricingEngine {
  const PricingEngine._();

  static PriceTier? findApplicableTier(List<PriceTier> tiers, int quantity) {
    if (quantity <= 0 || tiers.isEmpty) return null;

    for (final tier in tiers) {
      final matchesMin = quantity >= tier.minQty;
      final matchesMax = tier.maxQty == null || quantity <= tier.maxQty!;
      if (matchesMin && matchesMax) {
        return tier;
      }
    }

    if (quantity < tiers.first.minQty) {
      return tiers.first;
    }

    return tiers.last;
  }

  static PricingEvaluation evaluate(B2BProduct product, int quantity) {
    if (quantity <= 0 || product.tiers.isEmpty) {
      return PricingEvaluation(
        quantity: 0,
        applicableTier: null,
        reachedTierIndex: null,
        unitPrice: product.baseUnitPrice,
        subtotal: 0.0,
        isBelowMoq: false,
        exceedsStock: false,
        savingsPerUnit: 0.0,
        totalSavings: 0.0,
      );
    }

    final belowMoq = quantity < product.moq;
    final overStock = quantity > product.stock;

    int? reachedIndex;
    for (int i = 0; i < product.tiers.length; i++) {
      final tier = product.tiers[i];
      final matchesMin = quantity >= tier.minQty;
      final matchesMax = tier.maxQty == null || quantity <= tier.maxQty!;
      if (matchesMin && matchesMax) {
        reachedIndex = i;
        break;
      }
    }

    final tier = findApplicableTier(product.tiers, quantity)!;
    final unitPrice = tier.unitPrice;
    final subtotal = double.parse((unitPrice * quantity).toStringAsFixed(2));
    final savingsUnit = double.parse(
      (product.baseUnitPrice - unitPrice)
          .clamp(0.0, double.infinity)
          .toStringAsFixed(2),
    );
    final totalSavings =
        double.parse((savingsUnit * quantity).toStringAsFixed(2));

    String? moqWarning;
    if (belowMoq) {
      final missing = product.moq - quantity;
      moqWarning =
          'Cantidad inferior al pedido mínimo (MOQ: ${product.moq} ${product.unit}). Faltan $missing.';
    }

    String? stockWarning;
    if (overStock) {
      stockWarning =
          'Supera el stock disponible (${product.stock} ${product.unit}).';
    }

    return PricingEvaluation(
      quantity: quantity,
      applicableTier: tier,
      reachedTierIndex: reachedIndex,
      unitPrice: unitPrice,
      subtotal: subtotal,
      isBelowMoq: belowMoq,
      exceedsStock: overStock,
      moqWarningMessage: moqWarning,
      stockWarningMessage: stockWarning,
      savingsPerUnit: savingsUnit,
      totalSavings: totalSavings,
    );
  }
}
