import 'package:flutter/material.dart';
import '../../data/dummy_data.dart';

class CategoryGrid extends StatelessWidget {
  final ValueChanged<String>? onTap;
  const CategoryGrid({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = DummyData.categories;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, i) {
          final c = items[i];
          return InkWell(
            onTap: () => onTap?.call(c.label),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFFD9D9D9),
                  child: Icon(c.icon, color: c.color, size: 28),
                ),
                const SizedBox(height: 8),
                Text(c.label, style: const TextStyle(fontSize: 15)),
              ],
            ),
          );
        },
      ),
    );
  }
}
