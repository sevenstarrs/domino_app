import 'package:flutter/foundation.dart';

/// State sederhana yang dipakai bersama Beranda & Menu.
/// true = Delivery, false = Takeaway. (Nanti bisa diganti Provider/Riverpod.)
class OrderState {
  OrderState._();
  static final ValueNotifier<bool> isDelivery = ValueNotifier<bool>(true);
}
