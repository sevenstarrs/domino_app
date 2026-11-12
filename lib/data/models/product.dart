import 'package:flutter/material.dart';

class Product {
  final String name;
  final String description;
  final int price;
  final int? originalPrice;
  final bool customizable;
  final Color imageColor; // placeholder, ganti dengan URL/asset gambar asli
  final IconData imageIcon;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.customizable = true,
    this.imageColor = const Color(0xFFFF7A2F),
    this.imageIcon = Icons.local_pizza,
  });
}
