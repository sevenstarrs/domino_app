import 'package:flutter/material.dart';

import '../../../core/state/profile_state.dart';
import '../../../data/models/user_profile.dart';

/// Create / Update / Delete profil, tersimpan di SQLite lewat ProfileState.
/// - Belum ada profil -> tombol "Simpan Profile"  (INSERT)
/// - Sudah ada profil -> tombol "Ubah Profile"    (UPDATE) + "Hapus Akun" (DELETE)
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

<<<<<<< HEAD
  final TextEditingController emailController = TextEditingController(
    text: 'ga****************@******.com',
  );

  final TextEditingController peringatanController = TextEditingController();

=======
  static const _kodeNegaraList = ['+62', '+60', '+65'];
>>>>>>> 074471b2a703aec814dbe763de4e77f88aa6e193
  String kodeNegara = '+62';
  String? jenisKelamin;

  bool detailTambahanTerbuka = false;

  UserProfile? _existing; // null = belum ada profil di database
  bool _menyimpan = false;

  String? _namaError;
  String? _teleponError;
  String? _emailError;

  static const Color primary = Color(0xFF205681);
  static const Color border = Color(0xFFDDDDDD);

  // Email yang sudah tersimpan dianggap terverifikasi: tampil disamarkan & terkunci
  bool get _emailTerkunci => (_existing?.email ?? '').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _existing = ProfileState.current.value; // READ: isi form dari database
    final p = _existing;
    if (p != null) {
      namaController.text = p.name;
      tanggalController.text = p.birthDate ?? '';

      // phone disimpan lengkap dengan kode negara, mis. "+62812345678"
      final phone = p.phone ?? '';
      var nomor = phone;
      for (final kode in _kodeNegaraList) {
        if (phone.startsWith(kode)) {
          kodeNegara = kode;
          nomor = phone.substring(kode.length);
          break;
        }
      }
      teleponController.text = nomor;

      if (_emailTerkunci) emailController.text = p.maskedEmail;
    }
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

  Future<void> pilihTanggal() async {
    var awal = DateTime(2005);
    final bagian = tanggalController.text.split('-');
    if (bagian.length == 3) {
      final d = int.tryParse(bagian[0]);
      final m = int.tryParse(bagian[1]);
      final y = int.tryParse(bagian[2]);
      if (d != null && m != null && y != null) awal = DateTime(y, m, d);
    }

    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (tanggal != null) {
      tanggalController.text =
          '${tanggal.day.toString().padLeft(2, '0')}-'
          '${tanggal.month.toString().padLeft(2, '0')}-'
          '${tanggal.year}';
    }
  }

  Future<void> pilihTanggalPeringatan() async {
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal peringatan',
    );

    if (tanggal != null) {
      peringatanController.text =
          '${tanggal.day.toString().padLeft(2, '0')}-'
          '${tanggal.month.toString().padLeft(2, '0')}-'
          '${tanggal.year}';
    }
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

  Widget inputField({
    required TextEditingController controller,
    String? hint,
    bool enabled = true,
    VoidCallback? onTap,
    Widget? prefix,
    String? errorText,
    TextInputType? keyboardType,
  }) {
<<<<<<< HEAD
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        enabled: enabled,
        readOnly: onTap != null,
        onTap: onTap,
        style: const TextStyle(fontSize: 13, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          prefixIcon: prefix,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 38,
            minHeight: 40,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary, width: 1.3),
          ),
        ),
=======
    OutlineInputBorder garis(Color warna, [double lebar = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: warna, width: lebar),
        );

    // Tinggi tidak dikunci (tanpa SizedBox height) supaya pesan error muncul
    // di bawah field tanpa terpotong.
    return TextField(
      controller: controller,
      enabled: enabled,
      readOnly: onTap != null,
      onTap: onTap,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
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
>>>>>>> 074471b2a703aec814dbe763de4e77f88aa6e193
      ),
    );
  }

<<<<<<< HEAD
  Widget dropdownJenisKelamin() {
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
          hint: const Text(
            'Pilih jenis kelamin',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: const [
            DropdownMenuItem(
              value: 'Laki-laki',
              child: Text('Laki-laki', style: TextStyle(fontSize: 13)),
            ),
            DropdownMenuItem(
              value: 'Perempuan',
              child: Text('Perempuan', style: TextStyle(fontSize: 13)),
            ),
          ],
          onChanged: (value) {
            setState(() {
              jenisKelamin = value;
            });
          },
        ),
      ),
    );
  }

=======
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
      );

      final baru = _existing == null;
      await ProfileState.save(profil);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            baru ? 'Profile berhasil disimpan' : 'Profile berhasil diperbarui',
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _menyimpan = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    }
  }

  // DELETE
>>>>>>> 074471b2a703aec814dbe763de4e77f88aa6e193
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
                              errorText: _namaError,
                            ),

                            const SizedBox(height: 15),

                            // TANGGAL LAHIR
                            label('Tanggal Lahir', info: true),
                            inputField(
                              controller: tanggalController,
                              hint: 'DD-MM-YYYY',
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
                                SizedBox(
                                  width: lebar < 340 ? 85 : 96,
                                  height: 52,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: border),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: kodeNegara,
                                        isExpanded: true,
                                        iconSize: 18,
                                        items: const [
                                          DropdownMenuItem(
                                            value: '+62',
                                            child: Text(
                                              '🇮🇩 +62',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: '+60',
                                            child: Text(
                                              '+60',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: '+65',
                                            child: Text(
                                              '+65',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() => kodeNegara = value);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Expanded(
                                  child: inputField(
                                    controller: teleponController,
                                    hint: '-',
                                    keyboardType: TextInputType.phone,
                                    errorText: _teleponError,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // EMAIL
                            label('Alamat Email'),
                            inputField(
                              controller: emailController,
                              enabled: !_emailTerkunci,
                              hint: 'Masukkan Alamat Email',
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

                            // TOMBOL TAMBAHKAN DETAIL
                            if (!detailTambahanTerbuka)
                              Center(
                                child: SizedBox(
                                  width: 210,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      'Tambahkan detail lainnya',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),

                            // DUA KOLOM TAMBAHAN
                            if (detailTambahanTerbuka) ...[
                              label('Jenis Kelamin'),
                              dropdownJenisKelamin(),

                              const SizedBox(height: 15),

                              label('Peringatan Tahunan'),
                              inputField(
                                controller: peringatanController,
                                hint: 'Pilih tanggal',
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
<<<<<<< HEAD
=======
                          // SIMPAN / UBAH PROFILE
>>>>>>> 074471b2a703aec814dbe763de4e77f88aa6e193
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _menyimpan ? null : simpanProfil,
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
                                      _existing == null
                                          ? 'Simpan Profile'
                                          : 'Ubah Profile',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),

<<<<<<< HEAD
                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: hapusAkun,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
=======
                          // HAPUS AKUN (hanya kalau profil sudah ada)
                          if (_existing != null) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: hapusAkun,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
>>>>>>> 074471b2a703aec814dbe763de4e77f88aa6e193
                                ),
                                child: const Text(
                                  'Hapus Akun',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
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