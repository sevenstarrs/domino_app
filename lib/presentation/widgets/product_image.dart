import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double? height;
  final double? width;
  final double radius;
  final String? image; 

  const ProductImage({
    super.key,
    required this.color,
    this.icon = Icons.local_pizza,
    this.height,
    this.width,
    this.radius = 12,
    this.image, 
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.75), color],
        ),
      ),
      child: Center(
        child: Icon(icon, size: 56, color: Colors.white.withValues(alpha: 0.9)),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: width,
        child: image == null
            ? placeholder
            : Image.asset(
                image!,
                fit: BoxFit.cover,
                cacheWidth: 800,
              ),
      ),
    );
  }
}