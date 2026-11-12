import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatter.dart';

class PriceText extends StatelessWidget {
  final int price;
  final int? originalPrice;

  const PriceText({super.key, required this.price, this.originalPrice});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (originalPrice != null)
          Text(
            rupiah(originalPrice!),
            style: const TextStyle(
              color: AppColors.strike,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.strike,
            ),
          ),
        Text(
          rupiah(price),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
