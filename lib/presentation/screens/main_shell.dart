import 'package:flutter/material.dart';
import 'activity/activity_screen.dart';
import 'home/home_screen.dart';
import 'menu/menu_screen.dart';
import 'profile/profile_screen.dart';

/// Index tab aktif. Bisa diubah dari halaman mana saja (mis. SearchScreen).
final ValueNotifier<int> shellIndex = ValueNotifier<int>(0);

/// Kerangka utama: IndexedStack + bottom navigation (4 tab)
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _pages = const [
    Beranda(),
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
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => shellIndex.value = i,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: Icon(Icons.local_pizza_outlined),
                selectedIcon: Icon(Icons.local_pizza),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: Icon(Icons.newspaper_outlined),
                selectedIcon: Icon(Icons.newspaper),
                label: 'Aktivitas',
              ),
              NavigationDestination(
                icon: Icon(Icons.account_circle_outlined),
                selectedIcon: Icon(Icons.account_circle),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}