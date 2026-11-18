/// Model satu baris tabel `profiles`.
class UserProfile {
  final int? id;
  final String name;
  final String? birthDate; // format DD-MM-YYYY
  final String? phone; // lengkap dengan kode negara, mis. +62812...
  final String? email;
  final String? gender; // Laki-laki / Perempuan
  final String? anniversary; // Peringatan Tahunan, format DD-MM-YYYY

  const UserProfile({
    this.id,
    required this.name,
    this.birthDate,
    this.phone,
    this.email,
    this.gender,
    this.anniversary,
  });

  UserProfile copyWith({
    int? id,
    String? name,
    String? birthDate,
    String? phone,
    String? email,
    String? gender,
    String? anniversary,
  }) =>
      UserProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        gender: gender ?? this.gender,
        anniversary: anniversary ?? this.anniversary,
      );

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'birth_date': birthDate,
        'phone': phone,
        'email': email,
        'gender': gender,
        'anniversary': anniversary,
      };

  factory UserProfile.fromMap(Map<String, Object?> m) => UserProfile(
        id: m['id'] as int?,
        name: m['name'] as String,
        birthDate: m['birth_date'] as String?,
        phone: m['phone'] as String?,
        email: m['email'] as String?,
        gender: m['gender'] as String?,
        anniversary: m['anniversary'] as String?,
      );

  /// Huruf pertama nama untuk avatar.
  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  /// "saechee@gmail.com" -> "sa*****@*****.com"
  String get maskedEmail {
    final e = email;
    if (e == null || !e.contains('@')) return e ?? '';
    final parts = e.split('@');
    final local = parts[0];
    final domain = parts[1];
    final dot = domain.lastIndexOf('.');
    final tld = dot >= 0 ? domain.substring(dot) : '';
    final shown = local.length <= 2 ? local : local.substring(0, 2);
    final hiddenLocal = local.length - shown.length;
    final domainName = dot >= 0 ? dot : domain.length;
    return '$shown${'*' * (hiddenLocal < 1 ? 1 : hiddenLocal)}@'
        '${'*' * (domainName < 1 ? 1 : domainName)}$tld';
  }
}