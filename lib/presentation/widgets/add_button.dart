import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool expanded;

  const AddButton({
    super.key,
    this.onPressed,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed ?? () {},
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            expanded ? double.infinity : 70,
            28,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          elevation: 0,
          backgroundColor: const Color(0xFF0C4A87),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Tambah',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );

    return expanded
        ? SizedBox(
            width: double.infinity,
            child: button,
          )
        : button;
  }
}