import 'package:flutter/material.dart';

class CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final String? image; 
  const CategoryItem(this.label, this.icon, this.color, {this.image}); 
}
