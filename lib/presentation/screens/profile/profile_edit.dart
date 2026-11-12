import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'profile_edit.dart';

class _MenuRow {
  final IconData icon;
  final Color color;
  final String title;
  final String? trailing;

  const _MenuRow(this.icon, this.color, this.title, [this.trailing]);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _akun = [
    _MenuRow(Icons.location_on, AppColors.red, 'Alamat'),
    _MenuRow(Icons.confirmation_number, AppColors.red, 'Voucher'),
    _MenuRow(Icons.favorite, AppColors.red, 'Favorit'),
    _MenuRow(Icons.newspaper, AppColors.red, 'Aktivitas'),
  ];

  static const _tentang = [
    _MenuRow(Icons.translate, AppColors.orange, 'Bahasa', 'Indonesia'),
    _MenuRow(Icons.info, AppColors.orange, 'Pusat Bantuan'),
    _MenuRow(Icons.newspaper, AppColors.orange, 'Berita dan Pembaruan'),
  ];

  static const _legal = [
    _MenuRow(Icons.shield, AppColors.primary, 'Kebijakan Privasi'),
    _MenuRow(Icons.copy, AppColors.primary, 'Ketentuan Layanan'),
    _MenuRow(Icons.call, AppColors.primary, 'Hubungi kami'),
  ];

  Widget _group(
    String title,
    List<_MenuRow> rows,
    double fontSize,
    double iconSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 7),
          child: Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -2),
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 4,
                  leading: Icon(
                    rows[i].icon,
                    color: rows[i].color,
                    size: iconSize,
                  ),
                  title: Text(
                    rows[i].title,
                    style: TextStyle(fontSize: fontSize - 1),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rows[i].trailing != null)
                        Text(
                          rows[i].trailing!,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize - 1,
                          ),
                        ),
                      Icon(Icons.chevron_right, size: iconSize + 2),
                    ],
                  ),
                  onTap: () {},
                ),
                if (i != rows.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth < 360 ? 12.0 : 16.0;
    final fontSize = screenWidth < 360 ? 13.0 : 14.0;
    final iconSize = screenWidth < 360 ? 18.0 : 20.0;
    final avatarRadius = screenWidth < 360 ? 25.0 : 28.0;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12,
          ),
          children: [
            Text(
              'Profil',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 18),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF7DB4E6), width: 1.5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: const Color(0xFFB8E37E),
                    child: Text(
                      'T',
                      style: TextStyle(
                        fontSize: avatarRadius,
                        color: const Color(0xFF3F9A00),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Domino's Lovers",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth < 360 ? 15 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text('-', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEdit(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chevron_right, size: 22),
                  ),
                ],
              ),
            ),

            _group('Akun', _akun, fontSize, iconSize),
            _group('Tentang', _tentang, fontSize, iconSize),
            _group('Legal', _legal, fontSize, iconSize),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 70),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.red,
                    ),
                  ),
                ),
                const Text(
                  'v15.0.21',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
