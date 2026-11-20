import 'package:flutter/foundation.dart';
import '../cart_service.dart';
import '../models/product.dart';

/// Satu baris keranjang untuk ditampilkan di halaman Keranjang.
///
/// Sekarang berupa "potret" dari [CartLine] milik CartService, jadi selain
/// produk dan jumlah, ia juga membawa ukuran, harga satuan, dan catatan.
/// Kalau dibuat manual (mis. produk tambahan Extra Chili), harga satuan
/// otomatis memakai product.price.
class CartItem {
  final Product product;
  final int quantity;
  final String? sizeLabel;
  final int unitPrice;
  final String? note;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.sizeLabel,
    int? unitPrice,
    this.note,
  }) : unitPrice = unitPrice ?? product.price;

  int get total => unitPrice * quantity;
}

/// Pintu masuk keranjang untuk halaman Keranjang dan tombol "Tambah" cepat.
///
/// API lama tetap sama (items, totalQuantity, subtotal, add, increase,
/// decrease, remove, clear, addListener), tetapi datanya TIDAK disimpan di sini
/// lagi. Semua dibaca dan ditulis ke [CartService] supaya hanya ada satu
/// keranjang di seluruh aplikasi.
class CartManager extends ChangeNotifier {
  CartManager._() {
    // Setiap perubahan di CartService (mis. dari halaman detail produk)
    // otomatis memberi tahu pendengar CartManager (halaman Keranjang).
    CartService.instance.lines.addListener(notifyListeners);
  }

  static final CartManager instance = CartManager._();

  CartService get _service => CartService.instance;

  List<CartItem> get items => List.unmodifiable(
        _service.lines.value.map(
          (l) => CartItem(
            product: l.product,
            quantity: l.quantity,
            sizeLabel: l.sizeLabel,
            unitPrice: l.unitPrice,
            note: l.note,
          ),
        ),
      );

  int get totalQuantity => _service.totalItems;

  int get subtotal => _service.totalPrice;

  /// Tambah 1 produk (tombol "Tambah" cepat tanpa pilihan ukuran/topping).
  void add(Product product) => _service.add(product, 1);

  void increase(CartItem item) => _service.setQuantity(
        item.product,
        item.quantity + 1,
        sizeLabel: item.sizeLabel,
        note: item.note,
      );

  /// Kalau jumlah tinggal 1, baris dihapus.
  void decrease(CartItem item) => _service.setQuantity(
        item.product,
        item.quantity - 1,
        sizeLabel: item.sizeLabel,
        note: item.note,
      );

  void remove(CartItem item) => _service.remove(
        item.product,
        sizeLabel: item.sizeLabel,
        note: item.note,
      );

  void clear() => _service.clear();
}
