import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool expanded;

  const AddButton({super.key, this.onPressed, this.expanded = false});

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        minimumSize: Size(expanded ? double.infinity : 0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 18),
      ),
      child: const Text('Tambah',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
