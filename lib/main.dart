import 'package:domino_app/data/models/user_profile.dart';
import 'package:domino_app/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/state/profile_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final repo = ProfileRepository();
final saved = await repo.create(const UserProfile(name: 'Tes', email: 'tes@gmail.com'));
debugPrint('TERSIMPAN id=${saved.id}');
debugPrint('ISI DB: ${(await repo.get())?.name}');
    await ProfileState.load(); // baca profil dari SQLite sebelum UI tampil
  } catch (e) {
    debugPrint('Gagal memuat profil: $e');
  }
  runApp(const DominosApp());
}
