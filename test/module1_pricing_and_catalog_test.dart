import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica/data/repositories/catalog_repository.dart';
import 'package:prueba_tecnica/domain/models/b2b_product.dart';
import 'package:prueba_tecnica/domain/services/pricing_engine.dart';

void main() {
  group('Módulo 1 — Catálogo Semilla, Buscador SKU y Motor de Escalas (Tier Pricing / MOQ)', () {
    late List<B2BProduct> seedProducts;

    setUp(() {
      seedProducts = CatalogRepository.parseProductsFromJson(
        CatalogRepository.kFallbackSeedJson,
      );
    });

    test('1. Parsea correctamente los 3 productos ferreteros del JSON semilla oficial', () {
      expect(seedProducts.length, 3);

      final taladro = seedProducts[0];
      expect(taladro.id, 'prod-01');
      expect(taladro.sku, 'FER-TAL-800W');
      expect(taladro.moq, 5);
      expect(taladro.stock, 120);
      expect(taladro.tiers.length, 3);
      expect(taladro.tiers.last.maxQty, isNull);
      expect(taladro.tiers.last.unitPrice, 35.00);
    });

    test('2. Filtra productos por nombre o por código SKU (insensible a mayúsculas)', () {
      final bySku = CatalogRepository.filterByNameOrSku(seedProducts, 'fer-disc');
      expect(bySku.length, 1);
      expect(bySku.first.id, 'prod-02');

      final byName = CatalogRepository.filterByNameOrSku(seedProducts, 'Sanitario');
      expect(byName.length, 1);
      expect(byName.first.sku, 'CON-TUB-PVC2');

      final all = CatalogRepository.filterByNameOrSku(seedProducts, '   ');
      expect(all.length, 3);
    });

    test('3. Detecta cantidad inferior al MOQ y genera advertencia clara', () {
      final taladro = seedProducts.firstWhere((p) => p.id == 'prod-01');

      final eval = PricingEngine.evaluate(taladro, 3);

      expect(eval.isBelowMoq, isTrue);
      expect(eval.reachedTierIndex, isNull);
      expect(eval.unitPrice, 42.00);
      expect(eval.subtotal, 126.00);
      expect(eval.moqWarningMessage, contains('MOQ: 5 Unidad'));
      expect(eval.isValidForQuote, isFalse);
    });

    test('4. Calcula y resalta dinámicamente cada tramo por volumen (Tiers 1, 2 y 3)', () {
      final taladro = seedProducts.firstWhere((p) => p.id == 'prod-01');

      final tier1Eval = PricingEngine.evaluate(taladro, 5);
      expect(tier1Eval.isBelowMoq, isFalse);
      expect(tier1Eval.reachedTierIndex, 0);
      expect(tier1Eval.unitPrice, 42.00);
      expect(tier1Eval.subtotal, 210.00);
      expect(tier1Eval.totalSavings, 0.0);
      expect(tier1Eval.isValidForQuote, isTrue);

      final tier2Eval = PricingEngine.evaluate(taladro, 25);
      expect(tier2Eval.isBelowMoq, isFalse);
      expect(tier2Eval.reachedTierIndex, 1);
      expect(tier2Eval.unitPrice, 38.50);
      expect(tier2Eval.subtotal, 962.50);
      expect(tier2Eval.savingsPerUnit, 3.50);
      expect(tier2Eval.totalSavings, 87.50);

      final tier3Eval = PricingEngine.evaluate(taladro, 60);
      expect(tier3Eval.isBelowMoq, isFalse);
      expect(tier3Eval.reachedTierIndex, 2);
      expect(tier3Eval.unitPrice, 35.00);
      expect(tier3Eval.subtotal, 2100.00);
      expect(tier3Eval.savingsPerUnit, 7.00);
      expect(tier3Eval.totalSavings, 420.00);
    });

    test('5. Detecta exceso sobre el stock disponible', () {
      final taladro = seedProducts.firstWhere((p) => p.id == 'prod-01');

      final overStockEval = PricingEngine.evaluate(taladro, 125);
      expect(overStockEval.exceedsStock, isTrue);
      expect(overStockEval.stockWarningMessage, isNotNull);
      expect(overStockEval.isValidForQuote, isFalse);
    });
  });
}

