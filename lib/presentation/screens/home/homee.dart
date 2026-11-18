import 'dart:async';
import 'package:flutter/material.dart';

const kNavy = Color(0xFF1A4B8C);
const kRed = Color(0xFFD4202C);
const kRedPudar = Color(0xFFE57373); 

class Product {
  final String title;
  final String sub;
  final String oldPrice;
  final String price;
  final String image; 

  const Product({
    required this.title,
    required this.sub,
    required this.oldPrice,
    required this.price,
    required this.image,
  });
}

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final List<String> _banners = [
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/0e15f01a-9da9-42db-90b3-8e8a4617cf05_Banner-PAPI-COKE.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/06d6bad3-37b2-47b8-ad23-4fffa4a997e6_Banner-PAPI-DUO.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e196ead4-767e-4aab-8fa8-de7b20ab1328_Banner-Dominos-Pizza-Papi-Puas.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/a39b558e-d064-4082-b104-d862c341b25f_Banner-Dominos-Pizza-9-sd-10-Nov-2026.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/7d444ea7-d48e-4ece-adf3-183f7cc66864_Banner-PAPI-MABAR.jpg',
    'https://static.dominos.co.id/SULCIN-Small_Size_Prod_Banner_-_700x500.webp',
    'https://static.dominos.co.id/contents/images/1794365631_Small_Size_Prod_Banner_-_700x500.webp',
    'https://static.dominos.co.id/contents/images/catalog/1770951862477881902_SPCIN2-Small%20Size%20Prod%20Banner%20-%20700x500.webp',
    
  ];

  int _bannerIndex = 0;
  final PageController _pageController = PageController();
  Timer? _timer;
  bool _takeaway = true;   // true = Takeaway, false = Delivery
  int _cart = 0;
  bool _isLogin = true;   // ubah jadi true untuk melihat tampilan setelah login

  final String _namaAlamat = "Domino's Pizza - Soebrantas Pekanbaru";
  final String _alamatLengkap =
      'Jl. HR. Soebrantas, Simpang Baru Kec. Tampan, Kota Pekanbaru, Riau 28282';

  final List<Product> _todaySpecial = const [
    Product(
      title: 'Papi Mabar',
      sub: 'Papi Mabar',
      oldPrice: 'Rp 193.273',
      price: 'Rp 120.909',
      image: 'https://static.dominos.co.id/contents/images/1794539458_PAPI_MABAR__13-15_NOV__Full_Size_Product_Banner_-_1595x640.webp',
    ),
    Product(
      title: 'Papi Puas',
      sub: 'Beli 1 Large HT Sultan (Volcano Meatmax/Beef ...',
      oldPrice: 'Rp 137.727',
      price: 'Rp 101.909',
      image: 'https://static.dominos.co.id/contents/images/1793327853_OKTOBER_2026_WEBP_PAPI_PUAS_Full_Size_Product_Banner_-_1595x640.webp',
    ),
  ];

  final List<Product> _paketHemat = const [
    Product(
      title: 'Papi Nori',
      sub: 'Beli 1 Medium HT Viral pilihan',
      oldPrice: 'Rp 80.000',
      price: 'Rp 50.909',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/21b5d2ef-fed2-43e0-8dd4-a104d2909288_718613_12029458_Papi_Nori.png?auto=format',   // ganti link
    ),
    Product(
      title: 'Papi Mini',
      sub: '5 Pizza Mania',
      oldPrice: 'Rp 40.454',
      price: 'Rp 27.727',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e31e3653-e4de-4705-96f1-0fcfc82d6519_227653_2a4a01af_Papi_Mini.png?auto=format',   // ganti link
    ),
    Product(
      title: 'Papi Single',
      sub: '1 Personal Pizza + 1 Side',
      oldPrice: 'Rp 54.000',
      price: 'Rp 39.091',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/c2a777c7-df36-404a-83ac-670a7230adac_240451_2505c993_Papi_Single.png?auto=format',
    ),
  ];

  final List<Product> _paketParty = const [
    Product(
      title: 'Papi Lima',
      sub: 'Papi Lima',
      oldPrice: 'Rp 270.000',
      price: 'Rp 227.273',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/77d346e8-5bcb-433c-bf37-6139df85b85e_723868_19cff3a8_Papi_Lima_BOLA.png?auto=format',
    ),
    Product(
      title: 'Papi Trio',
      sub: '3 Medium HT/TC/PAN Viral/Premium',
      oldPrice: 'Rp 200.000',
      price: 'Rp 161.364',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e1a9c2ce-206b-4779-b412-36aa0d7e5ce7_240949_bbefeff0_Papi_Trio.png?auto=format',   // ganti link
    ),
    Product(
      title: 'Papi Duo Large',
      sub: '2 Large Viral/Premium',
      oldPrice: 'Rp 272.726',
      price: 'Rp 170.909',
      image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/35f469fc-8772-4f20-b172-7fff98607d80_240950_e0b2af52_Papi_Duo_Large.png?auto=format',   // ganti link
    ),
  ];

  final List<Product> _paketPizza = const [
  Product(
    title: 'Papi Duo Cheeseburst',
    sub: '2 Medium CB Viral/Premium/Classic Pizza Rp 140.000 (Harga belum termasuk pajak)',
    oldPrice: 'Rp 218.184',
    price: 'Rp 140.000',
    image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/4046cbcb-e038-41d7-b1a4-8f51705a01e5_227651_5f034606_Papi_Duo_Cheeseburst.png?auto=format',   // ganti link
  ),
  Product(
    title: 'Papi Duo Double Cheeseburst',
    sub: '2 Medium Double CB Viral/Premium/Classic Pizza Rp 148.182 (Harga belum termasuk pajak)',
    oldPrice: 'Rp 227.274',
    price: 'Rp 148.182',
    image: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/5d0cb6af-9c55-40dc-bb8b-2000535b3068_231671_e0254b63_Papi_Duo_Double_Cheeseburst.png?auto=format',   // ganti link
  ),
];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_pageController.hasClients) return;

      // pindah ke banner berikutnya, kembali ke awal kalau sudah di ujung
      final next = (_bannerIndex + 1) % _banners.length;

      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _hero(),
        // semua konten di bawah banner digeser naik 48px,
        // supaya kartu lokasi menimpa bagian bawah banner
        Transform.translate(
          offset: const Offset(0, -20),
          child: Column(
            children: [
              _locationCard(),
              _categories(),                           
              _section('Apps Exclusive', _exclusiveBanner()),
              _section("Today's Special", _productList(_todaySpecial, 278, tinggi: 265)),
              _section('Paket Hemat', _productList(_paketHemat, 158, tinggi: 268)),
              _section('Paket Party', _productList(_paketParty, 158, tinggi: 268)), 
              _section('Paket Pizza', _paketPizzaList()), 
              if (_isLogin) _promoBox(),
              const SizedBox(height: 24),     
           ],
          ),
        ),
      ],
    );
  }

  Widget _hero() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 355,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (context, i) {
              return Image.network(
                _banners[i],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  );
                }
              );
            },
          ),
        ),
        Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.black38,                     // latar gelap transparan
                  borderRadius: BorderRadius.circular(20),   // bentuk pil
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _banners.length,
                    (i) => Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _bannerIndex ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  Widget _locationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(19, 14, 10, 10),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hai Domino's lovers!",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          // tombol Delivery / Takeaway
          Row(
            children: [
              Expanded(
                child: _toggleButton(
                  'Delivery',
                  !_takeaway,
                  () => setState(() => _takeaway = false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _toggleButton(
                  'Takeaway',
                  _takeaway,
                  () => setState(() => _takeaway = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _alamatBox(),        
        ],
      ),
    );
  }

  Widget _alamatBox() {
    if (_isLogin && _takeaway) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCCD2DA)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _namaAlamat,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _alamatLengkap,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            _pinIcon(size: 20),
          ],
        ),
      );
    }

    // selain itu: kotak abu-abu seperti sebelumnya
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _takeaway ? 'Temukan Outlet Terdekat' : 'Kirim ke...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.black45),
            ),
          ),
          _pinIcon(size: 18),
        ],
      ),
    );
  }

  Widget _pinIcon({double size = 18}) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        'assets/titik outline.png',
        fit: BoxFit.contain,
        color: Colors.black54,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.location_on_outlined, size: size, color: Colors.black54),
      ),
    );
  }

  Widget _toggleButton(String teks, bool aktif, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: aktif ? kNavy : Colors.white,
          border: Border.all(color: aktif ? kNavy : const Color(0xFFCCD2DA)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          teks,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: aktif ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _categories() {
    // setiap item berisi ikon dan teks
    const items = [
      ('assets/promo.webp', 'Promo'),
      ('assets/pizza.webp', 'Pizza'),
      ('assets/sides.webp', 'Sides'),
      ('assets/bread.jpeg', 'Bread'),
      ('assets/wings.webp', 'Wings'),
      ('assets/dessert.webp', 'Dessert'),
      ('assets/drinks.webp', 'Drinks'),
      ('assets/see_all.jpg', 'See All'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 237, 235, 235),
            blurRadius: 3,
            offset: Offset(0,1),
          ),
        ],
      ),
      child: GridView.count(
        padding: EdgeInsets.zero, 
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
        children: [
          for (final item in items)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    item.$1,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(item.$2, style: const TextStyle(fontSize: 11)),
              ],
            ),
        ],
      ),
    );
  }

// header section (judul di kiri, "Lihat semua" di kanan) + isinya
  Widget _section(String judul, Widget isi) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Lihat semua ›',
                  style: TextStyle(fontSize: 14, color: Color(0xFF0B6FD6)),
                ),
              ],
            ),
          ),
          isi,
        ],
      ),
    );
  }

  Widget _exclusiveBanner() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade300,
      ),
      child: Image.network(
        'https://static.dominos.co.id/contents/images/1793579416_2-4JUN-Full_Size_Product_Banner_-_1595x640.webp',
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Center(child: Icon(Icons.broken_image, size: 40)),
      ),
    );
  }

  void _addToCart(Product p) {
  setState(() => _cart++);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('${p.title} ditambahkan ($_cart item)'),
        duration: const Duration(seconds: 1),
      ),
    );
}

  // list geser ke samping
  Widget _productList(List<Product> items, double lebarKartu, {double tinggi = 245}) {
    return SizedBox(
      height: tinggi,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, i) => _productCard(items[i], lebarKartu),
      ),
    );
  }

  // satu kartu produk
  Widget _productCard(Product p, double lebar) {
    return Container(
      width: lebar,
      padding: const EdgeInsets.all(10),                       // 8 -> 10
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),               // 6 -> 12
        border: Border.all(color: const Color(0xFFE0E3E8)),    // garis tipis
        // boxShadow dihapus
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // gambar mengambil sisa ruang (dibungkus Expanded)
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                p.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          Text(
            p.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 2),
          Text(
            p.sub,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 4),

          Text(
            p.oldPrice,
            style: const TextStyle(
              fontSize: 13,
              color: kRed,                        // merah lebih pudar
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Text(

            p.price,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _addToCart(p),
              style: FilledButton.styleFrom(
                backgroundColor: kNavy,
                minimumSize: const Size(0, 26),                // 34 -> 30
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Tambah',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // daftar vertikal Paket Pizza
  Widget _paketPizzaList() {
    return Column(
      children: [
        for (int i = 0; i < _paketPizza.length; i++)
          _productRow(
            _paketPizza[i],
            garis: i != _paketPizza.length - 1,   // baris terakhir tanpa garis
          ),
      ],
    );
  }

  // satu baris produk: gambar di kiri, teks di kanan
  Widget _productRow(Product p, {bool garis = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: garis
            ? const Border(bottom: BorderSide(color: Color(0xFFE0E3E8)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              p.image,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 92,
                height: 92,
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // teks dan tombol
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  p.sub,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, color: Colors.black45),
                ),
                const SizedBox(height: 4),
                Text(
                  p.oldPrice,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kRed,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  p.price,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),

                // tombol Tambah di kanan
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () => _addToCart(p),
                    style: FilledButton.styleFrom(
                      backgroundColor: kNavy,
                      minimumSize: const Size(0, 26),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Tambah',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _promoBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      padding: const EdgeInsets.all(2),                  // tebal border
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const SweepGradient(
          center: Alignment.center,
          colors: [
            kNavy,
            kNavy,
            Color(0xFFDCE8F5),   // terang #1 (bawah, agak kiri)
            kNavy,
            kNavy,
            Color(0xFFDCE8F5),   // terang #2 (atas, agak kanan)
            kNavy,
            kNavy,
          ],
          stops: [0.0, 0.34, 0.41, 0.48, 0.84, 0.91, 0.98, 1.0],
        ),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.5),         // 16 - 1.5
        child: InkWell(
          onTap: () {
            // nanti diisi: buka halaman kode promo
          },
          borderRadius: BorderRadius.circular(14.5),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Image.asset(
                    'assets/promo_icon.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.confirmation_number, color: kNavy, size: 22),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Punya kode promo?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: kNavy,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ),
        ),
      ),
    );
  }
}