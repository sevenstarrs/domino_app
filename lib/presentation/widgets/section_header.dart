import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          InkWell(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text('Lihat semua',
                    style: TextStyle(color: AppColors.link, fontSize: 15)),
                Icon(Icons.chevron_right, color: AppColors.link, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
