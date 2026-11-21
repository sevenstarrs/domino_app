import 'package:flutter/material.dart';
import '../../../data/menu_data.dart';
import '../../../data/models/product.dart';
import '../../widgets/menu_product_card.dart';
import '../../widgets/navbar_custom.dart';
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

      bottomNavigationBar: GlowBottomNav(
        currentIndex: 1, // tab Menu
        onTap: _goToTab,
      ),
    );
  }
}
