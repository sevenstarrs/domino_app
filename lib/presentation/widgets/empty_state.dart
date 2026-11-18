
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar ikon motor
          Image.asset(
            'assets/images/ikon aktivitas.png',
            width: 160,
            height: 160,
            fit: BoxFit.contain,
          ),

          const SizedBox(height: 36),

          // Judul
          const Text(
            'Ayo pesan\npizza',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 24),

          // Deskripsi
          const Text(
            'Kami akan sangat senang melayani Anda!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
