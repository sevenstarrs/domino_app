import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/product.dart';
import 'add_button.dart';
import 'price_text.dart';
import 'product_image.dart';

/// Item vertikal: gambar kiri, info kanan (Paket Pizza)
class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            color: product.imageColor,
            height: 110,
            width: 110,
            radius: 14,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(product.description,
                    style: const TextStyle(
                        color: AppColors.textGrey, fontSize: 14.5)),
                const SizedBox(height: 8),
                PriceText(
                    price: product.price, originalPrice: product.originalPrice),
                Align(
                  alignment: Alignment.centerRight,
                  child: const AddButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
