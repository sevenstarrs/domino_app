import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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

  Widget _group(String title, List<_MenuRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 10),
          child: Text(title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 14,
                  leading: Icon(rows[i].icon, color: rows[i].color),
                  title: Text(rows[i].title, style: const TextStyle(fontSize: 16)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rows[i].trailing != null)
                        Text(rows[i].trailing!,
                            style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      const Icon(Icons.chevron_right),
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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Profil',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF7DB4E6), width: 2),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundColor: Color(0xFFB8E37E),
                    child: Text('T',
                        style: TextStyle(
                            fontSize: 36, color: Color(0xFF3F9A00))),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Domino's Lovers",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700)),
                        Text('-'),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                ],
              ),
            ),
            _group('Akun', _akun),
            _group('Tentang', _tentang),
            _group('Legal', _legal),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 90),
                TextButton(
                  onPressed: () {},
                  child: const Text('Masuk',
                      style: TextStyle(
                          color: AppColors.red,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.red)),
                ),
                const Text('v15.0.21',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
