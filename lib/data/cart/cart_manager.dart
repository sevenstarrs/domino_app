
import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class CartManager extends ChangeNotifier {
  CartManager._();

  static final CartManager instance = CartManager._();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalQuantity =>
      _items.fold(0, (total, item) => total + item.quantity);

  int get subtotal =>
      _items.fold(0, (total, item) => total + item.product.price * item.quantity);

  void add(Product product) {
    final index = _items.indexWhere(
      (item) => identical(item.product, product),
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
