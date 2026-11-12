import 'package:flutter/material.dart';

/// Placeholder gambar produk. Ganti isi dengan Image.network / Image.asset
/// saat sudah punya gambar asli.
class ProductImage extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double? height;
  final double? width;
  final double radius;

  const ProductImage({
    super.key,
    required this.color,
    this.icon = Icons.local_pizza,
    this.height,
    this.width,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.75), color],
          ),
        ),
        child: Center(
          child: Icon(icon, size: 56, color: Colors.white.withOpacity(0.9)),
        ),
      ),
    );
  }
}
