import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/empty_state.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _tab = 0; // 0 = Memesan, 1 = Pemberitahuan
  int _filter = 0;
  final _filters = const ['Semua', 'Sedang berlangsung', 'Selesai', 'Dijadwalkan'];

  Widget _segment() {
    Widget item(String label, int index) {
      final sel = _tab == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(label,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: sel ? Colors.white : Colors.black87)),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8)],
      ),
      child: Row(children: [item('Memesan', 0), item('Pemberitahuan', 1)]),
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final sel = i == _filter;
          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(_filters[i],
                  style: TextStyle(
                      fontSize: 16, color: sel ? Colors.white : Colors.black87)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text('Aktivitas',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            ),
            _segment(),
            if (_tab == 0) _filterChips(),
            Expanded(
              child: _tab == 0
                  ? const EmptyState()
                  : const Center(
                      child: Text('No Notification Found',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
