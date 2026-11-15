import 'dart:async';
import 'package:flutter/material.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final List<String> _banners = [
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/0e15f01a-9da9-42db-90b3-8e8a4617cf05_Banner-PAPI-COKE.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/bba12172-7185-47db-9f40-b2222e8af68f_SEPTEMBER-2026-PAPI-DUO-OJOL-Gojek-Banner.jpg?auto=format&w=1536',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/06d6bad3-37b2-47b8-ad23-4fffa4a997e6_Banner-PAPI-DUO.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/e196ead4-767e-4aab-8fa8-de7b20ab1328_Banner-Dominos-Pizza-Papi-Puas.jpg',
    'https://foto.kontan.co.id/AkMDKj2xvRhhORHd2b8-pB0rFVM=/smart/filters:format(webp)/2025/12/10/635581755.jpg',
    'https://foto.kontan.co.id/PIbNX6HWfKwyz72a6Kb2Qzton5E=/smart/filters:format(webp)/2025/07/15/459841570.jpg',
    'https://media.suara.com/pictures/300x300/2025/11/06/91393-promo-papi-duo-dominos-pizza.jpg',
    'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/a39b558e-d064-4082-b104-d862c341b25f_Banner-Dominos-Pizza-9-sd-10-Nov-2026.jpg',
    'https://foto.kontan.co.id/UIKUhzMaZjcPT1FyAeq8PiBzjhQ=/smart/filters:format(webp)/2025/10/06/60349334.jpg'
  ];

  int _bannerIndex = 0;
  final PageController _pageController = PageController();
  Timer? _timer;

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
      ],
    );
  }

  Widget _hero() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
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
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _banners.length,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _bannerIndex ? Colors.white : Colors.white54,
                ),
              ),
            )
          ),
          ),
      ],
    );
  }
}