import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/cart_service.dart';
import '../../../data/models/product.dart';
import '../../widgets/product_image.dart';

const String kDefaultSizeImage = 'assets/images/bag.jpeg';
const String kDefaultCrustImage = 'assets/images/tiket.png';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  bool _loading = false;
  int _crustIndex = 0;
  late bool _favorite =
      FavoriteService.instance.isFavorite(widget.product.name);

  late int _sizeIndex = widget.product.defaultSize
      .clamp(0, widget.product.sizeOptions.length - 1)
      .toInt();

  late final Set<int> _selected = {
    for (var i = 0; i < widget.product.toppings.length; i++)
      if (widget.product.toppings[i].free) i,
  };

  bool get _isPromo => widget.product.promoItems.isNotEmpty;
  bool get _hasToppings => widget.product.toppings.isNotEmpty && _size.hasToppings;

  ProductSize get _size => widget.product.sizeOptions[_sizeIndex];

  List<CrustOption> get _crusts {
    final c = _size.crusts;
    return c.isEmpty ? [CrustOption(widget.product.crustName)] : c;
  }

  CrustOption get _crust =>
      _crusts[_crustIndex.clamp(0, _crusts.length - 1).toInt()];

  int _toppingPrice(Topping t) =>
      t.price ?? _size.toppingPrice ?? widget.product.toppingPrice;

  int get _extra {
    if (!_hasToppings) return 0;
    var sum = 0;
    for (final i in _selected) {
      final t = widget.product.toppings[i];
      if (!t.free) sum += _toppingPrice(t);
    }
    return sum;
  }

  int get _unitPrice =>
      (_size.price ?? widget.product.price) + _crust.price + _extra;
  int get _total => _unitPrice * _qty;

  String? get _note {
    if (_isPromo) {
      return widget.product.promoItems
          .map((i) => '${i.name} (${i.size})')
          .join(' + ');
    }
    final parts = <String>[];
    if (_crusts.length > 1) parts.add('Crust: ${_crust.name}');
    if (_hasToppings && _selected.isNotEmpty) {
      final sorted = _selected.toList()..sort();
      final names = sorted.map((i) => widget.product.toppings[i].name);
      parts.add('Topping: ${names.join(', ')}');
    }
    return parts.isEmpty ? null : parts.join(' | ');
  }

  void _toggleFavorite() {
    FavoriteService.instance.toggle(widget.product.name);
    setState(() {
      _favorite = FavoriteService.instance.isFavorite(widget.product.name);
    });
  }

  void _changeQty(int delta) {
    if (_loading) return;
    final next = _qty + delta;
    if (next < 1) return;
    setState(() => _qty = next);
  }

  void _toggleTopping(int i) {
    if (_loading) return;
    final max = widget.product.maxToppings;

    if (_selected.contains(i)) {
      setState(() => _selected.remove(i));
    } else if (_selected.length >= max) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Topping maksimal hanya $max untuk dipilih'),
            duration: const Duration(milliseconds: 1500),
          ),
        );
    } else {
      setState(() => _selected.add(i));
    }
  }

  Future<void> _addToCart() async {
    if (_loading) return;
    setState(() => _loading = true);

    // loading sebentar, lalu masuk keranjang dan kembali ke menu
    await Future.delayed(const Duration(milliseconds: 900));
    CartService.instance.add(
      widget.product,
      _qty,
      sizeLabel: _isPromo ? null : _size.label,
      unitPrice: _unitPrice,
      note: _note,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  // Tombol kotak putih kecil (kembali & hati)
  Widget _squareButton({required Widget child, required VoidCallback onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  // Tombol − dan + untuk jumlah
  Widget _qtyButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  // Kartu pilihan ukuran (bisa dipilih)
  Widget _sizeCard(ProductSize s, bool selected, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF8CC0F0) : const Color(0xFFE6E6E6),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x558CC0F0),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ]
              : const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            // ikon ukuran dari asset (kalau tidak ada, pakai ikon bawaan)
            CircleAvatar(
              radius: 22,
              backgroundColor: const Color(0xFFF2F2F2),
              child: ClipOval(
                child: Image.asset(
                  s.image ?? kDefaultSizeImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      Icon(s.icon, size: 20, color: s.iconColor),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              s.label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }

  // ---------------- CRUST: satu baris pilihan ----------------
  Widget _crustRow(CrustOption c, int i) {
    final selected = i == _crustIndex;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!_loading) setState(() => _crustIndex = i);
      },
      child: Row(
        children: [
          Image.asset(
            c.image ?? kDefaultCrustImage,
            width: 50,
            height: 22,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
              Icons.confirmation_number_outlined,
              size: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 0),
          Expanded(
            child: Text(
              c.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            c.price == 0
                ? 'Bebas'
                : rupiahText(c.price).replaceFirst('Rp ', 'Rp.'),
            style: TextStyle(
              fontSize: 15,
              color: c.price == 0 ? AppColors.green : Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: selected ? AppColors.primary : const Color(0xFFBDBDBD),
          ),
        ],
      ),
    );
  }

  // Kotak daftar crust (satu pilihan, atau banyak pilihan)
  Widget _crustList() {
    final crusts = _crusts;

    return Container(
      padding: const EdgeInsets.only(
      left: 0,
      right: 10,
      top: 10,
      bottom: 10,
    ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < crusts.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _crustRow(crusts[i], i),
          ],
        ],
      ),
    );
  }

  // ---------------- PROMO: satu kartu isi paket ----------------
  Widget _promoCard(PromoItem item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2AA3DE), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // gambar + badge panah atas
          Stack(
            children: [
              ProductImage(
                color: item.imageColor,
                icon: item.imageIcon,
                image: item.image,
                radius: 8,
                height: 150,
                width: double.infinity,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 60,
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(alpha: 0.65),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
              // badge panah atas
              Positioned(
                top: 4,
                right: 6,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // nama + tombol Mengubah (hanya tampilan)
          Row(
            children: [
              Expanded(
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit_outlined, size: 15, color: Colors.black87),
                    SizedBox(width: 6),
                    Text('Mengubah', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // kotak abu Size + Crust
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Size',
                  style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8A)),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            item.sizeImage ?? kDefaultSizeImage,
                            width: 26,
                            height: 26,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              item.sizeIcon,
                              size: 15,
                              color: item.sizeIconColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item.size,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Crust',
                  style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8A)),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDDDDDD)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.crustName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down,
                          size: 22, color: Colors.black87),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- PIZZA: baris topping ----------------
  static const String _defaultToppingImage = 'assets/images/toping.png';

  // Lingkaran kecil topping (gambar atau warna)
  Widget _toppingDot(Topping t) {
    final dot = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: t.color, shape: BoxShape.circle),
    );

    return ClipOval(
      child: Image.asset(
        t.image ?? _defaultToppingImage,
        width: 25,
        height: 25,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => dot,
      ),
    );
  }

  Widget _checkBox(bool checked) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: checked ? AppColors.primary : const Color(0xFFBDBDBD),
          width: 1.5,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, size: 15, color: Colors.white)
          : null,
    );
  }

  Widget _toppingRow(int i) {
    final t = widget.product.toppings[i];
    final checked = _selected.contains(i);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _toggleTopping(i),
      child: SizedBox(
        height: 33,
        child: Row(
          children: [
            _toppingDot(t),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                t.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              t.free ? 'Bebas' : '+${rupiahText(_toppingPrice(t))}',
              style: TextStyle(
                fontSize: 14,
                color: t.free ? AppColors.green : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(width: 10),
            _checkBox(checked),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final sizes = p.sizeOptions;
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= GAMBAR + TOMBOL KEMBALI & HATI =================
            Stack(
              children: [
                ProductImage(
                  color: p.imageColor,
                  icon: p.imageIcon,
                  image: p.image,
                  radius: 0,
                  height: 235,
                  width: double.infinity,
                ),
                Positioned(
                  top: topInset + 16,
                  left: 20,
                  child: _squareButton(
                    onTap: () {
                      if (!_loading) Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back,
                        size: 22, color: Colors.black),
                  ),
                ),
                Positioned(
                  top: topInset + 16,
                  right: 20,
                  child: _squareButton(
                    onTap: _toggleFavorite,
                    child: Icon(
                      Icons.favorite,
                      size: 22,
                      color: _favorite ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            // ================= JUDUL & DESKRIPSI =================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description.replaceAll('-', '\u2011'),
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),

                  if (_isPromo) ...[
                    // ================= PROMO: PILIH PIZZA ANDA =================
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Pilih pizza Anda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFDDDDDD)),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Meningkatkan',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 22, color: Colors.black87),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    for (var i = 0; i < p.promoItems.length; i++) ...[
                      if (i > 0) const SizedBox(height: 20),
                      _promoCard(p.promoItems[i]),
                    ],
                  ] else ...[
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xFFE0E0E0)),
                    const SizedBox(height: 12),

                    // ================= SIZE =================
                    _heading('Size'),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        for (var i = 0; i < sizes.length; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(
                            child: _sizeCard(
                              sizes[i],
                              i == _sizeIndex,
                              () {
                                if (!_loading) {
                                  setState(() {
                                    _sizeIndex = i;
                                    _crustIndex = 0; 
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ================= CRUST =================
                    _heading('Crust'),
                    const SizedBox(height: 12),
                    _crustList(),

                    // ================= TOPPING (khusus pizza) =================
                    if (_hasToppings) ...[
                      const SizedBox(height: 12),
                      _heading('Topping'),
                      const SizedBox(height: 4),
                      Text(
                        'Topping maksimal hanya ${p.maxToppings} untuk dipilih',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEDEDED)),
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < p.toppings.length; i++)
                              _toppingRow(i),
                          ],
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),

      // ================= JUMLAH TOTAL & TOMBOL KERANJANG =================
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
        ),
        padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      'Jumlah Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _qtyButton(
                    icon: Icons.remove,
                    color: const Color(0xFFD32F2F),
                    onTap: () => _changeQty(-1),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 42,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: Text(
                      '$_qty',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _qtyButton(
                    icon: Icons.add,
                    color: AppColors.primary,
                    onTap: () => _changeQty(1),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _loading ? null : _addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Tambahkan ke Keranjang - ${rupiahText(_total)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}