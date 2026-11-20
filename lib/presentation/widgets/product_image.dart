import 'package:flutter/material.dart';

/// Gambar produk. Kalau [image] diisi, tampil gambar dari asset.
/// Kalau kosong (atau file tidak ditemukan), tampil placeholder berwarna + ikon.
class ProductImage extends StatelessWidget {
  final Color color;
  final IconData icon;
  final double? height;
  final double? width;
  final double radius;
  final String? image; // [BARU] path asset, contoh 'assets/images/products/papi_duo.jpg'

  const ProductImage({
    super.key,
    required this.color,
    this.icon = Icons.local_pizza,
    this.height,
    this.width,
    this.radius = 12,
    this.image, // [BARU]
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder lama (gradient + ikon)
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
                //errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}