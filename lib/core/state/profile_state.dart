import 'package:flutter/foundation.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/profile_repository.dart';

/// Profil aktif. UI mendengarkan [current]; null = belum ada profil (tamu).
class ProfileState {
  ProfileState._();

  static final ValueNotifier<UserProfile?> current =
      ValueNotifier<UserProfile?>(null);
  static final _repo = ProfileRepository();

  static bool get hasProfile => current.value != null;

  static Future<void> load() async {
    current.value = await _repo.get();
  }

  /// Insert kalau belum punya id, update kalau sudah.
  static Future<void> save(UserProfile p) async {
    current.value = p.id == null ? await _repo.create(p) : await _repo.update(p);
  }

  static Future<void> delete() async {
    final p = current.value;
    if (p?.id != null) await _repo.delete(p!.id!);
    current.value = null;
  }
}
