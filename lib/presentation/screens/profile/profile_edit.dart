import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../core/state/profile_state.dart';
import '../../../data/models/user_profile.dart';
import '../../widgets/wheel_date_picker.dart';

/// Profil tersimpan di SQLite lewat ProfileState.
///
/// Alur tombol:
/// - Belum ada profil -> form langsung bisa diisi, tombol "Simpan Profile" (INSERT)
/// - Sudah ada profil -> form terkunci (mode lihat), tombol "Ubah Profile"
///     tekan "Ubah Profile" -> form terbuka, tombol jadi "Simpan Perubahan" (UPDATE)
///     "Hapus Akun" selalu tampil (tidak ada tombol "Batal")
class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController teleponController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController peringatanController = TextEditingController();

  static const _daftarNegara = [
    _Negara('ID', '+62', 'Indonesia'),
    _Negara('PH', '+63', 'Philippines'),
    _Negara('GB', '+44', 'United Kingdom'),
    _Negara('AU', '+61', 'Australia'),
    _Negara('SG', '+65', 'Singapore'),
    _Negara('MY', '+60', 'Malaysia'),
    _Negara('IN', '+91', 'India'),
    _Negara('JP', '+81', 'Japan'),
    _Negara('CN', '+86', 'China'),
    _Negara('VN', '+84', 'Vietnam'),
    _Negara('TH', '+66', 'Thailand'),
    _Negara('US', '+1', 'United States of America'),
    _Negara('CA', '+1', 'Canada'),
  ];
  static const _jenisKelaminList = ['Laki-laki', 'Perempuan'];

  String? _notif; // teks notifikasi sukses di atas tombol
  Timer? _notifTimer;

  _Negara negara = _daftarNegara.first;
  String get kodeNegara => negara.kode;
  String? jenisKelamin;
  bool detailTambahanTerbuka = false;

  UserProfile? _existing; // null = belum ada profil di database
  late bool _modeEdit; // false = hanya melihat, true = boleh mengubah
  bool _menyimpan = false;

  String? _namaError;
  String? _tanggalError;
  String? _teleponError;
  String? _emailError;

  static const Color primary = Color(0xFF205681);
  static const Color border = Color(0xFFE6E6E6);
  static const Color teksInput = Color(0xFF8A8A8A); // teks input agak pudar
  static const Color hintInput = Color(0xFFB5B5B5);
  static const Color abuAbu = Color(0xFFF2F2F2);

  // Bayangan tipis supaya kotak input terlihat terang & timbul
  static final List<BoxShadow> _bayangan = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 4,
      offset: const Offset(0, 1.5),
    ),
  ];

  // Email yang sudah tersimpan dianggap terverifikasi: disamarkan & terkunci
  bool get _emailTerkunci => (_existing?.email ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _existing = ProfileState.current.value;
    _isiForm(_existing); // READ: isi form dari database
    // Profil baru langsung bisa diisi; profil lama dimulai dari mode lihat
    _modeEdit = _existing == null;
    // Huruf avatar ikut berubah saat mengetik nama
    namaController.addListener(() => setState(() {}));
    // Ikon "i" tiap field hilang begitu field itu terisi
    for (final c in [
      tanggalController,
      teleponController,
      emailController,
      peringatanController,
    ]) {
      c.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _notifTimer?.cancel();
    namaController.dispose();
    tanggalController.dispose();
    teleponController.dispose();
    emailController.dispose();
    peringatanController.dispose();
    super.dispose();
  }

  /// Mengisi / mereset semua field dari data profil (atau kosong kalau null).
  void _isiForm(UserProfile? p) {
    namaController.text = p?.name ?? '';
    tanggalController.text = p?.birthDate ?? '';
    peringatanController.text = p?.anniversary ?? '';
    // String kosong dianggap belum diisi (dropdown butuh null, bukan '')
    jenisKelamin = (p?.gender ?? '').trim().isEmpty ? null : p!.gender;

    // phone disimpan lengkap dengan kode negara, mis. "+62812345678"
    final phone = p?.phone ?? '';
    var nomor = phone;
    negara = _daftarNegara.first;
    // Cocokkan kode terpanjang dulu (mis. +62 sebelum +6)
    final urut = [..._daftarNegara]
      ..sort((a, b) => b.kode.length.compareTo(a.kode.length));
    for (final n in urut) {
      if (phone.startsWith(n.kode)) {
        negara = n;
        nomor = phone.substring(n.kode.length);
        break;
      }
    }
    teleponController.text = nomor;

    emailController.text =
        (p?.email ?? '').isNotEmpty ? p!.maskedEmail : '';

    // Sekali terbuka, tetap terbuka (juga setelah Batal / Simpan)
    detailTambahanTerbuka = detailTambahanTerbuka ||
        (p?.gender ?? '').isNotEmpty ||
        (p?.anniversary ?? '').isNotEmpty;

    _namaError = null;
    _tanggalError = null;
    _teleponError = null;
    _emailError = null;
  }

  String _formatTanggal(DateTime t) =>
      '${t.day.toString().padLeft(2, '0')}-'
      '${t.month.toString().padLeft(2, '0')}-'
      '${t.year}';

  DateTime _parseTanggal(String teks, DateTime cadangan) {
    final bagian = teks.split('-');
    if (bagian.length == 3) {
      final d = int.tryParse(bagian[0]);
      final m = int.tryParse(bagian[1]);
      final y = int.tryParse(bagian[2]);
      if (d != null && m != null && y != null) return DateTime(y, m, d);
    }
    return cadangan;
  }

  Future<void> pilihTanggal() async {
    final DateTime? tanggal = await showWheelDatePicker(
      context,
      initialDate: _parseTanggal(tanggalController.text, DateTime(2005)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (tanggal != null) {
      setState(() {
        tanggalController.text = _formatTanggal(tanggal);
        _tanggalError = null;
      });
    }
  }

  Future<void> pilihTanggalPeringatan() async {
    final DateTime? tanggal = await showWheelDatePicker(
      context,
      initialDate: _parseTanggal(peringatanController.text, DateTime.now()),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (tanggal != null) peringatanController.text = _formatTanggal(tanggal);
  }

  /// Label field + ikon "i" kecil. Ikon tampil kalau:
  /// - mode ubah (sudah menekan "Ubah Profile") -> SEMUA field tampil "i", atau
  /// - mode lihat -> hanya field yang masih kosong ([kosong] true).
  /// Tekan ikon -> petunjuk muncul di sampingnya.
  Widget label(String teks, {String? info, bool kosong = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            teks,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (info != null && (_modeEdit || kosong)) ...[
            const SizedBox(width: 4),
            _IkonInfo(pesan: info),
          ],
        ],
      ),
    );
  }

  /// Pesan peringatan merah dengan ikon di bawah input.
  Widget pesanError(String? teks) {
    if (teks == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 2),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFC62828), size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(color: Color(0xFFC62828), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// [bisaDiubah] false -> field tidak bisa diketik/ditekan.
  /// [terkunci] true -> latar abu-abu (dipakai email yang sudah terverifikasi).
  Widget inputField({
    required TextEditingController controller,
    String? hint,
    bool bisaDiubah = true,
    bool terkunci = false,
    VoidCallback? onTap,
    Widget? prefix,
    bool adaError = false,
    ValueChanged<String>? onChanged,
    TextInputType? keyboardType,
  }) {
    OutlineInputBorder garis(Color warna, [double lebar = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: terkunci ? null : _bayangan,
      ),
      child: TextField(
        controller: controller,
        readOnly: !bisaDiubah || onTap != null,
        canRequestFocus: bisaDiubah,
        onTap: bisaDiubah ? onTap : null,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 13, color: teksInput),
        decoration: InputDecoration(
          filled: true,
          fillColor: terkunci ? abuAbu : Colors.white,
          hintText: hint,
          hintStyle: const TextStyle(color: hintInput, fontSize: 13),
          prefixIcon: prefix,
          prefixIconConstraints:
              const BoxConstraints(minWidth: 38, minHeight: 40),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          border: garis(adaError ? Colors.red : border),
          enabledBorder: garis(adaError ? Colors.red : border),
          disabledBorder: garis(adaError ? Colors.red : border),
          focusedBorder: garis(adaError ? Colors.red : primary, 1.3),
        ),
      ),
    );
  }

  /// Kotak teks statis untuk mode lihat (dipakai dropdown).
  Widget _kotakLihat(String teks, {double? lebar}) {
    return Container(
      width: lebar,
      height: 52,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        boxShadow: _bayangan,
      ),
      child: Text(
        teks,
        style: const TextStyle(fontSize: 13, color: teksInput),
      ),
    );
  }

  /// Bottom sheet "Pilih Kode Negara" dengan tombol X di atasnya.
  Future<void> pilihKodeNegara() async {
    final dipilih = await showModalBottomSheet<_Negara>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final tinggiMaks = MediaQuery.of(sheetContext).size.height * 0.78;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tombol tutup (X)
            GestureDetector(
              onTap: () => Navigator.pop(sheetContext),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF6B6B6B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: tinggiMaks),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 22),
                      child: Text(
                        'Pilih Kode Negara',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                        itemCount: _daftarNegara.length,
                        itemBuilder: (_, i) {
                          final n = _daftarNegara[i];
                          final aktif = n == negara;
                          return Material(
                            color: aktif
                                ? const Color(0xFFF2F2F2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => Navigator.pop(sheetContext, n),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    _Bendera(n.iso, lebar: 30),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Text(
                                        '${n.kode}  ${n.nama}',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    if (aktif)
                                      const Icon(Icons.check, size: 22),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    if (dipilih != null) setState(() => negara = dipilih);
  }

  Widget dropdownKodeNegara(double lebar) {
    final w = lebar < 340 ? 100.0 : 112.0;
    final isi = Row(
      children: [
        _Bendera(negara.iso, lebar: 26),
        const SizedBox(width: 8),
        Text(
          negara.kode,
          style: const TextStyle(fontSize: 13, color: teksInput),
        ),
        const Spacer(),
        if (_modeEdit)
          const Icon(Icons.keyboard_arrow_down, size: 20, color: teksInput),
      ],
    );

    return SizedBox(
      width: w,
      height: 52,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: border),
            boxShadow: _bayangan,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _modeEdit ? pilihKodeNegara : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: isi,
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdownJenisKelamin() {
    if (!_modeEdit) return _kotakLihat(jenisKelamin ?? '-');

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
        boxShadow: _bayangan,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: jenisKelamin,
          isExpanded: true,
          iconSize: 20,
          hint: const Text(
            'Pilih jenis kelamin',
            style: TextStyle(color: hintInput, fontSize: 13),
          ),
          style: const TextStyle(fontSize: 13, color: teksInput),
          items: [
            for (final j in _jenisKelaminList)
              DropdownMenuItem(value: j, child: Text(j)),
          ],
          onChanged: (value) => setState(() => jenisKelamin = value),
        ),
      ),
    );
  }

  String? _kosongJadiNull(String v) => v.trim().isEmpty ? null : v.trim();

  bool _validasi() {
    final nama = namaController.text.trim();
    final telepon = teleponController.text.trim();
    final email = emailController.text.trim();

    String? errNama;
    String? errTanggal;
    String? errTelepon;
    String? errEmail;

    if (nama.isEmpty) {
      errNama = 'Nama wajib diisi';
    } else if (nama.length < 2) {
      errNama = 'Nama terlalu pendek';
    }

    if (tanggalController.text.trim().isEmpty) {
      errTanggal = 'Tanggal lahir diperlukan';
    }

    if (telepon.isEmpty) {
      errTelepon = 'Verifikasi nomor telepon diperlukan';
    } else if (!RegExp(r'^[0-9]{8,13}$').hasMatch(telepon)) {
      errTelepon = 'Nomor telepon harus 8-13 digit angka';
    }

    if (!_emailTerkunci &&
        email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      errEmail = 'Format email tidak valid';
    }

    setState(() {
      _namaError = errNama;
      _tanggalError = errTanggal;
      _teleponError = errTelepon;
      _emailError = errEmail;
    });
    return errNama == null &&
        errTanggal == null &&
        errTelepon == null &&
        errEmail == null;
  }

  void mulaiUbah() => setState(() => _modeEdit = true);

  // CREATE (id null) atau UPDATE (id ada)
  Future<void> simpanProfil() async {
    if (!_validasi()) return;
    setState(() => _menyimpan = true);

    try {
      var telepon = teleponController.text.trim();
      if (telepon.startsWith('0')) telepon = telepon.substring(1);

      final profil = UserProfile(
        id: _existing?.id,
        name: namaController.text.trim(),
        birthDate: _kosongJadiNull(tanggalController.text),
        phone: telepon.isEmpty ? null : '$kodeNegara$telepon',
        email: _emailTerkunci
            ? _existing!.email
            : _kosongJadiNull(emailController.text),
        gender: jenisKelamin,
        anniversary: _kosongJadiNull(peringatanController.text),
      );

      final baru = _existing == null;
      await ProfileState.save(profil);
      if (!mounted) return;

      // Muat ulang dari state supaya form menampilkan data yang tersimpan
      // (termasuk email yang kini disamarkan & terkunci), lalu kunci lagi.
      _existing = ProfileState.current.value;
      _isiForm(_existing);
      setState(() {
        _menyimpan = false;
        _modeEdit = false;
      });

      _tampilNotif(baru ? 'Berhasil disimpan' : 'Berhasil diperbarui');
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  /// Tampilkan notifikasi kuning di atas tombol bawah selama 3 detik.
  void _tampilNotif(String teks) {
    _notifTimer?.cancel();
    setState(() => _notif = teks);
    _notifTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _notif = null);
    });
  }

  Widget _bannerNotif() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _notif == null
          ? const SizedBox.shrink(key: ValueKey('notif-kosong'))
          : Container(
              key: ValueKey(_notif),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDEED9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.check, color: Color(0xFF4CAF00), size: 22),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      _notif!,
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // DELETE
  Future<void> hapusAkun() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus akun? '
          'Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus Akun',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;
    await ProfileState.delete();
    if (!mounted) return;
    // Tampilkan notifikasi kuning yang sama, tahan sebentar, baru keluar
    setState(() => _menyimpan = true); // kunci tombol selama notifikasi
    _tampilNotif('Akun berhasil dihapus');
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pop(context);
  }

  Widget _tombolBawah() {
    final adaProfil = _existing != null;

    final teksUtama = !adaProfil
        ? 'Simpan Profile'
        : (_modeEdit ? 'Simpan Perubahan' : 'Ubah Profile');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TOMBOL UTAMA: Ubah Profile -> (ditekan) -> Simpan Perubahan
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _menyimpan ? null : (_modeEdit ? simpanProfil : mulaiUbah),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _menyimpan
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    teksUtama,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),

        // HAPUS AKUN: selalu tampil kalau profil sudah ada (mode lihat & ubah)
        if (adaProfil) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: _menyimpan ? null : hapusAkun,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Hapus Akun',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final inisial = namaController.text.trim().isEmpty
        ? (_existing?.initial ?? 'T')
        : namaController.text.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final lebar = constraints.maxWidth;
            final padding = lebar < 360 ? 16.0 : 20.0;

            return Column(
              children: [
                // HEADER
                Padding(
                  padding: EdgeInsets.fromLTRB(padding, 12, padding, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                        iconSize: 22,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Ubah Profile',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // KONTEN SCROLL
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(padding, 15, padding, 20),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // FOTO PROFIL (huruf pertama nama)
                            Center(
                              child: Container(
                                width: 92,
                                height: 92,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFFE4F5D3),
                                      Color(0xFFB4E27A),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  inisial,
                                  style: const TextStyle(
                                    fontSize: 43,
                                    color: Color(0xFF3F9A00),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            const Text(
                              'Informasi Pribadi',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // NAMA
                            label(
                              'Nama',
                              kosong: namaController.text.trim().isEmpty,
                              info: 'Mohon masukkan nama lengkap Anda',
                            ),
                            inputField(
                              controller: namaController,
                              hint: 'Masukkan nama Anda',
                              bisaDiubah: _modeEdit,
                              adaError: _namaError != null,
                            ),
                            pesanError(_namaError),

                            const SizedBox(height: 15),

                            // TANGGAL LAHIR
                            label(
                              'Tanggal Lahir',
                              kosong: tanggalController.text.trim().isEmpty,
                              info: 'Mohon masukkan tanggal lahir Anda yang '
                                  'valid dengan format HH-BB-TTTT',
                            ),
                            inputField(
                              controller: tanggalController,
                              hint: 'DD-MM-YYYY',
                              bisaDiubah: _modeEdit,
                              onTap: pilihTanggal,
                              adaError: _tanggalError != null,
                              prefix: const Icon(
                                Icons.calendar_today_outlined,
                                size: 17,
                                color: Colors.grey,
                              ),
                            ),
                            pesanError(_tanggalError),

                            const SizedBox(height: 15),

                            // NOMOR TELEPON
                            label(
                              'Nomor Telepon',
                              kosong: teleponController.text.trim().isEmpty,
                              info: 'Mohon pilih kode negara Anda dan 8-13 '
                                  'digit nomor telepon yang valid',
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                dropdownKodeNegara(lebar),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: inputField(
                                    controller: teleponController,
                                    hint: '-',
                                    bisaDiubah: _modeEdit,
                                    keyboardType: TextInputType.phone,
                                    adaError: _teleponError != null,
                                    prefix: const Icon(
                                      Icons.info,
                                      color: Color(0xFFFF9800),
                                      size: 20,
                                    ),
                                    onChanged: (_) {
                                      if (_teleponError != null) {
                                        setState(() => _teleponError = null);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            pesanError(_teleponError),

                            const SizedBox(height: 15),

                            // EMAIL (terkunci kalau sudah tersimpan)
                            label(
                              'Alamat Email',
                              kosong: emailController.text.trim().isEmpty,
                              info: 'Mohon masukkan alamat email Anda yang valid',
                            ),
                            inputField(
                              controller: emailController,
                              hint: 'Masukkan Alamat Email',
                              bisaDiubah: _modeEdit && !_emailTerkunci,
                              terkunci: _emailTerkunci,
                              keyboardType: TextInputType.emailAddress,
                              adaError: _emailError != null,
                              prefix: _emailTerkunci
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF62BD16),
                                      size: 18,
                                    )
                                  : null,
                            ),
                            pesanError(_emailError),

                            const SizedBox(height: 18),

                            // TOMBOL TAMBAHKAN DETAIL: tampil di mode lihat & ubah,
                            // hilang setelah ditekan (field-nya tetap tampil)
                            if (!detailTambahanTerbuka)
                              Center(
                                child: FractionallySizedBox(
                                  widthFactor: 0.66,
                                  child: SizedBox(
                                    height: 40,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          detailTambahanTerbuka = true;
                                        });
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        side: const BorderSide(color: border),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Tambahkan detail lainnya',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            // DETAIL TAMBAHAN: tetap tampil setelah dibuka
                            if (detailTambahanTerbuka) ...[
                              label(
                                'Jenis Kelamin',
                                kosong: jenisKelamin == null || jenisKelamin!.isEmpty,
                                info: 'Mohon masukkan jenis kelamin Anda',
                              ),
                              dropdownJenisKelamin(),

                              const SizedBox(height: 15),

                              label(
                                'Peringatan Tahunan',
                                kosong: peringatanController.text.trim().isEmpty,
                                info: 'Mohon pilih tanggal peringatan tahunan Anda',
                              ),
                              inputField(
                                controller: peringatanController,
                                hint: 'Pilih tanggal',
                                bisaDiubah: _modeEdit,
                                onTap: pilihTanggalPeringatan,
                                prefix: const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                      ),
                      // NOTIFIKASI: tepat di atas tombol bawah
                      Positioned(
                        left: padding,
                        right: padding,
                        bottom: 12,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 480),
                            child: _bannerNotif(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // TOMBOL BAWAH TETAP
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 8,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: _tombolBawah(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Negara {
  final String iso; // kode negara 2 huruf untuk menggambar bendera
  final String kode;
  final String nama;
  const _Negara(this.iso, this.kode, this.nama);
}

/// Ikon "i" kecil. Saat ditekan, petunjuk muncul DI SAMPING ikon
/// (rata tengah secara vertikal) dan hilang sendiri setelah 3 detik.
class _IkonInfo extends StatefulWidget {
  final String pesan;
  const _IkonInfo({required this.pesan});

  @override
  State<_IkonInfo> createState() => _IkonInfoState();
}

class _IkonInfoState extends State<_IkonInfo> {
  static _IkonInfoState? _aktif; // hanya satu petunjuk terbuka sekaligus

  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  Timer? _timer;

  ValueNotifier<bool>? _terlihat;

  void _mulaiTimer() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 4), _tutup);
  }

  /// Tutup petunjuk. Normalnya memudar pelan dulu; [langsung] true = tanpa animasi.
  void _tutup({bool langsung = false}) {
    _timer?.cancel();
    final entry = _entry;
    final terlihat = _terlihat;
    _entry = null;
    _terlihat = null;
    if (identical(_aktif, this)) _aktif = null;
    if (entry == null) return;
    if (langsung) {
      if (entry.mounted) entry.remove();
      return;
    }
    terlihat?.value = false; // mulai memudar
    Timer(const Duration(milliseconds: 400), () {
      if (entry.mounted) entry.remove();
    });
  }

  void _buka() {
    if (_entry != null) {
      _mulaiTimer(); // ditekan lagi -> hitung ulang durasi tampil
      return;
    }
    _aktif?._tutup();

    // Lebar maksimal = sisa ruang di kanan ikon sampai tepi layar
    final box = context.findRenderObject() as RenderBox;
    final kanan = box.localToGlobal(Offset(box.size.width, 0)).dx;
    final lebarLayar = MediaQuery.of(context).size.width;
    final lebarMaks = (lebarLayar - kanan - 8 - 20).clamp(140.0, 360.0);

    final terlihat = ValueNotifier<bool>(false);
    _terlihat = terlihat;

    _entry = OverlayEntry(
      builder: (_) => Positioned(
        left: 0,
        top: 0,
        child: CompositedTransformFollower(
          link: _link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: const Offset(8, 0),
          child: IgnorePointer(
            child: ValueListenableBuilder<bool>(
              valueListenable: terlihat,
              builder: (_, tampil, child) => AnimatedOpacity(
                opacity: tampil ? 1 : 0,
                duration: Duration(milliseconds: tampil ? 150 : 350),
                child: child,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(maxWidth: lebarMaks),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.pesan,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_entry!);
    _aktif = this;
    // Fade-in di frame berikutnya, lalu hilang pelan setelah beberapa detik
    WidgetsBinding.instance.addPostFrameCallback((_) {
      terlihat.value = true;
    });
    _mulaiTimer();
  }

  @override
  void dispose() {
    _tutup(langsung: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _buka,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: CompositedTransformTarget(
          link: _link,
          child: const Icon(
            Icons.info_outline,
            color: Color(0xFF1D607D),
            size: 16,
          ),
        ),
      ),
    );
  }
}

/// Bendera digambar manual (kotak berwarna), tanpa emoji / gambar.
class _Bendera extends StatelessWidget {
  final String iso;
  final double lebar;
  const _Bendera(this.iso, {this.lebar = 28});

  @override
  Widget build(BuildContext context) {
    final tinggi = lebar * 2 / 3;
    return Container(
      width: lebar,
      height: tinggi,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CustomPaint(
          size: Size(lebar, tinggi),
          painter: _BenderaPainter(iso),
        ),
      ),
    );
  }
}

class _BenderaPainter extends CustomPainter {
  final String iso;
  const _BenderaPainter(this.iso);

  static const _putih = Color(0xFFFFFFFF);

  Paint _p(Color c) => Paint()..color = c;

  void _kotak(Canvas c, double x, double y, double w, double h, Color col) {
    c.drawRect(Rect.fromLTWH(x, y, w, h), _p(col));
  }

  /// Garis horizontal berwarna dengan bobot tinggi masing-masing.
  void _garisH(Canvas c, Size s, List<Color> warna, [List<double>? bobot]) {
    final b = bobot ?? List.filled(warna.length, 1.0);
    final total = b.fold<double>(0, (a, e) => a + e);
    double y = 0;
    for (var i = 0; i < warna.length; i++) {
      final tinggi = s.height * b[i] / total;
      // +0.5 menutup celah antar garis akibat pembulatan
      _kotak(c, 0, y, s.width, tinggi + 0.5, warna[i]);
      y += tinggi;
    }
  }

  void _bintang(Canvas c, Offset pusat, double r, Color col) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final jari = i.isEven ? r : r * 0.4;
      final sudut = -math.pi / 2 + i * math.pi / 5;
      final pt = Offset(
        pusat.dx + jari * math.cos(sudut),
        pusat.dy + jari * math.sin(sudut),
      );
      i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    c.drawPath(path, _p(col));
  }

  void _bulanSabit(Canvas c, Offset pusat, double r, Color col, Color latar) {
    c.drawCircle(pusat, r, _p(col));
    c.drawCircle(pusat.translate(r * 0.4, 0), r * 0.82, _p(latar));
  }

  void _unionJack(Canvas c, Rect r) {
    c.save();
    c.clipRect(r);
    c.translate(r.left, r.top);
    final w = r.width, h = r.height;
    c.drawRect(Rect.fromLTWH(0, 0, w, h), _p(const Color(0xFF012169)));
    final putihGaris = _p(_putih)
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.22;
    final merahGaris = _p(const Color(0xFFC8102E))
      ..style = PaintingStyle.stroke
      ..strokeWidth = h * 0.08;
    for (final g in [putihGaris, merahGaris]) {
      c.drawLine(Offset.zero, Offset(w, h), g);
      c.drawLine(Offset(w, 0), Offset(0, h), g);
    }
    _kotak(c, 0, h * 0.33, w, h * 0.34, _putih);
    _kotak(c, w * 0.4, 0, w * 0.2, h, _putih);
    _kotak(c, 0, h * 0.4, w, h * 0.2, const Color(0xFFC8102E));
    _kotak(c, w * 0.43, 0, w * 0.14, h, const Color(0xFFC8102E));
    c.restore();
  }

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    switch (iso) {
      case 'ID':
        _garisH(c, s, const [Color(0xFFE70011), _putih]);
        break;

      case 'PH':
        _garisH(c, s, const [Color(0xFF0038A8), Color(0xFFCE1126)]);
        final segitiga = Path()
          ..moveTo(0, 0)
          ..lineTo(w * 0.5, h / 2)
          ..lineTo(0, h)
          ..close();
        c.drawPath(segitiga, _p(_putih));
        c.drawCircle(Offset(w * 0.16, h / 2), h * 0.08,
            _p(const Color(0xFFFCD116)));
        break;

      case 'GB':
        _unionJack(c, Rect.fromLTWH(0, 0, w, h));
        break;

      case 'AU':
        _kotak(c, 0, 0, w, h, const Color(0xFF012169));
        _unionJack(c, Rect.fromLTWH(0, 0, w / 2, h / 2));
        _bintang(c, Offset(w * 0.25, h * 0.76), h * 0.13, _putih);
        for (final o in [
          Offset(w * 0.76, h * 0.2),
          Offset(w * 0.62, h * 0.45),
          Offset(w * 0.88, h * 0.4),
          Offset(w * 0.76, h * 0.78),
        ]) {
          _bintang(c, o, h * 0.075, _putih);
        }
        break;

      case 'SG':
        const merah = Color(0xFFEF3340);
        _garisH(c, s, const [merah, _putih]);
        _bulanSabit(c, Offset(w * 0.2, h * 0.25), h * 0.17, _putih, merah);
        for (final o in [
          Offset(w * 0.34, h * 0.14),
          Offset(w * 0.3, h * 0.3),
          Offset(w * 0.4, h * 0.22),
        ]) {
          c.drawCircle(o, h * 0.035, _p(_putih));
        }
        break;

      case 'MY':
        const biru = Color(0xFF010066);
        _garisH(
          c,
          s,
          [for (var i = 0; i < 14; i++) i.isEven ? const Color(0xFFCC0001) : _putih],
        );
        _kotak(c, 0, 0, w * 0.5, h * 0.5, biru);
        _bulanSabit(c, Offset(w * 0.2, h * 0.25), h * 0.16,
            const Color(0xFFFFCC00), biru);
        _bintang(c, Offset(w * 0.34, h * 0.25), h * 0.09,
            const Color(0xFFFFCC00));
        break;

      case 'IN':
        _garisH(c, s, const [
          Color(0xFFFF9933),
          _putih,
          Color(0xFF138808),
        ]);
        c.drawCircle(
          Offset(w / 2, h / 2),
          h * 0.11,
          _p(const Color(0xFF000080))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1,
        );
        break;

      case 'JP':
        _kotak(c, 0, 0, w, h, _putih);
        c.drawCircle(Offset(w / 2, h / 2), h * 0.3, _p(const Color(0xFFBC002D)));
        break;

      case 'CN':
        const kuning = Color(0xFFFFDE00);
        _kotak(c, 0, 0, w, h, const Color(0xFFDE2910));
        _bintang(c, Offset(w * 0.17, h * 0.26), h * 0.18, kuning);
        for (final o in [
          Offset(w * 0.34, h * 0.1),
          Offset(w * 0.4, h * 0.22),
          Offset(w * 0.4, h * 0.38),
          Offset(w * 0.34, h * 0.5),
        ]) {
          _bintang(c, o, h * 0.055, kuning);
        }
        break;

      case 'VN':
        _kotak(c, 0, 0, w, h, const Color(0xFFDA251D));
        _bintang(c, Offset(w / 2, h * 0.53), h * 0.32, const Color(0xFFFFFF00));
        break;

      case 'TH':
        _garisH(
          c,
          s,
          const [
            Color(0xFFA51931),
            _putih,
            Color(0xFF2D2A4A),
            _putih,
            Color(0xFFA51931),
          ],
          const [1, 1, 2, 1, 1],
        );
        break;

      case 'US':
        _garisH(
          c,
          s,
          [for (var i = 0; i < 13; i++) i.isEven ? const Color(0xFFB22234) : _putih],
        );
        _kotak(c, 0, 0, w * 0.42, h * 7 / 13, const Color(0xFF3C3B6E));
        for (var baris = 0; baris < 4; baris++) {
          for (var kol = 0; kol < 5; kol++) {
            c.drawCircle(
              Offset(w * (0.05 + kol * 0.08), h * (0.07 + baris * 0.12)),
              h * 0.028,
              _p(_putih),
            );
          }
        }
        break;

      case 'CA':
        const merah = Color(0xFFD52B1E);
        _kotak(c, 0, 0, w, h, _putih);
        _kotak(c, 0, 0, w * 0.25, h, merah);
        _kotak(c, w * 0.75, 0, w * 0.25, h, merah);
        // Daun maple disederhanakan (setengah kanan, lalu dicerminkan)
        const kanan = [
          Offset(0, -1),
          Offset(0.18, -0.6),
          Offset(0.4, -0.7),
          Offset(0.33, -0.28),
          Offset(0.7, -0.48),
          Offset(0.6, -0.1),
          Offset(0.95, -0.02),
          Offset(0.72, 0.22),
          Offset(0.8, 0.42),
          Offset(0.32, 0.34),
          Offset(0.06, 0.4),
          Offset(0.06, 0.95),
        ];
        final skala = h * 0.3;
        final pusat = Offset(w / 2, h * 0.47);
        final daun = Path();
        for (var i = 0; i < kanan.length; i++) {
          final pt = pusat + kanan[i] * skala;
          i == 0 ? daun.moveTo(pt.dx, pt.dy) : daun.lineTo(pt.dx, pt.dy);
        }
        for (var i = kanan.length - 1; i >= 0; i--) {
          final pt = pusat + Offset(-kanan[i].dx, kanan[i].dy) * skala;
          daun.lineTo(pt.dx, pt.dy);
        }
        daun.close();
        c.drawPath(daun, _p(merah));
        break;

      default:
        _kotak(c, 0, 0, w, h, const Color(0xFFBDBDBD));
    }
  }

  @override
  bool shouldRepaint(covariant _BenderaPainter old) => old.iso != iso;
}