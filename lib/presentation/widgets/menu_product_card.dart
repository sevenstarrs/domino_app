import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/cart_service.dart';
import '../../data/models/product.dart';
import '../../data/cart/cart_manager.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/menu/product_detail_screen.dart';
import 'add_button.dart';
import 'price_text.dart';
import 'product_image.dart';

class MenuProductCard extends StatelessWidget {
  final Product product;

  /// true = tombol "Tambah" membuka halaman detail (pilih ukuran/topping),
  ///        lalu masuk keranjang lewat CartService. Tampil "N barang" kalau
  ///        produk sudah ada di keranjang.
  /// false = tombol "Tambah" langsung menambah 1 item ke keranjang
  ///         dan membuka halaman Keranjang.
  final bool enableDetail;

  const MenuProductCard({
    super.key,
    required this.product,
    this.enableDetail = false,
  });

  // Mode cepat: tambah 1 item lalu buka halaman Keranjang.
  void _tambahKeKeranjang(BuildContext context) {
    CartManager.instance.add(product);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  // Mode detail: buka halaman detail produk.
  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }

  // Tombol "Tambah" memakai AddButton asli. Kalau produk sudah ada di
  // keranjang, tampil "N barang" dengan ukuran yang sama.
  Widget _actionButton(BuildContext context) {
    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: CartService.instance.lines,
      builder: (_, _, _) {
        final qty = CartService.instance.quantityOf(product);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openDetail(context),
          child: qty == 0
              ? const IgnorePointer(child: AddButton())
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    const Opacity(
                      opacity: 0,
                      child: IgnorePointer(child: AddButton()),
                    ),
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$qty barang',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            color: product.imageColor,
            icon: product.imageIcon,
            image: product.image,
            height: 128,
            width: double.infinity,
          ),
          const SizedBox(height: 12),

          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            product.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color.fromARGB(255, 120, 120, 120),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 1),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PriceText(
                  price: product.price,
                  originalPrice: product.originalPrice,
                ),
              ),

              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  enableDetail
                      ? _actionButton(context)
                      : AddButton(
                          onPressed: () => _tambahKeKeranjang(context),
                        ),

                  if (product.customizable) ...[
                    const SizedBox(height: 4),

                    const Text(
                      'Dapat disesuaikan',
                      style: TextStyle(
                        color: Color.fromARGB(255, 120, 120, 120),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );

    if (!enableDetail) return card;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openDetail(context),
      child: card,
    );
  }
}
