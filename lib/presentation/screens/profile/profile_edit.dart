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
///     "Hapus Akun" selalu tampil; "Batal" muncul saat mode ubah
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

  static const _kodeNegaraList = ['+62', '+60', '+65'];
  static const _jenisKelaminList = ['Laki-laki', 'Perempuan'];

  String kodeNegara = '+62';
  String? jenisKelamin;
  bool detailTambahanTerbuka = false;

  UserProfile? _existing; // null = belum ada profil di database
  late bool _modeEdit; // false = hanya melihat, true = boleh mengubah
  bool _menyimpan = false;

  String? _namaError;
  String? _teleponError;
  String? _emailError;

  static const Color primary = Color(0xFF205681);
  static const Color border = Color(0xFFDDDDDD);
  static const Color abuAbu = Color(0xFFF5F5F5);

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
    kodeNegara = '+62';
    for (final kode in _kodeNegaraList) {
      if (phone.startsWith(kode)) {
        kodeNegara = kode;
        nomor = phone.substring(kode.length);
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
    if (tanggal != null) tanggalController.text = _formatTanggal(tanggal);
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

  Widget label(String teks, {bool info = false}) {
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
          if (info) ...[
            const SizedBox(width: 6),
            const Icon(Icons.info_outline, color: Color(0xFF1D607D), size: 16),
          ],
        ],
      ),
    );
  }

  /// [bisaDiubah] false -> field hanya tampil (abu-abu, tidak bisa diketik/ditekan).
  Widget inputField({
    required TextEditingController controller,
    String? hint,
    bool bisaDiubah = true,
    VoidCallback? onTap,
    Widget? prefix,
    String? errorText,
    TextInputType? keyboardType,
  }) {
    OutlineInputBorder garis(Color warna, [double lebar = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    return TextField(
      controller: controller,
      readOnly: !bisaDiubah || onTap != null,
      canRequestFocus: bisaDiubah,
      onTap: bisaDiubah ? onTap : null,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: bisaDiubah ? Colors.white : abuAbu,
        hintText: hint,
        errorText: errorText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: prefix,
        prefixIconConstraints:
            const BoxConstraints(minWidth: 38, minHeight: 40),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
        border: garis(border),
        enabledBorder: garis(border),
        disabledBorder: garis(border),
        focusedBorder: garis(primary, 1.3),
        errorBorder: garis(Colors.red),
        focusedErrorBorder: garis(Colors.red, 1.3),
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
        color: abuAbu,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border),
      ),
      child: Text(
        teks,
        style: const TextStyle(fontSize: 13, color: Colors.black),
      ),
    );
  }

  Widget dropdownKodeNegara(double lebar) {
    final w = lebar < 340 ? 85.0 : 96.0;
    if (!_modeEdit) {
      return _kotakLihat(
        kodeNegara == '+62' ? '🇮🇩 +62' : kodeNegara,
        lebar: w,
      );
    }
    return SizedBox(
      width: w,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: kodeNegara,
            isExpanded: true,
            iconSize: 18,
            items: const [
              DropdownMenuItem(
                value: '+62',
                child: Text('🇮🇩 +62', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: '+60',
                child: Text('+60', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: '+65',
                child: Text('+65', style: TextStyle(fontSize: 12)),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => kodeNegara = value);
            },
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
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: jenisKelamin,
          isExpanded: true,
          iconSize: 20,
          hint: const Text(
            'Pilih jenis kelamin',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          style: const TextStyle(fontSize: 13, color: Colors.black),
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
    String? errTelepon;
    String? errEmail;

    if (nama.isEmpty) {
      errNama = 'Nama wajib diisi';
    } else if (nama.length < 2) {
      errNama = 'Nama terlalu pendek';
    }

    if (telepon.isNotEmpty && !RegExp(r'^[0-9]{8,13}$').hasMatch(telepon)) {
      errTelepon = '8-13 digit angka';
    }

    if (!_emailTerkunci &&
        email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      errEmail = 'Format email tidak valid';
    }

    setState(() {
      _namaError = errNama;
      _teleponError = errTelepon;
      _emailError = errEmail;
    });
    return errNama == null && errTelepon == null && errEmail == null;
  }

  void mulaiUbah() => setState(() => _modeEdit = true);

  /// Batalkan perubahan: kembalikan form ke data di database, lalu kunci lagi.
  void batalUbah() {
    _isiForm(_existing);
    setState(() => _modeEdit = false);
  }

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

        // BATAL: hanya saat mode ubah, dibuat ringkas (text button)
        if (adaProfil && _modeEdit)
          TextButton(
            onPressed: _menyimpan ? null : batalUbah,
            child: const Text(
              'Batal',
              style: TextStyle(color: primary, fontSize: 14),
            ),
          ),
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
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: const Color(0xFFB8E37E),
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
                            label('Nama'),
                            inputField(
                              controller: namaController,
                              hint: 'Masukkan nama Anda',
                              bisaDiubah: _modeEdit,
                              errorText: _namaError,
                            ),

                            const SizedBox(height: 15),

                            // TANGGAL LAHIR
                            label('Tanggal Lahir', info: true),
                            inputField(
                              controller: tanggalController,
                              hint: 'DD-MM-YYYY',
                              bisaDiubah: _modeEdit,
                              onTap: pilihTanggal,
                              prefix: const Icon(
                                Icons.calendar_today_outlined,
                                size: 17,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // NOMOR TELEPON
                            label('Nomor Telepon', info: true),
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
                                    errorText: _teleponError,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // EMAIL (terkunci kalau sudah tersimpan)
                            label('Alamat Email'),
                            inputField(
                              controller: emailController,
                              hint: 'Masukkan Alamat Email',
                              bisaDiubah: _modeEdit && !_emailTerkunci,
                              keyboardType: TextInputType.emailAddress,
                              errorText: _emailError,
                              prefix: _emailTerkunci
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF62BD16),
                                      size: 18,
                                    )
                                  : null,
                            ),

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
                              label('Jenis Kelamin'),
                              dropdownJenisKelamin(),

                              const SizedBox(height: 15),

                              label('Peringatan Tahunan'),
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
                ),

                // TOMBOL BAWAH TETAP
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(padding, 12, padding, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
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