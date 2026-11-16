import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/models/b2b_product.dart';

class CatalogRepository {
  final Duration simulatedLatency;

  const CatalogRepository({
    this.simulatedLatency = const Duration(milliseconds: 1500),
  });

  Future<List<B2BProduct>> fetchCatalogProducts() async {
    await Future.delayed(simulatedLatency);

    String jsonString;
    try {
      jsonString = await rootBundle.loadString(
        'assets/datos-semilla-mobile.json',
        cache: false,
      );
    } catch (_) {
      jsonString = kFallbackSeedJson;
    }

    return parseProductsFromJson(jsonString);
  }

  static List<B2BProduct> parseProductsFromJson(String jsonString) {
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => B2BProduct.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static List<B2BProduct> filterByNameOrSku(
    List<B2BProduct> products,
    String query,
  ) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return products;

    return products.where((product) {
      final matchesName = product.name.toLowerCase().contains(normalized);
      final matchesSku = product.sku.toLowerCase().contains(normalized);
      final matchesBrand = product.brand.toLowerCase().contains(normalized);
      return matchesName || matchesSku || matchesBrand;
    }).toList();
  }

  static const String kFallbackSeedJson = '''
[
  {
    "id": "prod-01",
    "sku": "FER-TAL-800W",
    "name": "Taladro Percutor Industrial 1/2\\" 800W",
    "brand": "Total Tools",
    "unit": "Unidad",
    "moq": 5,
    "stock": 120,
    "tiers": [
      { "minQty": 5, "maxQty": 19, "unitPrice": 42.00 },
      { "minQty": 20, "maxQty": 49, "unitPrice": 38.50 },
      { "minQty": 50, "maxQty": null, "unitPrice": 35.00 }
    ]
  },
  {
    "id": "prod-02",
    "sku": "FER-DISC-45",
    "name": "Disco de Corte Metal Inox 4-1/2\\" (Caja 25u)",
    "brand": "Norton",
    "unit": "Caja",
    "moq": 10,
    "stock": 500,
    "tiers": [
      { "minQty": 10, "maxQty": 49, "unitPrice": 18.00 },
      { "minQty": 50, "maxQty": 199, "unitPrice": 15.80 },
      { "minQty": 200, "maxQty": null, "unitPrice": 13.90 }
    ]
  },
  {
    "id": "prod-03",
    "sku": "CON-TUB-PVC2",
    "name": "Tubo PVC Sanitario 2 Pulgadas x 3 Metros",
    "brand": "Pavco",
    "unit": "Tubo",
    "moq": 20,
    "stock": 350,
    "tiers": [
      { "minQty": 20, "maxQty": 99, "unitPrice": 6.40 },
      { "minQty": 100, "maxQty": null, "unitPrice": 5.25 }
    ]
  }
]
''';
}
