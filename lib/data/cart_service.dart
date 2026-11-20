import 'package:flutter/foundation.dart';
import 'models/product.dart';

/// Format harga: 10000 -> "Rp 10.000"
String rupiahText(int value) {
  final s = value.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return 'Rp $b';
}

class CartLine {
  final Product product;
  final int quantity;
  final String? sizeLabel;
  final int unitPrice;
  final String? note;

  const CartLine(
    this.product,
    this.quantity, {
    this.sizeLabel,
    required this.unitPrice,
    this.note,
  });

  int get total => unitPrice * quantity;
}

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final ValueNotifier<List<CartLine>> lines = ValueNotifier<List<CartLine>>([]);

  int get totalItems => lines.value.fold(0, (sum, l) => sum + l.quantity);
  int get totalPrice => lines.value.fold(0, (sum, l) => sum + l.total);

  bool _same(CartLine l, Product p, String? sizeLabel, String? note) =>
      l.product.name == p.name && l.sizeLabel == sizeLabel && l.note == note;

  int quantityOf(Product p) {
    var total = 0;
    for (final l in lines.value) {
      if (l.product.name == p.name) total += l.quantity;
    }
    return total;
  }

  void add(
    Product p,
    int qty, {
    String? sizeLabel,
    int? unitPrice,
    String? note,
  }) {
    final price = unitPrice ?? p.price;
    final list = [...lines.value];
    final i = list.indexWhere((l) => _same(l, p, sizeLabel, note));
    if (i >= 0) {
      list[i] = CartLine(
        p,
        list[i].quantity + qty,
        sizeLabel: sizeLabel,
        unitPrice: price,
        note: note,
      );
    } else {
      list.add(CartLine(
        p,
        qty,
        sizeLabel: sizeLabel,
        unitPrice: price,
        note: note,
      ));
    }
    lines.value = list;
  }

  void setQuantity(Product p, int qty, {String? sizeLabel, String? note}) {
    if (qty <= 0) {
      remove(p, sizeLabel: sizeLabel, note: note);
      return;
    }
    final list = [...lines.value];
    final i = list.indexWhere((l) => _same(l, p, sizeLabel, note));
    if (i >= 0) {
      list[i] = CartLine(
        p,
        qty,
        sizeLabel: sizeLabel,
        unitPrice: list[i].unitPrice,
        note: note,
      );
      lines.value = list;
    }
  }

  void remove(Product p, {String? sizeLabel, String? note}) {
    lines.value =
        lines.value.where((l) => !_same(l, p, sizeLabel, note)).toList();
  }

  void clear() => lines.value = [];
}

class FavoriteService {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  final ValueNotifier<Set<String>> names = ValueNotifier<Set<String>>({});

  bool isFavorite(String name) => names.value.contains(name);

  void toggle(String name) {
    final next = {...names.value};
    if (!next.add(name)) next.remove(name);
    names.value = next;
  }
}