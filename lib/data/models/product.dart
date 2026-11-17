import 'package:flutter/material.dart';

/// Satu pilihan ukuran produk, misalnya "5 Pieces", "1 Liter", "390 ml".
class ProductSize {
  final String label;

  /// Harga untuk ukuran ini. Kalau kosong, memakai harga dasar produk.
  final int? price;

  /// Ikon di lingkaran kecil kartu ukuran.
  final IconData icon;
  final Color iconColor;

  /// Opsional: path gambar asset untuk menggantikan ikon.
  final String? image;

  const ProductSize(
    this.label, {
    this.price,
    this.icon = Icons.shopping_bag,
    this.iconColor = const Color(0xFFF0B429),
    this.image,
  });
}

/// Satu menu di dalam paket promo (mis. "Bread Stick" di Papi Uno).
/// Satu promo berisi beberapa PromoItem (biasanya 2).
class PromoItem {
  final String name;
  final String? image;
  final Color imageColor;
  final IconData imageIcon;

  /// Teks di bagian Size, mis. "8 Pieces" atau "Medium".
  final String size;
  final IconData sizeIcon;
  final Color sizeIconColor;
  final String? sizeImage;

  /// Teks di bagian Crust. Kosong = memakai nama menu.
  final String? crust;

  const PromoItem(
    this.name, {
    this.image,
    this.imageColor = const Color(0xFFB9BEC6),
    this.imageIcon = Icons.local_pizza,
    this.size = '1 Piece',
    this.sizeIcon = Icons.shopping_bag,
    this.sizeIconColor = const Color(0xFFF0B429),
    this.sizeImage,
    this.crust,
  });

  String get crustName => crust ?? name;
}

/// Satu pilihan topping pada pizza.
class Topping {
  final String name;

  /// true = "Bebas" (gratis dan tercentang dari awal).
  /// false = berbayar (tidak tercentang dari awal).
  final bool free;

  /// Harga topping berbayar. Kosong = memakai Product.toppingPrice.
  final int? price;

  /// Warna lingkaran kecil kalau belum ada gambar.
  final Color color;

  /// Opsional: path gambar asset untuk lingkaran kecil.
  final String? image;

  const Topping(
    this.name, {
    this.free = true,
    this.price,
    this.color = const Color(0xFFCDA27B),
    this.image,
  });
}

class Product {
  final String name;
  final String description;
  final int price;
  final int? originalPrice;
  final bool customizable;
  final Color imageColor; // placeholder, ganti dengan URL/asset gambar asli
  final IconData imageIcon;
  final String? image;

  /// Pilihan ukuran. Kosong = otomatis satu pilihan "1 Piece".
  final List<ProductSize> sizes;

  /// Index ukuran yang terpilih saat halaman detail dibuka.
  final int defaultSize;

  /// Teks di bagian "Crust". Kosong = memakai nama produk.
  final String? crust;

  /// Isi paket promo. Kalau diisi, tombol Tambah membuka halaman promo.
  final List<PromoItem> promoItems;

  /// Daftar topping. Kalau diisi, tombol Tambah membuka halaman pizza.
  final List<Topping> toppings;

  /// Batas jumlah topping yang boleh dipilih.
  final int maxToppings;

  /// Harga default per topping berbayar.
  final int toppingPrice;

  const Product({
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.customizable = true,
    this.imageColor = const Color(0xFFFF7A2F),
    this.imageIcon = Icons.local_pizza,
    this.image,
    this.sizes = const [],
    this.defaultSize = 0,
    this.crust,
    this.promoItems = const [],
    this.toppings = const [],
    this.maxToppings = 11,
    this.toppingPrice = 8182,
  });

  List<ProductSize> get sizeOptions =>
      sizes.isEmpty ? const [ProductSize('1 Piece')] : sizes;

  String get crustName => crust ?? name;
}