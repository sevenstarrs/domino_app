import 'package:flutter/material.dart';
import '../../../data/menu_data.dart';
import '../../../data/models/product.dart';
import '../../widgets/menu_product_card.dart';
import '../main_shell.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';
  @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

  void _goToTab(int index) {
    shellIndex.value = index;
    Navigator.pop(context);
  }

  List<Product> get allProducts {
    final List<Product> products = [];

    for (final item in MenuData.menuProducts.values) {
      products.addAll(item);
    }

    for (final item in MenuData.productsBySubCategory.values) {
      products.addAll(item);
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where((product) {
      final text =
          '${product.name} ${product.description}'.toLowerCase();

      return text.contains(query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // HEADER SEARCH
            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                24,
                14,
                25,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: Color.fromARGB(255, 162, 162, 162),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _controller,
                        textAlignVertical: TextAlignVertical.center,
                        autofocus: true,
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Mencari...',
                          hintStyle: const TextStyle(
                            color: Color(0xFFB4B4B4),
                            fontSize: 15,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFF9E9E9E),
                          ),

                          suffixIcon: IconButton(
                            onPressed: () {
                              _controller.clear();
                              setState(() {
                                query = '';
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),

                          filled: true,
                          fillColor: Colors.white,

                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E1E1),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE1E1E1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFE5E5E5),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  110,
                ),
                itemCount: filteredProducts.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: 26),
                itemBuilder: (_, index) {
                  return MenuProductCard(
                    product: filteredProducts[index],
                    enableDetail: true,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        height: 92,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [
                  _MenuItem(
                    icon: Icons.home_outlined,
                    label: 'Beranda',
                    selected: false,
                    onTap: () => _goToTab(0), 
                  ),
                  _MenuItem(
                    icon: Icons.local_pizza_outlined,
                    label: 'Menu',
                    selected: true,
                    onTap: () => _goToTab(1), 
                  ),
                  _MenuItem(
                    icon: Icons.receipt_long_outlined,
                    label: 'Aktivitas',
                    selected: false,
                    onTap: () => _goToTab(2), 
                  ),
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'Profil',
                    selected: false,
                    onTap: () => _goToTab(3), 
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, 
      onTap: onTap,
      child: SizedBox(
      width: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: selected
                      ? const Color(0xFF003B71)
                      : const Color(0xFF8A8A8A),
                ),

                const SizedBox(height: 4),

                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF003B71),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (selected)
            Positioned(
              bottom: 14,
              child: Container(
                width: 78,
                height: 4,
                decoration: BoxDecoration(
                  color: selected
                  ? const Color(0xFF003B71)
                  : const Color(0xFF8A8A8A),
                  borderRadius:
                      BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(102, 1, 69, 132),
                      blurRadius: 20,
                      spreadRadius: 4.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }