import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_data.dart';
import '../../widgets/category_grid.dart';
import '../../widgets/horizontal_product_card.dart';
import '../../widgets/order_type_card.dart';
import '../../widgets/product_list_tile.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _hero() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFF6A1F), Color(0xFFD83A0F)],
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.local_pizza, size: 150, color: Color(0x55FFFFFF)),
          Positioned(
            bottom: 36,
            child: Column(
              children: [
                Text('NEW SPICY K-LAVA',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900)),
                SizedBox(height: 4),
                Text('매콤해! Maekomhae!',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: AppColors.primary),
          const SizedBox(width: 14),
          const Expanded(
            child: Text('Masuk yuk—ada hal seru yang cuma buat kamu!',
                style: TextStyle(color: AppColors.primary, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  Widget _promoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
            colors: [Color(0xFF2A7DE1), Color(0xFF6FB1F5)]),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('PAPI DUO',
              style: TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
          Text('2 MEDIUM',
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text('50RB/PIZZA',
              style: TextStyle(
                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _horizontalList(List products, {double width = 225, double height = 330}) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) =>
            HorizontalProductCard(product: products[i], width: width),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner + kartu yang menimpa bagian bawahnya
            Stack(
              clipBehavior: Clip.none,
              children: [
                _hero(),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 270,
                  child: const OrderTypeCard(),
                ),
              ],
            ),
            const SizedBox(height: 230),
            const CategoryGrid(),
            _loginBanner(),
            SectionHeader(title: 'Apps Exclusive', onSeeAll: () {}),
            _promoBanner(),
            SectionHeader(title: "Today's Special", onSeeAll: () {}),
            _horizontalList(DummyData.todaysSpecial, width: 270, height: 360),
            SectionHeader(title: 'Paket Hemat', onSeeAll: () {}),
            _horizontalList(DummyData.paketHemat),
            SectionHeader(title: 'Paket Party', onSeeAll: () {}),
            _horizontalList(DummyData.paketParty, height: 320),
            SectionHeader(title: 'Paket Pizza', onSeeAll: () {}),
            ...DummyData.paketPizza.map((p) => ProductListTile(product: p)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
