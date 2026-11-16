import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/rfq_providers.dart';
import '../widgets/offline_simulator_bar.dart';
import '../widgets/product_tier_card.dart';
import 'rfq_draft_screen.dart';

class B2BCatalogScreen extends ConsumerStatefulWidget {
  const B2BCatalogScreen({super.key});

  @override
  ConsumerState<B2BCatalogScreen> createState() => _B2BCatalogScreenState();
}

class _B2BCatalogScreenState extends ConsumerState<B2BCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDraftScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RfqDraftScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogProvider);
    final draftState = ref.watch(rfqDraftProvider);
    final grandTotal =
        draftState.calculateGrandTotal(catalogState.allProducts);
    final hasInvalidMoq =
        draftState.hasAnyInvalidQuantity(catalogState.allProducts);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        titleSpacing: 16,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MAYORISTAS',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2563EB),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                'Tu Mercado Ferretero',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              key: const Key('btn_ir_borrador_appbar'),
              borderRadius: BorderRadius.circular(24),
              onTap: hasInvalidMoq ? null : _openDraftScreen,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: hasInvalidMoq
                      ? const Color(0xFFFEF2F2)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: hasInvalidMoq
                        ? const Color(0xFFFECACA)
                        : const Color(0xFFBFDBFE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasInvalidMoq
                          ? Icons.block_rounded
                          : Icons.shopping_bag_outlined,
                      size: 17,
                      color: hasInvalidMoq
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mi Pedido',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: hasInvalidMoq
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF1D4ED8),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: hasInvalidMoq
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${draftState.distinctProductsCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineSimulatorBar(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                key: const Key('search_sku_or_name_field'),
                controller: _searchController,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText:
                      'Buscar producto o código (ej. Taladro, FER-TAL-800W)',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  suffixIcon: catalogState.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: Color(0xFF64748B),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(catalogProvider.notifier)
                                .setSearchQuery('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onChanged: (value) {
                  ref.read(catalogProvider.notifier).setSearchQuery(value);
                },
              ),
            ),
          ),

          Expanded(
            child: catalogState.isLoading
                ? const Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text(
                            'Cargando catálogo mayorista...',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : catalogState.filteredProducts.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: Color(0xFFCBD5E1),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sin resultados para "${catalogState.searchQuery}"',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
                            child: SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  const Text(
                                    'Catálogo Destacado',
                                    style: TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  if (draftState.submittedQuotes.isNotEmpty)
                                    InkWell(
                                      onTap: _openDraftScreen,
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFECFDF5),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: Text(
                                          '${draftState.submittedQuotes.length} enviada(s) · ${draftState.submittedQuotes.first.quoteCode}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF059669),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    const Text(
                                      'Precios por escala',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          ...catalogState.filteredProducts.map(
                            (product) => ProductTierCard(
                              key: ValueKey(product.id),
                              product: product,
                            ),
                          ),
                        ],
                      ),
          ),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Total estimado',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '\$${grandTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'USD',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      key: const Key('btn_ver_borrador_bottom'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        disabledForegroundColor: const Color(0xFF64748B),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      onPressed: (hasInvalidMoq ||
                              draftState.distinctProductsCount == 0)
                          ? null
                          : _openDraftScreen,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hasInvalidMoq ? 'Corrige MOQ' : 'Enviar Pedido',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            hasInvalidMoq
                                ? Icons.block_rounded
                                : Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
