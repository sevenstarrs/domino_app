import 'package:flutter/material.dart';
import '../../data/cart_service.dart';
import '../screens/cart/cart_screen.dart';

/// Bar hijau "N barang di keranjang" di bagian bawah layar.
/// Muncul kalau keranjang tidak kosong; diketuk -> buka halaman Keranjang.
/// Dipakai di Beranda (tampilannya sama dengan bar di tab Menu).
class CartBar extends StatelessWidget {
  const CartBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartLine>>(
      valueListenable: CartService.instance.lines,
      builder: (_, _, _) {
        final count = CartService.instance.totalItems;
        if (count == 0) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4D8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF6BAA3F),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '$count barang di keranjang',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      rupiahText(CartService.instance.totalPrice),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, size: 22),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
