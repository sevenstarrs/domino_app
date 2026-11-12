import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/product.dart';
import 'add_button.dart';
import 'price_text.dart';
import 'product_image.dart';

/// Kartu besar di halaman Menu
class MenuProductCard extends StatelessWidget {
  final Product product;
  const MenuProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImage(
            color: product.imageColor,
            icon: product.imageIcon,
            height: 190,
            width: double.infinity,
          ),
          const SizedBox(height: 12),
          Text(product.name,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(product.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceText(
                  price: product.price, originalPrice: product.originalPrice),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const AddButton(),
                  if (product.customizable) ...[
                    const SizedBox(height: 6),
                    const Text('Dapat disesuaikan',
                        style: TextStyle(color: AppColors.textGrey)),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
