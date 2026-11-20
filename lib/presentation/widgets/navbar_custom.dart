import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Bottom navbar custom: ikon + label + garis bawah tab aktif dengan glow biru.
///
/// Semua jarak memakai nilai tetap (dp) di dalam widget ini, dan area gesture/
/// tombol sistem ditangani SafeArea, jadi spasinya sama di semua HP.
/// Ubah angka di bagian "KONSTANTA" kalau mau geser-geser spasinya.
class GlowBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlowBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // ---------- KONSTANTA ----------
  static const double _topPad = 10; // atas ikon
  static const double _iconSize = 28;
  static const double _iconLabelGap = 4; // ikon -> label
  static const double _labelBarGap = 12; // label -> garis
  static const double _barHeight = 5;
  static const double _bottomPad = 14; // garis -> tepi bawah
  static const double _barWidthFactor = 0.85; // lebar garis dari lebar tab
  static const Color _inactive = Color(0xFF666666);
  static const Color _glow = Color(0x594A9BE0);
  // --------------------------------

  static const _items = <_NavItem>[
    _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded),
    _NavItem('Menu', Icons.local_pizza_outlined, Icons.local_pizza),
    _NavItem('Aktivitas', Icons.newspaper_outlined, Icons.newspaper),
    _NavItem('Profil', Icons.account_circle_outlined, Icons.account_circle),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(top: _topPad, bottom: _bottomPad),
          child: LayoutBuilder(
            builder: (context, c) {
              final tabW = c.maxWidth / _items.length;
              final barW = tabW * _barWidthFactor;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // garis + glow (digambar paling bawah supaya tidak menimpa teks)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    left: tabW * currentIndex + (tabW - barW) / 2,
                    bottom: 0,
                    width: barW,
                    height: _barHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(_barHeight),
                        boxShadow: const [
                          BoxShadow(
                            color: _glow,
                            blurRadius: 22,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // ikon + label
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: _barHeight + _labelBarGap,
                    ),
                    child: Row(
                      children: [
                        for (var i = 0; i < _items.length; i++)
                          Expanded(child: _buildItem(i)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int i) {
    final item = _items[i];
    final aktif = i == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(i),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            aktif ? item.selectedIcon : item.icon,
            size: _iconSize,
            color: aktif ? AppColors.primary : _inactive,
          ),
          const SizedBox(height: _iconLabelGap),
          Text(
            item.label,
            style: const TextStyle(fontSize: 14, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  const _NavItem(this.label, this.icon, this.selectedIcon);
}
