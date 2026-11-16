import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_tecnica/data/repositories/catalog_repository.dart';
import 'package:prueba_tecnica/main.dart';
import 'package:prueba_tecnica/presentation/providers/rfq_providers.dart';

void main() {
  testWidgets(
      'Módulo 5.1 — Flujo UI Completo de 2 Pantallas (Catálogo B2B + Borrador Resiliente + Sin Señal)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(
            const CatalogRepository(simulatedLatency: Duration(milliseconds: 50)),
          ),
          submissionLatencyProvider.overrideWithValue(
            const Duration(milliseconds: 50),
          ),
        ],
        child: const TmfB2BApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('SKU: FER-TAL-800W'), findsOneWidget);
    expect(find.text('SKU: FER-DISC-45'), findsOneWidget);

    final addFirstProductBtn = find.text('Agregar').first;
    expect(addFirstProductBtn, findsOneWidget);
    await tester.tap(addFirstProductBtn);
    await tester.pumpAndSettle();

    final minusFirstProductBtn = find.byIcon(Icons.remove_rounded).first;
    expect(minusFirstProductBtn, findsOneWidget);
    await tester.tap(minusFirstProductBtn);
    await tester.pumpAndSettle();

    expect(find.textContaining('Cantidad inferior al pedido mínimo'), findsOneWidget);
    expect(find.text('Corrige MOQ'), findsOneWidget);
    final blockedBtn = tester.widget<FilledButton>(
      find.byKey(const Key('btn_ver_borrador_bottom')),
    );
    expect(blockedBtn.onPressed, isNull);

    await tester.tap(find.text('Subir a 5'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Cantidad inferior al pedido mínimo'), findsNothing);
    expect(find.text('TRAMO ACTIVO'), findsOneWidget);
    expect(find.text('Enviar Pedido'), findsOneWidget);

    await tester.tap(find.byKey(const Key('btn_ver_borrador_bottom')));
    await tester.pumpAndSettle();

    expect(find.text('Borrador de Cotización (RFQ)'), findsOneWidget);

    await tester.tap(find.byKey(const Key('switch_simular_sin_senal')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_enviar_cotizacion')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Pendiente de Sincronización'),
      findsWidgets,
    );

    await tester.tap(find.byKey(const Key('switch_simular_sin_senal')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn_enviar_cotizacion')));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(find.text('RFQ-TMF-1001'), findsOneWidget);
  });

  testWidgets(
      'Módulo 5.2 — Prueba de estrés responsiva en ancho compacto 360x800 (Cero RenderFlex Overflow en TECNO KJ5)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(
            const CatalogRepository(simulatedLatency: Duration(milliseconds: 50)),
          ),
        ],
        child: const TmfB2BApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('SKU: FER-TAL-800W'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('SKU: FER-DISC-45'), findsOneWidget);

    await tester.tap(find.byKey(const Key('btn_ir_borrador_appbar')));
    await tester.pumpAndSettle();
    expect(find.text('Borrador de Cotización (RFQ)'), findsOneWidget);
  });
}
