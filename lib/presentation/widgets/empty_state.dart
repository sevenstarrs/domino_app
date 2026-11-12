import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFD4F0A8), Color(0xFFA6DC6B)],
              ),
            ),
            child: const Icon(Icons.moped, size: 64, color: Color(0xFF3F9A00)),
          ),
          const SizedBox(height: 28),
          const Text('Ayo pesan\npizza',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, height: 1.2)),
          const SizedBox(height: 16),
          const Text('Kami akan sangat senang melayani Anda!',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
