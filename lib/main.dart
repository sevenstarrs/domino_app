import 'package:flutter/material.dart';
import 'app.dart';
import 'core/state/profile_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await ProfileState.load(); // baca profil dari SQLite sebelum UI tampil
  } catch (e) {
    debugPrint('Gagal memuat profil: $e');
  }
  runApp(const DominosApp());
}