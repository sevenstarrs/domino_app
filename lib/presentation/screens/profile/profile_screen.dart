import 'package:flutter/material.dart';

import '../../../core/state/profile_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user_profile.dart';
import 'profile_edit.dart';

class _MenuRow {
  final String image;
  final String title;
  final String? trailing;

  const _MenuRow(this.image, this.title, [this.trailing]);
}

// HEADER PROFIL: data dari SQLite, seluruh kartu bisa ditekan
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild otomatis tiap profil di database berubah (create/update/delete)
    return ValueListenableBuilder<UserProfile?>(
      valueListenable: ProfileState.current,
      builder: (context, profil, _) {
        final subtitle = profil == null
            ? '-'
            : (profil.email ?? '').isNotEmpty
            ? profil.maskedEmail
            : ((profil.phone ?? '').isNotEmpty ? profil.phone! : '-');

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileEdit()),
            );
          },
          child: Ink(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF7DB4E6), width: 2),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFFB8E37E),
                  child: Text(
                    profil?.initial ?? 'T',
                    style: const TextStyle(
                      fontSize: 36,
                      color: Color(0xFF3F9A00),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profil?.name ?? "Domino's Lovers",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _akun = [
    _MenuRow('assets/icons/titik.png', 'Alamat'),
    _MenuRow('assets/icons/tiket merah.png', 'Voucher'),
    _MenuRow('assets/icons/hati.png', 'Favorit'),
    _MenuRow('assets/icons/berita merah.png', 'Aktivitas'),
  ];

  static const _tentang = [
    _MenuRow('assets/icons/bahasa.png', 'Bahasa', 'Indonesia'),
    _MenuRow('assets/icons/info kuning.png', 'Pusat Bantuan'),
    _MenuRow('assets/icons/berita kuning.png', 'Berita dan Pembaruan'),
  ];

  static const _legal = [
    _MenuRow('assets/icons/perisai.png', 'Kebijakan Privasi'),
    _MenuRow('assets/icons/dokumen biru.png', 'Ketentuan Layanan'),
    _MenuRow('assets/icons/telepon.png', 'Hubungi kami'),
  ];

  Widget _group(String title, List<_MenuRow> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
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
                  leading: Image.asset(
                    rows[i].image,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                  ),
                  title: Text(
                    rows[i].title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (rows[i].trailing != null)
                        Text(
                          rows[i].trailing!,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
            const Text(
              'Profil',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 28),

            const ProfileHeader(),

            _group('Akun', _akun),

            _group('Tentang', _tentang),

            _group('Legal', _legal),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 90),

                // Teks ikut status akun: belum ada profil / sudah dihapus -> Masuk,
                // sudah ada profil (akun dibuat & data terisi) -> Keluar
                ValueListenableBuilder<UserProfile?>(
                  valueListenable: ProfileState.current,
                  builder: (context, profil, _) => TextButton(
                    onPressed: () {},
                    // Garis bawah dibuat dari border supaya ada jarak ke teks
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 3),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.red, width: 1),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          profil == null ? 'Masuk' : 'Keluar',
                          style: const TextStyle(
                            color: AppColors.red,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Text(
                  'v15.0.21',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
