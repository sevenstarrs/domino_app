import 'package:flutter/material.dart';
import '../widgets/navbar_custom.dart';
import 'activity/activity_screen.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'profile/profile_screen.dart';

/// Index tab aktif. Bisa diubah dari halaman mana saja (mis. SearchScreen).
final ValueNotifier<int> shellIndex = ValueNotifier<int>(0);

/// Permintaan membuka kategori tertentu di tab Menu (0 = Promo, 1 = Pizza, dst).
/// Diisi dari HomeScreen, lalu dibaca & dikosongkan lagi oleh MenuScreen.
final ValueNotifier<int?> menuCategoryRequest = ValueNotifier<int?>(null);

/// Kerangka utama: IndexedStack + bottom navigation (4 tab)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _pages = const [
    HomeScreen(),
    MenuScreen(),
    ActivityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: shellIndex,
      builder: (context, index, _) {
        return Scaffold(
          // IndexedStack menjaga state tiap tab (scroll position, dll)
          body: IndexedStack(index: index, children: _pages),
          bottomNavigationBar: GlowBottomNav(
            currentIndex: index,
            onTap: (i) => shellIndex.value = i,
          ),
        );
      },
    );
  }
}
