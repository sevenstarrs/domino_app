import 'package:flutter/material.dart';

import '../../core/utils/formatter.dart';
import '../../data/cart/cart_manager.dart';
import '../../data/models/product.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  static const Color navy = Color(0xFF1B4F7C);
  static const Color disabledBlue = Color(0xFF9DC3E7);
  static const Color borderGrey = Color(0xFFDDDDDD);
  static const Color dividerGrey = Color(0xFFEEEEEE);
  static const Color textGrey = Color(0xFF8A8A8A);
  static const Color red = Color(0xFFE31837);
  static const Color couponBorder = Color(0xFFF0C96A);

  static const Product extraChili = Product(
    name: 'Extra Chili Sachet',
    description: "Domino's Extra Chili Sachet",
    price: 500,
    image: 'assets/images/chili.png',
    imageColor: Color(0xFFE8E8E8),
    imageIcon: Icons.local_fire_department,
  );

  static const Product blueEcobag = Product(
    name: 'Blue Ecobag 12"',
    description: "Domino's Blue Ecobag 12\"",
    price: 5000,
    image: 'assets/images/ecobag.png',
    imageColor: Color(0xFF087E9B),
    imageIcon: Icons.shopping_bag,
  );

  static const _extras = [extraChili, blueEcobag];

  static const _metode = ['COD', 'EDC', 'GoPay', 'QRIS'];

  static final Map<String, int> _extraQuantities = {};

  bool isDelivery = false;
  bool hasAddress = false;
  bool pesanUntukOrangLain = false;
  String alamatPengiriman = '';
  int selectedPayment = -1;

  int _qtyExtra(Product p) => _extraQuantities[p.name] ?? 0;

  int get extraTotal =>
      _extras.fold<int>(0, (sum, p) => sum + p.price * _qtyExtra(p));

  @override
  void initState() {
    super.initState();
    CartManager.instance.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    CartManager.instance.removeListener(_onCartChanged);
    super.dispose();
  }

  int get subtotal => CartManager.instance.subtotal + extraTotal;

  int get pajak => (subtotal * 0.10).round();

  int get total => subtotal + pajak;

  bool get hasAddressOrTakeaway => !isDelivery || hasAddress;

  String get namaMetodePembayaran =>
      selectedPayment >= 0 ? _metode[selectedPayment] : '';

  void _pilihDelivery() {
    setState(() => isDelivery = true);

    if (hasAddress) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tidak ada alamat yang ditemukan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Silakan tambahkan alamat pengiriman Anda untuk melanjutkan.',
                style: TextStyle(fontSize: 13.5, color: Color(0xFF222222)),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
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

  Future<void> _tambahAlamat() async {
    final controller = TextEditingController(text: alamatPengiriman);

    final hasil = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah alamat pengiriman',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan alamat lengkap',
            hintStyle: const TextStyle(fontSize: 13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) Navigator.pop(ctx, value);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (!mounted || hasil == null) return;

    setState(() {
      alamatPengiriman = hasil;
      hasAddress = true;
      isDelivery = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Navigator.maybePop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 3, color: dividerGrey),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kartuPengambilan(),
                  const SizedBox(height: 14),

                  _kartuRingkasanPesanan(),
                  const SizedBox(height: 18),

                  _judul('Eksklusif untuk Anda'),
                  const SizedBox(height: 3),
                  const Text(
                    'Berikut beberapa penawaran terbaik untuk Anda!',
                    style: TextStyle(fontSize: 12, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 12),

                  _bannerPapiDuo(),
                  const SizedBox(height: 14),

                  _kartuExtra(),
                  const SizedBox(height: 16),

                  _garis(2),
                  const SizedBox(height: 14),

                  _judul('Ringkasan Pembayaran'),
                  const SizedBox(height: 12),

                  _barisHarga('Harga', rupiah(subtotal), grey: true),
                  const SizedBox(height: 10),
                  _barisHarga('Pajak 10%', rupiah(pajak), grey: true),

                  if (isDelivery) ...[
                    const SizedBox(height: 10),
                    _barisHarga(
                      'Delivery',
                      'Bebas',
                      valueColor: const Color(0xFF6D963E),
                    ),
                  ],

                  const SizedBox(height: 12),
                  _garis(2),
                  const SizedBox(height: 12),

                  _barisHarga(
                    'Jumlah Pembayaran',
                    rupiah(total).replaceFirst('Rp ', 'Rp. '),
                    bold: true,
                  ),
                  const SizedBox(height: 14),

                  _kotakKupon(),
                  const SizedBox(height: 12),

                  if (isDelivery) _pesanUntukOrangLain(),

                  const SizedBox(height: 16),

                  _judul('Metode Pembayaran'),
                  const SizedBox(height: 12),

                  _daftarMetodePembayaran(),
                  const SizedBox(height: 22),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Catatan ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: '(opsional)',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    style: const TextStyle(fontSize: 14.5),
                    decoration: InputDecoration(
                      hintText: 'Misalnya, tambahkan lagi!',
                      hintStyle: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF777777),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF3F3F3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: borderGrey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: navy),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          _barBawah(),
        ],
      ),
    );
  }

  Widget _judul(String teks) => Text(
    teks,
    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
  );

  Widget _garis([double tebal = 1]) =>
      Divider(height: 1, thickness: tebal, color: dividerGrey);

  Widget _kartuPengambilan() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDADADA), width: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDADADA)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _tombolToggle('Delivery', isDelivery, _pilihDelivery),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _tombolToggle(
                    'Takeaway',
                    !isDelivery,
                    () => setState(() => isDelivery = false),
                  ),
                ),
              ],
            ),
          ),
          if (isDelivery) _isiDelivery() else _isiTakeaway(),
        ],
      ),
    );
  }

  Widget _tombolToggle(String label, bool aktif, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif ? navy : Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: aktif ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _isiDelivery() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _tambahAlamat,
            child: Container(
              constraints: const BoxConstraints(minHeight: 38),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F4F4),
                border: Border.all(color: const Color(0xFFD8D8D8), width: 1),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasAddress ? alamatPengiriman : 'Kirim ke',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: hasAddress
                            ? const Color(0xFF333333)
                            : const Color(0xFF999999),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  _assetIcon(
                    'titik outline',
                    size: 22,
                    color: const Color(0xFF666666),
                    fallback: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
          ),

          ..._blokOpsi('Opsi Pengiriman', 'Jaminan 30 menit'),
          const SizedBox(height: 12),

          const Row(
            children: [
              Expanded(
                child: Text(
                  'Pengiriman GRATIS diterapkan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 129, 127, 127),
                  ),
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _isiTakeaway() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: red, size: 22),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Penjemputan dari 2.2602 km',
                      style: TextStyle(fontSize: 12.5, color: textGrey),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Domino's Pizza - Soebrantas Pekanbaru",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Jl. HR. Soebrantas, Simpang Baru Kec. Tampan, Kota Pekanbaru, Riau 28282',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF333333),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.black, size: 24),
            ],
          ),

          ..._blokOpsi('Opsi Bawa Pulang', 'Jaminan 15 menit'),
        ],
      ),
    );
  }

  List<Widget> _blokOpsi(String judul, String jaminan) {
    return [
      const SizedBox(height: 14),
      _garis(),
      const SizedBox(height: 12),
      Row(
        children: [
          Text(
            judul,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 8),
          _chipJaminan(jaminan),
        ],
      ),
      const SizedBox(height: 10),
      _kotakNow(),
    ];
  }

  Widget _chipJaminan(String teks) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF85B94C), Color(0xFFE2F3C9), Color(0xFF85B94C)],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Text(
          teks,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ),
    );
  }

  Widget _kotakNow() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF9BCB55), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _assetIcon(
            'petir',
            size: 18,
            color: Colors.black87,
            fallback: Icons.bolt_outlined,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Now',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF444444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.radio_button_checked, color: navy, size: 20),
        ],
      ),
    );
  }

  int get _jumlahSemuaItem =>
      CartManager.instance.totalQuantity +
      _extras.fold<int>(0, (sum, p) => sum + _qtyExtra(p));

  bool _isExtra(Product product) => _extras.any((e) => e.name == product.name);

  Future<bool> _konfirmasiHapusItem() async {
    const gayaTombol = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    final hasil = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        titlePadding: const EdgeInsets.fromLTRB(48, 24, 40, 0),
        title: const Text(
          'Hapus Item?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(48, 12, 40, 0),
        content: const Text(
          'Ini adalah barang terakhir di keranjang Anda. Setelah ini, keranjang Anda akan kosong.',
          style: TextStyle(fontSize: 18, height: 1.2, color: Color(0xFF222222)),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 12, 28, 12),
        buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: gayaTombol,
            ),
            child: const Text('MEMBATALKAN'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              textStyle: gayaTombol,
            ),
            child: const Text('OKE'),
          ),
        ],
      ),
    );
    return hasil ?? false;
  }

  Future<void> _kurangiItem(CartItem item) async {
    if (item.quantity > 1) {
      CartManager.instance.decrease(item);
      return;
    }

    if (_jumlahSemuaItem == 1) {
      if (!await _konfirmasiHapusItem() || !mounted) return;
    }
    CartManager.instance.remove(item);
  }

  Future<void> _kurangiExtra(Product product) async {
    final jumlah = _qtyExtra(product);
    if (jumlah <= 0) return;

    if (jumlah == 1 && _jumlahSemuaItem == 1) {
      if (!await _konfirmasiHapusItem() || !mounted) return;
    }

    setState(() {
      if (jumlah <= 1) {
        _extraQuantities.remove(product.name);
      } else {
        _extraQuantities[product.name] = jumlah - 1;
      }
    });
  }

  void _tambahExtra(Product product) {
    setState(() => _extraQuantities[product.name] = _qtyExtra(product) + 1);
  }

  void _editPesanan(Product product) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Edit Pesanan'),
        content: Text(
          'Untuk mengubah pilihan ${product.name}, silakan pilih kembali produk melalui menu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OKE'),
          ),
        ],
      ),
    );
  }

  Widget _kartuRingkasanPesanan() {
    final items = <CartItem>[
      ...CartManager.instance.items,
      for (final p in _extras)
        if (_qtyExtra(p) > 0) CartItem(product: p, quantity: _qtyExtra(p)),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _kartu(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Pesanan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 14),

          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(
                child: Text(
                  'Keranjang masih kosong. Silakan pilih produk terlebih dahulu.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: textGrey),
                ),
              ),
            )
          else
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _barisProdukKeranjang(item),
              ),
            ),
        ],
      ),
    );
  }

  String _subtitle(CartItem item) {
    final detail = [
      if (item.sizeLabel != null && item.sizeLabel!.isNotEmpty) item.sizeLabel!,
      if (item.note != null && item.note!.isNotEmpty) item.note!,
    ].join(' \u2022 ');
    return detail.isNotEmpty ? detail : item.product.description;
  }

  Widget _gambarProduk(Product product) {
    Widget kotak([Widget? isi]) => Container(
      color: product.imageColor,
      alignment: Alignment.center,
      child: isi ?? Icon(product.imageIcon, size: 42, color: Colors.white),
    );

    final Widget gambar;
    if (_isExtra(product)) {
      gambar = Image.asset(
        product.image!,
        width: 78,
        height: 78,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => kotak(),
      );
    } else if (product.imageUrl != null &&
        product.imageUrl!.trim().isNotEmpty) {
      gambar = Image.network(
        product.imageUrl!,
        width: 78,
        height: 78,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => kotak(),
        loadingBuilder: (_, child, loadingProgress) => loadingProgress == null
            ? child
            : kotak(
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
      );
    } else {
      gambar = kotak();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: 78, height: 78, child: gambar),
    );
  }

  Widget _barisProdukKeranjang(CartItem item) {
    final product = item.product;
    final isExtra = _isExtra(product);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _gambarProduk(product),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (!isExtra)
                      InkWell(
                        onTap: () => _editPesanan(product),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: _assetIcon(
                            'edit',
                            size: 21,
                            fallback: Icons.edit_outlined,
                          ),
                        ),
                      ),
                  ],
                ),

                if (_subtitle(item).isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    _subtitle(item),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: textGrey),
                  ),
                ],

                const SizedBox(height: 7),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        rupiah(item.total),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    _tombolStep(
                      Icons.remove,
                      red,
                      () =>
                          isExtra ? _kurangiExtra(product) : _kurangiItem(item),
                    ),

                    const SizedBox(width: 6),

                    Container(
                      width: 28,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FB),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFD6E4F3)),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                    const SizedBox(width: 6),

                    _tombolStep(
                      Icons.add,
                      navy,
                      () => isExtra
                          ? _tambahExtra(product)
                          : CartManager.instance.increase(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolStep(IconData icon, Color warna, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 23,
        height: 23,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: warna == red
                ? const Color(0xFFE9B7BE)
                : const Color(0xFFBFC9D4),
          ),
        ),
        child: Icon(icon, size: 15, color: warna),
      ),
    );
  }

  Widget _bannerPapiDuo() {
    Widget kotak(Widget isi) => Container(
      color: const Color(0xFF2E7BC4),
      alignment: Alignment.center,
      child: isi,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 168,
        child: Image.network(
          'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/06d6bad3-37b2-47b8-ad23-4fffa4a997e6_Banner-PAPI-DUO.jpg',
          width: double.infinity,
          height: 168,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, loadingProgress) => loadingProgress == null
              ? child
              : kotak(const CircularProgressIndicator(color: Colors.white)),
          errorBuilder: (_, _, _) => kotak(
            const Text(
              'Gambar Papi Duo tidak dapat dimuat',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _kartuExtra() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      decoration: _kartu(radius: 16),
      child: Column(
        children: [
          _barisExtra(extraChili),
          const SizedBox(height: 6),
          _barisExtra(blueEcobag),
        ],
      ),
    );
  }

  Widget _barisExtra(Product product) {
    final jumlah = _qtyExtra(product);

    return Row(
      children: [
        _assetIcon(
          'tiket merah',
          size: 17,
          color: red,
          fallback: Icons.confirmation_number,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            product.name,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF333333)),
          ),
        ),
        Text(
          rupiah(product.price),
          style: const TextStyle(fontSize: 13.5, color: Color(0xFF555555)),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: jumlah == 0 ? () => _tambahExtra(product) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderGrey, width: 0.8),
            ),
            child: Text(
              jumlah > 0 ? 'Ditambahkan' : 'Tambah',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: jumlah > 0 ? const Color(0xFF888888) : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _barisHarga(
    String label,
    String nilai, {
    bool grey = false,
    bool bold = false,
    Color? valueColor,
  }) {
    final berat = bold ? FontWeight.w700 : FontWeight.w600;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: berat,
            color: grey ? const Color(0xFF555555) : Colors.black,
          ),
        ),
        Text(
          nilai,
          style: TextStyle(
            fontSize: 13,
            fontWeight: berat,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _kotakKupon() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couponBorder, width: 1),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Periksa kupon',
              style: TextStyle(fontSize: 16, color: Color(0xFF333333)),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.black, size: 24),
        ],
      ),
    );
  }

  Widget _pesanUntukOrangLain() {
    return GestureDetector(
      onTap: () => setState(() => pesanUntukOrangLain = !pesanUntukOrangLain),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderGrey, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _assetIcon(
              'gift',
              size: 27,
              color: const Color(0xFFE3A02F),
              fallback: Icons.card_giftcard,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Pesan untuk orang lain?',
                style: TextStyle(fontSize: 14.5),
              ),
            ),
            Checkbox(
              value: pesanUntukOrangLain,
              activeColor: navy,
              visualDensity: VisualDensity.compact,
              onChanged: (value) =>
                  setState(() => pesanUntukOrangLain = value ?? false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ikonMetode(int index, {bool kecil = false}) {
    return switch (index) {
      0 => _assetIcon(
        'cod',
        size: kecil ? 29 : 46,
        fallback: Icons.delivery_dining,
      ),
      1 => _assetIcon(
        'edc',
        size: kecil ? 29 : 46,
        fallback: Icons.point_of_sale,
      ),
      2 => _ikonGoPay(size: kecil ? 29 : 42),
      3 => _ikonQRIS(size: kecil ? 29 : 42),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _daftarMetodePembayaran() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(vertical: 4),
        children: [for (var i = 0; i < _metode.length; i++) _kartuBayar(i)],
      ),
    );
  }

  Widget _kartuBayar(int index) {
    final aktif = selectedPayment == index;

    return GestureDetector(
      onTap: () => setState(() => selectedPayment = index),
      child: Container(
        width: 96,
        height: 132,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: aktif ? const Color(0xFF83B2D3) : const Color(0xFFE3E3E3),
            width: aktif ? 2.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: 48, child: Center(child: _ikonMetode(index))),
            const SizedBox(height: 12),
            Text(
              _metode[index],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ikonGoPay({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1FA6D8),
        borderRadius: BorderRadius.circular(size * 0.19),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: size * 0.45,
            color: Colors.white,
          ),
          Text(
            'gopay',
            style: TextStyle(
              fontSize: size * 0.21,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ikonQRIS({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.17),
        border: Border.all(color: const Color(0xFF222222), width: size * 0.029),
      ),
      child: Icon(Icons.qr_code_2, size: size * 0.81, color: Colors.black),
    );
  }

  Widget _barBawah() {
    final belumAdaAlamat = isDelivery && !hasAddress;
    final sudahPilihPembayaran = selectedPayment != -1;
    final adaProduk = _jumlahSemuaItem > 0;
    final bolehBayar =
        hasAddressOrTakeaway && sudahPilihPembayaran && adaProduk;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: dividerGrey, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sudahPilihPembayaran)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: _ikonMetode(selectedPayment, kecil: true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    namaMetodePembayaran,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else
              const Text(
                'Silakan pilih metode pembayaran',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
              ),

            const SizedBox(height: 9),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: bolehBayar ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: disabledBlue,
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  belumAdaAlamat
                      ? 'Select Address'
                      : !sudahPilihPembayaran
                      ? 'Select Payment Method'
                      : 'Pay ${rupiah(total)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _assetIcon(
    String nama, {
    required double size,
    Color? color,
    required IconData fallback,
  }) {
    return Image.asset(
      'assets/icons/$nama.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      color: color,
      errorBuilder: (_, _, _) => Icon(fallback, size: size, color: color),
    );
  }

  BoxDecoration _kartu({double radius = 16}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: const Color(0xFFE0E0E0)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}