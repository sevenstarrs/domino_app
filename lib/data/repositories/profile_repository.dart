import '../local/database_helper.dart';
import '../models/user_profile.dart';

/// Lapisan antara UI dan database. UI tidak tahu soal SQL.
class ProfileRepository {
  final _db = DatabaseHelper.instance;
  static const _table = DatabaseHelper.tableProfiles;

  Future<UserProfile> create(UserProfile p) async {
    final id = await _db.insert(_table, p.toMap());
    return p.copyWith(id: id);
  }

  /// Aplikasi ini hanya menyimpan satu profil (baris pertama).
  Future<UserProfile?> get() async {
    final rows = await _db.queryAll(_table);
    return rows.isEmpty ? null : UserProfile.fromMap(rows.first);
  }

  Future<UserProfile> update(UserProfile p) async {
    await _db.update(_table, p.id!, p.toMap());
    return p;
  }

  Future<void> delete(int id) => _db.delete(_table, id);
}
