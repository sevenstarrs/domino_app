import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';
import '../../widgets/menu_product_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _cat = 0;
  int _sub = 0;

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.red),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ambil di',
                            style: TextStyle(
                                color: AppColors.textGrey, fontSize: 13)),
                        Text("Domino's Pizza - Soebranta...",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _categoryRow(List cats) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          final c = cats[i];
          final selected = i == _cat;
          return GestureDetector(
            onTap: () => setState(() {
              _cat = i;
              _sub = 0;
            }),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD9D9D9),
                        border: selected
                            ? Border.all(color: AppColors.green, width: 3)
                            : null,
                      ),
                      child: Icon(c.icon, color: c.color, size: 30),
                    ),
                    if (selected)
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 9,
                          backgroundColor: AppColors.green,
                          child: Icon(Icons.check, size: 12, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(c.label, style: const TextStyle(fontSize: 15)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _subTabs(List<String> tabs) {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final sel = i == _sub;
          return GestureDetector(
            onTap: () => setState(() => _sub = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tabs[i],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: sel ? Colors.white : Colors.black87)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 7 kategori pertama (tanpa "See All")
    final cats = DummyData.categories.take(7).toList();
    final label = cats[_cat].label;
    final subs = DummyData.subTabs[label] ?? const <String>[];
    final products = DummyData.menuProducts[label] ?? const [];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            const SizedBox(height: 14),
            _categoryRow(cats),
            const Divider(height: 1),
            if (subs.isNotEmpty) _subTabs(subs),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) => MenuProductCard(product: products[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
