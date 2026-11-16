import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/rfq_providers.dart';

class OfflineSimulatorBar extends ConsumerWidget {
  const OfflineSimulatorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final simulateNoSignal =
        ref.watch(rfqDraftProvider.select((s) => s.simulateNoSignal));
    final isPendingSync =
        ref.watch(rfqDraftProvider.select((s) => s.draft.isPendingSync));

    final statusDotColor =
        simulateNoSignal ? const Color(0xFFF59E0B) : const Color(0xFF10B981);
    final statusHaloColor =
        simulateNoSignal ? const Color(0xFFFEF3C7) : const Color(0xFFD1FAE5);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: simulateNoSignal
              ? const Color(0xFFFDE68A)
              : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: statusHaloColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      simulateNoSignal ? 'Modo sin conexión' : 'Conectado',
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      simulateNoSignal
                          ? 'Guardado local seguro'
                          : 'Precios y catálogo al día',
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Simular Sin Señal',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Switch(
                    key: const Key('switch_simular_sin_senal'),
                    value: simulateNoSignal,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFFF59E0B),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFCBD5E1),
                    onChanged: (value) {
                      ref
                          .read(rfqDraftProvider.notifier)
                          .setSimulateNoSignal(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          if (isPendingSync) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: Color(0xFFD97706),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pendiente de Sincronización · Se enviará al conectar',
                      style: TextStyle(
                        color: Color(0xFFB45309),
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
