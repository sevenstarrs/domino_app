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
    _Negara('🇮🇩', '+62', 'Indonesia'),
    _Negara('🇵🇭', '+63', 'Philippines'),
    _Negara('🇬🇧', '+44', 'United Kingdom'),
    _Negara('🇦🇺', '+61', 'Australia'),
    _Negara('🇸🇬', '+65', 'Singapore'),
    _Negara('🇲🇾', '+60', 'Malaysia'),
    _Negara('🇮🇳', '+91', 'India'),
    _Negara('🇯🇵', '+81', 'Japan'),
    _Negara('🇨🇳', '+86', 'China'),
    _Negara('🇻🇳', '+84', 'Vietnam'),
    _Negara('🇹🇭', '+66', 'Thailand'),
    _Negara('🇺🇸', '+1', 'United States of America'),
    _Negara('🇨🇦', '+1', 'Canada'),
  ];
  static const _jenisKelaminList = ['Laki-laki', 'Perempuan'];

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
  }

  @override
  void dispose() {
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
    jenisKelamin = p?.gender;

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

  /// Label field + ikon "i" kecil. Tekan ikon untuk menampilkan petunjuk.
  Widget label(String teks, {String? info}) {
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
          if (info != null) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: info,
              triggerMode: TooltipTriggerMode.tap,
              waitDuration: Duration.zero,
              showDuration: const Duration(seconds: 3),
              preferBelow: false,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF555555),
              ),
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
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.info_outline,
                  color: Color(0xFF1D607D),
                  size: 16,
                ),
              ),
            ),
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
                                    Text(
                                      n.bendera,
                                      style: const TextStyle(fontSize: 22),
                                    ),
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
        Text(negara.bendera, style: const TextStyle(fontSize: 18)),
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
    if (!_modeEdit) return _kotakLihat(jenisKelamin ?? 'Pilih Jenis Kelamin');

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            baru ? 'Profile berhasil disimpan' : 'Profile berhasil diperbarui',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Akun berhasil dihapus')),
    );
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
                  child: SingleChildScrollView(
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
                            label('Nama', info: 'Mohon masukkan nama lengkap Anda'),
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
                                info: 'Mohon masukkan jenis kelamin Anda',
                              ),
                              dropdownJenisKelamin(),

                              const SizedBox(height: 15),

                              label(
                                'Peringatan Tahunan',
                                info: 'Mohon pilih tanggal peringatan tahunan dengan format TTTT-BB-HH',
                              ),
                              inputField(
                                controller: peringatanController,
                                hint: 'Pilih Tanggal',
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
  final String bendera;
  final String kode;
  final String nama;
  const _Negara(this.bendera, this.kode, this.nama);
}