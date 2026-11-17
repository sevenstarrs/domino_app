import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';
import '../../../data/models/product.dart';
import '../../../data/cart_service.dart';
import '../../widgets/menu_product_card.dart';
import 'search_screen.dart';
import 'location_screen.dart';
import '../main_shell.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _cat = 0;
  int _sub = 0;

  // Kategori yang tombol "Tambah"-nya membuka halaman detail
  static const _detailCategories = {'Promo', 'Pizza', 'Sides', 'Bread', 'Wings', 'Dessert', 'Drinks'};
  final ScrollController _categoryController = ScrollController();

  // PageView mengikuti jari saat di-swipe
  final PageController _pageController = PageController();

  // true selama animasi pindah halaman dari tap kategori / sub tab,
  // supaya onPageChanged tidak mengubah _cat/_sub di halaman yang dilewati
  bool _isAnimating = false;

  // Daftar datar semua halaman: (indexKategori, indexSubTab).
  // Contoh: Promo(0,0), Pizza(1,0..3), Sides(2,0..1), dst.
  late final List<(int, int)> _pageMap = _buildPageMap();

  List<(int, int)> _buildPageMap() {
    final cats = DummyData.categories.take(7).toList();
    final map = <(int, int)>[];

    for (var c = 0; c < cats.length; c++) {
      final subs = DummyData.subTabs[cats[c].label] ?? const <String>[];
      final count = subs.isEmpty ? 1 : subs.length;

      for (var s = 0; s < count; s++) {
        map.add((c, s));
      }
    }
    return map;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToCategory() {
    if (!_categoryController.hasClients) return;

    final offset = (_cat - 2) * 95.0;

    _categoryController.animateTo(
      offset < 0 ? 0 : offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Pindah ke kategori/sub tab tertentu (dipanggil saat di-tap)
  Future<void> _goTo(int cat, int sub) async {
    final target = _pageMap.indexOf((cat, sub));
    if (target < 0) return;

    setState(() {
      _cat = cat;
      _sub = sub;
    });
    _scrollToCategory();

    _isAnimating = true;
    await _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _isAnimating = false;
  }

  // Dipanggil PageView saat user selesai swipe
  void _onPageChanged(int index) {
    if (_isAnimating) return;

    final (c, s) = _pageMap[index];
    setState(() {
      _cat = c;
      _sub = s;
    });
    _scrollToCategory();
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              shellIndex.value = 0;
            },
            icon: const Icon(Icons.arrow_back),
          ),

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.red,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ambil di',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            "Domino's Pizza - Soebranta...",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchScreen(),
                ),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryRow(List cats) {
    return SizedBox(
      height: 105,
      child: ListView.separated(
        controller: _categoryController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cats.length,
        separatorBuilder: (_, _) => const SizedBox(width: 22),
        itemBuilder: (_, i) {
          final c = cats[i];
          final selected = i == _cat;

          return GestureDetector(
            onTap: () => _goTo(i, 0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD9D9D9),
                        border: selected
                            ? Border.all(
                                color: AppColors.green,
                                width: 3,
                              )
                            : null,
                      ),
                      child: c.image != null
                          ? ClipOval(
                              child: Image.asset(
                                c.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    Icon(c.icon, color: c.color, size: 30),
                              ),
                            )
                          : Icon(c.icon, color: c.color, size: 30),
                    ),
                    if (selected)
                      const Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: AppColors.green,
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  c.label,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _subTabs(List<String> tabs) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final selected = i == _sub;

          return GestureDetector(
            onTap: () => _goTo(_cat, i),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Satu halaman PageView = daftar produk saja
  Widget _buildPage(int index) {
    final cats = DummyData.categories.take(7).toList();
    final (c, s) = _pageMap[index];
    final label = cats[c].label;

    final subTabs = DummyData.subTabs[label] ?? const <String>[];

    final List<Product> products = subTabs.isNotEmpty
        ? (DummyData.productsBySubCategory[subTabs[s]] ?? const <Product>[])
        : (DummyData.menuProducts[label] ?? const <Product>[]);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: products.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        return MenuProductCard(
          product: products[i],
          enableDetail: _detailCategories.contains(label),
        );
      },
    );
  } // <-- penutup _buildPage

  // Bar hijau "N barang di keranjang" (muncul kalau keranjang tidak kosong)
  Widget _cartBar() {
    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: CartService.instance.lines,
      builder: (_, _, _) {
        final count = CartService.instance.totalItems;
        if (count == 0) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            child: GestureDetector(
              onTap: () {
              },
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4D8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6BAA3F),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$count barang di keranjang',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      rupiahText(CartService.instance.totalPrice),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, size: 22),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cats = DummyData.categories.take(7).toList();

    final subTabs =
        DummyData.subTabs[cats[_cat].label] ?? const <String>[];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),

            const SizedBox(height: 14),

            _categoryRow(cats),

            Container(
              height: 2,
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5E5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),

            if (subTabs.isNotEmpty)
              _subTabs(subTabs),

            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _pageMap.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (_, index) => _buildPage(index),
                  ), // penutup PageView
                  _cartBar(),
                ], // penutup children Stack
              ), // penutup Stack
            ), // penutup Expanded
          ],
        ),
      ),
    );
  }
}