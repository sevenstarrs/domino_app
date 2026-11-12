import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/product.dart';
import 'add_button.dart';
import 'price_text.dart';
import 'product_image.dart';

/// Kartu produk untuk list horizontal (Today's Special, Paket Hemat, Paket Party)
class HorizontalProductCard extends StatelessWidget {
  final Product product;
  final double width;

  const HorizontalProductCard({
    super.key,
    required this.product,
    this.width = 225,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            color: product.imageColor,
            icon: product.imageIcon,
            height: 150,
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          Text(product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(product.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
          const SizedBox(height: 6),
          // SizedBox supaya tinggi area harga konsisten walau tanpa harga coret
          SizedBox(
            height: 46,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: PriceText(
                  price: product.price, originalPrice: product.originalPrice),
            ),
          ),
          const Spacer(),
          const AddButton(expanded: true),
        ],
      ),
    );
  }
}
