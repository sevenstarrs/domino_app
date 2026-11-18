
import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final int price;
  final int? originalPrice;
  final bool customizable;

  // URL gambar produk dari internet
  final String? imageUrl;

  // Placeholder jika gambar belum tersedia
  final Color imageColor;
  final IconData imageIcon;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.customizable = true,
    this.imageUrl,
    this.imageColor = const Color(0xFFFF7A2F),
    this.imageIcon = Icons.local_pizza,
  });
}
