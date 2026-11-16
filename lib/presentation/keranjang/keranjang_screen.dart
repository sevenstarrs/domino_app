import 'package:flutter/material.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  // =====================================================
  // WARNA
  // =====================================================

  static const Color navy = Color(0xFF1B4F7C);
  static const Color disabledBlue = Color(0xFF9DC3E7);
  static const Color borderGrey = Color(0xFFDDDDDD);
  static const Color textGrey = Color(0xFF8A8A8A);
  static const Color red = Color(0xFFE31837);
  static const Color couponBorder = Color(0xFFF0C96A);

  // =====================================================
  // DATA
  // =====================================================

  static const int hargaSatuan = 101909;

  bool isDelivery = false;
  bool gratisOngkirTerbuka = false;
  bool hasAddress = false;
  bool pesanUntukOrangLain = false;

  String alamatPengiriman = '';

  int qty = 1;
  int extraTotal = 0;
  int selectedPayment = -1;

  // =====================================================
  // FORMAT RUPIAH
  // =====================================================

  String rp(int v, {String prefix = 'Rp '}) {
    final s = v.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (m) => '${m[1]}.',
    );

    return '$prefix$s';
  }

  // =====================================================
  // PERHITUNGAN PEMBAYARAN
  // =====================================================

  int get subtotal => hargaSatuan * qty + extraTotal;

  int get pajak => (subtotal * 0.10).round();

  int get total => subtotal + pajak;

  bool get hasAddressOrTakeaway => !isDelivery || hasAddress;

  // =====================================================
  // NAMA METODE PEMBAYARAN
  // =====================================================

  String get namaMetodePembayaran {
    switch (selectedPayment) {
      case 0:
        return 'COD';
      case 1:
        return 'EDC';
      case 2:
        return 'GoPay';
      case 3:
        return 'QRIS';
      default:
        return '';
    }
  }

  // =====================================================
  // PILIH DELIVERY
  // =====================================================

  void _pilihDelivery() {
    setState(() {
      isDelivery = true;
    });

    if (hasAddress) return;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 25,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            12,
          ),
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
                style: TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
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

  // =====================================================
  // TAMBAH ALAMAT
  // =====================================================

  Future<void> _tambahAlamat() async {
    final controller = TextEditingController(
      text: alamatPengiriman,
    );

    final hasil = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Tambah alamat pengiriman',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: false,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan alamat lengkap',
            hintStyle: const TextStyle(
              fontSize: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isNotEmpty) {
                Navigator.pop(ctx, value);
              }
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

    if (!mounted) return;

    if (hasil != null && hasil.trim().isNotEmpty) {
      setState(() {
        alamatPengiriman = hasil.trim();
        hasAddress = true;
        isDelivery = true;
      });
    }

    controller.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
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
          child: Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),
        ),
      ),

      // BODY
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                14,
                18,
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kartuPengambilan(),

                  const SizedBox(height: 14),

                  _kartuRingkasanPesanan(),

                  const SizedBox(height: 18),

                  const Text(
                    'Eksklusif untuk Anda',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const Text(
                    'Berikut beberapa penawaran terbaik untuk Anda!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF333333),
                    ),
                  ),

                  const SizedBox(height: 12),

                  _bannerPapiDuo(),

                  const SizedBox(height: 14),

                  _kartuExtra(),

                  const SizedBox(height: 16),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'Ringkasan Pembayaran',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _barisHarga(
                    'Harga',
                    rp(subtotal),
                    grey: true,
                  ),

                  const SizedBox(height: 10),

                  _barisHarga(
                    'Pajak 10%',
                    rp(pajak),
                    grey: true,
                  ),

                  if (isDelivery) ...[
                    const SizedBox(height: 10),

                    _barisHarga(
                      'Delivery',
                      'Bebas',
                      valueColor: const Color(0xFF6D963E),
                    ),
                  ],

                  const SizedBox(height: 12),

                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFEEEEEE),
                  ),

                  const SizedBox(height: 12),

                  _barisHarga(
                    'Jumlah Pembayaran',
                    rp(total, prefix: 'Rp. '),
                    bold: true,
                  ),

                  const SizedBox(height: 14),

                  _kotakKupon(),

                  const SizedBox(height: 12),

                  // PESAN UNTUK ORANG LAIN
                  // HANYA DELIVERY

                  if (isDelivery)
                    _pesanUntukOrangLain(),

                  const SizedBox(height: 16),

                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _daftarMetodePembayaran(),

                  const SizedBox(height: 22),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Catatan ',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: '(opsional)',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    style: const TextStyle(
                      fontSize: 14.5,
                    ),
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
                        borderSide: const BorderSide(
                          color: borderGrey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: navy,
                        ),
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

  // =====================================================
  // KARTU DELIVERY DAN TAKEAWAY
  // =====================================================

  Widget _kartuPengambilan() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),

        // GARIS LUAR TETAP MENGELILINGI KARTU

        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),

        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DELIVERY DAN TAKEAWAY

          Padding(
            padding: const EdgeInsets.all(11),
            child: Row(
              children: [
                Expanded(
                  child: _tombolToggle(
                    'Delivery',
                    isDelivery,
                    _pilihDelivery,
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: _tombolToggle(
                    'Takeaway',
                    !isDelivery,
                    () {
                      setState(() {
                        isDelivery = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // SATU GARIS PEMBATAS SAJA

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),

          if (isDelivery)
            _isiDelivery()
          else
            _isiTakeaway(),
        ],
      ),
    );
  }

  // =====================================================
  // TOMBOL DELIVERY / TAKEAWAY
  // =====================================================

  Widget _tombolToggle(
    String label,
    bool aktif,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif ? navy : Colors.white,
          borderRadius: BorderRadius.circular(6),

          // Tombol tidak aktif tetap putih tanpa garis tambahan.
          border: Border.all(
            color: aktif ? navy : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: aktif ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // DELIVERY
  // =====================================================

  Widget _isiDelivery() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ALAMAT

          GestureDetector(
            onTap: _tambahAlamat,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 42,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                border: Border.all(
                  color: borderGrey,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasAddress
                          ? alamatPengiriman
                          : 'Kirim ke',
                      style: TextStyle(
                        fontSize: 13,
                        color: hasAddress
                            ? const Color(0xFF333333)
                            : const Color(0xFF999999),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF555555),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF777777),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),

          const SizedBox(height: 12),

          // OPSI PENGIRIMAN

          Row(
            children: [
              const Text(
                'Opsi Pengiriman',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 8),

              _chipJaminan('Jaminan 30 menit'),
            ],
          ),

          const SizedBox(height: 10),

          _kotakNow(),

          const SizedBox(height: 12),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                gratisOngkirTerbuka =
                    !gratisOngkirTerbuka;
              });
            },
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pengiriman GRATIS diterapkan',
                    style: TextStyle(
                      fontSize: 14,
                      color: textGrey,
                    ),
                  ),
                ),
                Icon(
                  gratisOngkirTerbuka
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),

          if (gratisOngkirTerbuka) ...[
            const SizedBox(height: 8),

            const Text(
              'Biaya pengiriman Rp 0',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF777777),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =====================================================
  // TAKEAWAY
  // =====================================================

  Widget _isiTakeaway() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        10,
        14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: red,
                size: 22,
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // UKURAN PENJEMPUTAN TETAP

                    Text(
                      'Penjemputan dari 2.2602 km',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: textGrey,
                      ),
                    ),

                    SizedBox(height: 4),

                    // NAMA DOMINO'S DIPERKECIL

                    Text(
                      "Domino's Pizza - Soebrantas Pekanbaru",
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 4),

                    // ALAMAT JALAN DIPERKECIL

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

              const Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 14),

          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFEEEEEE),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Text(
                'Opsi Bawa Pulang',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 8),

              _chipJaminan('Jaminan 15 menit'),
            ],
          ),

          const SizedBox(height: 10),

          _kotakNow(),
        ],
      ),
    );
  }

  // =====================================================
  // JAMINAN 15 / 30 MENIT
  // GRADASI TERANG DI TENGAH
  // BAGIAN DALAM TETAP PUTIH
  // =====================================================

  Widget _chipJaminan(String teks) {
    return Container(
      padding: const EdgeInsets.all(1.2),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF85B94C),
            Color(0xFFE2F3C9),
            Color(0xFF85B94C),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 1,
        ),
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

  // =====================================================
  // NOW
  // =====================================================

  Widget _kotakNow() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF9BCB55),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.bolt_outlined,
            size: 18,
            color: Colors.black87,
          ),

          SizedBox(width: 8),

          Expanded(
            child: Text(
              'Now',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF444444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Icon(
            Icons.radio_button_checked,
            color: navy,
            size: 20,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // RINGKASAN PESANAN
  // =====================================================

Widget _kartuRingkasanPesanan() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16,
    ),
    decoration: _kartu(radius: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pesanan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 78,
                  height: 78,

                  // GAMBAR PAPI DUO DARI INTERNET
                  child: Image.network(
                    'https://dominos.menumakanan.com/img/papi-duo.jpg',

                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,

                    // INDIKATOR KETIKA GAMBAR DIMUAT
                    loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: const Color(0xFF3AA7E8),
                        alignment: Alignment.center,
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },

                    // GAMBAR PENGGANTI JIKA URL ERROR
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return Container(
                        color: const Color(0xFF3AA7E8),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: const Text(
                          'PAPI DUO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Text(
                            'Double Date 11.11 Sale!',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.edit_note_outlined,
                          color: Color(0xFF1B6CA8),
                          size: 24,
                        ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    const Text(
                      '•  M HT Margherita',
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        fontWeight: FontWeight.w500,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 1),

                    const Text(
                      '•  M HT Volcano Meatmax',
                      style: TextStyle(
                        fontSize: 13,
                        color: textGrey,
                        fontWeight: FontWeight.w500,
                        height: 1.05,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            rp(hargaSatuan),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        _tombolStep(
                          Icons.remove,
                          red,
                          () {
                            if (qty > 1) {
                              setState(() {
                                qty--;
                              });
                            }
                          },
                        ),

                        const SizedBox(width: 6),

                        Container(
                          width: 28,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF2FB),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFD6E4F3),
                            ),
                          ),
                          child: Text(
                            '$qty',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(width: 6),

                        _tombolStep(
                          Icons.add,
                          navy,
                          () {
                            setState(() {
                              qty++;
                            });
                          },
                        ),
                      ],
                    ),
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


  // =====================================================
  // TOMBOL JUMLAH PESANAN
  // =====================================================

  Widget _tombolStep(
    IconData icon,
    Color warna,
    VoidCallback onTap,
  ) {
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
        child: Icon(
          icon,
          size: 15,
          color: warna,
        ),
      ),
    );
  }

  // =====================================================
  // BANNER PAPI DUO
  // =====================================================


Widget _bannerPapiDuo() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      width: double.infinity,
      height: 168,
      child: Image.network(
        'MASUKKAN_LINK_GAMBAR_PAPI_DUO',
        width: double.infinity,
        height: 168,
        fit: BoxFit.cover,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return Container(
            color: const Color(0xFF2E7BC4),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        },

        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF2E7BC4),
            alignment: Alignment.center,
            child: const Text(
              'Gambar Papi Duo tidak dapat dimuat',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    ),
  );
}


  // =====================================================
  // EXTRA CHILI DAN ECOBAG
  // =====================================================

  Widget _kartuExtra() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        8,
        14,
        8,
      ),
      decoration: _kartu(radius: 16),
      child: Column(
        children: [
          _barisExtra(
            'Extra Chili Sachet',
            500,
          ),

          const SizedBox(height: 6),

          _barisExtra(
            'Blue Ecobag 12"',
            5000,
          ),
        ],
      ),
    );
  }

  Widget _barisExtra(
    String nama,
    int harga,
  ) {
    return Row(
      children: [
        const Icon(
          Icons.confirmation_number,
          color: red,
          size: 17,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            nama,
            style: const TextStyle(
              fontSize: 13.5,
              color: Color(0xFF333333),
            ),
          ),
        ),

        Text(
          rp(harga),
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF555555),
          ),
        ),

        const SizedBox(width: 7),

        GestureDetector(
          onTap: () {
            setState(() {
              extraTotal += harga;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: borderGrey,
                width: 0.8,
              ),
            ),
            child: const Text(
              'Tambah',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // RINGKASAN PEMBAYARAN
  // =====================================================

  Widget _barisHarga(
    String label,
    String nilai, {
    bool grey = false,
    bool bold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w600,
            color: grey
                ? const Color(0xFF555555)
                : Colors.black,
          ),
        ),

        Text(
          nilai,
          style: TextStyle(
            fontSize: 13,
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }

  // =====================================================
  // PERIKSA KUPON
  // =====================================================

  Widget _kotakKupon() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: couponBorder,
          width: 1,
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Periksa kupon',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
            ),
          ),

          Icon(
            Icons.chevron_right,
            color: Colors.black,
            size: 24,
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PESAN UNTUK ORANG LAIN
  // HANYA MUNCUL PADA DELIVERY
  // =====================================================

  Widget _pesanUntukOrangLain() {
    return GestureDetector(
      onTap: () {
        setState(() {
          pesanUntukOrangLain =
              !pesanUntukOrangLain;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: borderGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.card_giftcard,
              color: Color(0xFFE3A02F),
              size: 27,
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Text(
                'Pesan untuk orang lain?',
                style: TextStyle(
                  fontSize: 14.5,
                ),
              ),
            ),

            Checkbox(
              value: pesanUntukOrangLain,
              activeColor: navy,
              visualDensity: VisualDensity.compact,
              onChanged: (value) {
                setState(() {
                  pesanUntukOrangLain =
                      value ?? false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // DAFTAR METODE PEMBAYARAN
  // COD - EDC - GOPAY - QRIS
  // BISA SCROLL KE SAMPING
  // =====================================================

  Widget _daftarMetodePembayaran() {
    return SizedBox(
      height: 140,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        children: [
          // COD

          _kartuBayar(
            0,
            'COD',
            const Icon(
              Icons.delivery_dining,
              size: 46,
              color: Color(0xFF2E7BC4),
            ),
          ),

          // EDC

          _kartuBayar(
            1,
            'EDC',
            const Icon(
              Icons.point_of_sale,
              size: 46,
              color: Color(0xFF2E7BC4),
            ),
          ),

          // GOPAY

          _kartuBayar(
            2,
            'GoPay',
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFF1FA6D8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 19,
                    color: Colors.white,
                  ),

                  Text(
                    'gopay',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // QRIS

          _kartuBayar(
            3,
            'QRIS',
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: const Color(0xFF222222),
                  width: 1.2,
                ),
              ),
              child: const Icon(
                Icons.qr_code_2,
                size: 34,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // KARTU METODE PEMBAYARAN
  // UKURAN KARTU DAN GARIS BIRU SESUAI REFERENSI
  // =====================================================

  Widget _kartuBayar(
    int index,
    String nama,
    Widget ikon,
  ) {
    final aktif = selectedPayment == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = index;
        });
      },
      child: Container(
        width: 96,
        height: 132,
        margin: const EdgeInsets.only(
          right: 12,
        ),
        padding: const EdgeInsets.only(
          top: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: aktif
                ? const Color(0xFF83B2D3)
                : const Color(0xFFE3E3E3),
            width: aktif ? 2.5 : 1,
          ),

          // Bayangan tipis seperti kartu pada gambar referensi.
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
            SizedBox(
              height: 48,
              child: Center(
                child: ikon,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              nama,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // IKON METODE PEMBAYARAN TERPILIH
  // =====================================================

  Widget _ikonMetodeTerpilih() {
    switch (selectedPayment) {
      case 0:
        return const Icon(
          Icons.delivery_dining,
          size: 29,
          color: Color(0xFF2E7BC4),
        );

      case 1:
        return const Icon(
          Icons.point_of_sale,
          size: 29,
          color: Color(0xFF2E7BC4),
        );

      case 2:
        return Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: const Color(0xFF1FA6D8),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            size: 18,
            color: Colors.white,
          ),
        );

      case 3:
        return const Icon(
          Icons.qr_code_2,
          size: 29,
          color: Colors.black,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // =====================================================
  // BAR BAWAH
  // ICON PEMBAYARAN + SELECT ADDRESS / PAY
  // =====================================================

  Widget _barBawah() {
    final bool belumAdaAlamat =
        isDelivery && !hasAddress;

    final bool sudahPilihPembayaran =
        selectedPayment != -1;

    final bool bolehBayar =
        hasAddressOrTakeaway && sudahPilihPembayaran;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KETERANGAN METODE PEMBAYARAN

            if (sudahPilihPembayaran)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: Center(
                      child: _ikonMetodeTerpilih(),
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
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),

            const SizedBox(height: 9),

            // TOMBOL PEMBAYARAN

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: belumAdaAlamat
                    ? _tambahAlamat
                    : bolehBayar
                        ? () {
                            // TEMPAT PROSES PEMBAYARAN
                          }
                        : null,
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
                          : 'Pay ${rp(total)}',
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

  // =====================================================
  // UTILITAS KARTU
  // =====================================================

  BoxDecoration _kartu({
    double radius = 16,
  }) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: const Color(0xFFE0E0E0),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  // =====================================================
  // GAMBAR ASSETS
  // =====================================================

  Widget _gambar(
    String path,
    Color warna,
    String teks, {
    BoxFit fit = BoxFit.cover,
  }) {
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (context, error, stack) {
        return Container(
          color: warna,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            teks,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}
