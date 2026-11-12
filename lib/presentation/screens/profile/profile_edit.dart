import 'package:flutter/material.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController namaController = TextEditingController(
    text: 'Gadiza Nabila Pt1',
  );

  final TextEditingController tanggalController = TextEditingController();

  final TextEditingController teleponController = TextEditingController();

  final TextEditingController emailController = TextEditingController(
    text: 'ga****************@******.com',
  );

  final TextEditingController peringatanController = TextEditingController();

  String kodeNegara = '+62';
  String? jenisKelamin;

  bool detailTambahanTerbuka = false;

  static const Color primary = Color(0xFF205681);
  static const Color border = Color(0xFFDDDDDD);

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
    final DateTime? tanggal = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
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
  }) {
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
      ),
    );
  }

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

    if (konfirmasi == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur hapus akun belum dihubungkan ke database'),
        ),
      );
    }
  }

  void simpanProfil() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                            // FOTO PROFIL
                            const Center(
                              child: CircleAvatar(
                                radius: 46,
                                backgroundColor: Color(0xFFB8E37E),
                                child: Text(
                                  'G',
                                  style: TextStyle(
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
                            inputField(controller: namaController),

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
                                            setState(() {
                                              kodeNegara = value;
                                            });
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
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            // EMAIL
                            label('Alamat Email'),
                            inputField(
                              controller: emailController,
                              enabled: false,
                              prefix: const Icon(
                                Icons.check_circle,
                                color: Color(0xFF62BD16),
                                size: 18,
                              ),
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
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: simpanProfil,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Ubah Profile',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

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
