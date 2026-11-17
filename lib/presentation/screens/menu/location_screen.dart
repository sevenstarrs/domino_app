import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Halaman "Lokasi / Toko Terdekat" (tampilan saja, tidak ada fungsi lokasi).
/// Hanya tombol kembali (panah) yang berfungsi.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, c) {
          final h = c.maxHeight;
          final mapH = h * 0.52;
          final sheetH = h * 0.50;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ================= PETA (gambar tiruan) =================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: mapH,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _FakeMapPainter()),
                    ),

                    // Lingkaran radius + pin
                    Center(
                      child: SizedBox(
                        width: 280,
                        height: 280,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0x331E88E5),
                                border: Border.all(
                                  color: const Color(0x331E88E5),
                                  width: 1,
                                ),
                              ),
                            ),
                            const Align(
                              alignment: Alignment(0, -0.14),
                              child: Icon(
                                Icons.location_on,
                                size: 34,
                                color: Color(0xFFE5304F),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(-0.02, 0.02),
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4285F4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tombol "lokasi saya" (tampilan saja)
                    Positioned(
                      left: 14,
                      bottom: 44,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),

                    // Tombol zoom + / - (tampilan saja)
                    Positioned(
                      right: 14,
                      bottom: 44,
                      child: Container(
                        width: 46,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 46,
                              child: Icon(Icons.add, color: Colors.black),
                            ),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFE5E5E5),
                            ),
                            SizedBox(
                              height: 46,
                              child: Icon(Icons.remove, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= BAR ATAS (back + lokasi) =================
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                  child: Row(
                    children: [
                      // Tombol kembali (BERFUNGSI)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Bar lokasi (tampilan saja)
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: Colors.black, size: 22),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lokasi',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF8A8A8A),
                                        height: 1.4,
                                      ),
                                    ),
                                    Text(
                                      'Tidak ada lokasi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromARGB(255, 68, 68, 68),
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black54, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),

              // ================= PANEL BAWAH "TOKO TERDEKAT" =================
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: sheetH,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(1),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 26, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toko Terdekat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 75,
                                  height: 75,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF2F2F2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on_outlined,
                                    size: 50,
                                    color: Color(0xFF5F5F5F),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                const Text(
                                  'Menemukan toko terdekat',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Kami sedang mencari toko di dekat lokasi\nAnda. Mohon tunggu!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 95, 95, 95),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                SizedBox(
                                  width: 200,
                                  height: 40,
                                  child: OutlinedButton(
                                    onPressed: () {}, // tidak berfungsi
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                        color: Color(0xFFD9D9D9),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Coba Lagi',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Gambar peta tiruan bergaya mode gelap (tanpa package Google Maps).
class _FakeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Latar
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF1A2A44),
    );

    // Blok bangunan acak (hasilnya selalu sama karena seed tetap)
    final rnd = math.Random(11);
    final blockPaint = Paint()..color = const Color(0xFF243756);
    const cell = 30.0;
    for (double y = 0; y < size.height; y += cell) {
      for (double x = 0; x < size.width; x += cell) {
        if (rnd.nextDouble() < 0.6) {
          final w = 12 + rnd.nextDouble() * 14;
          final h = 10 + rnd.nextDouble() * 14;
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x + 2, y + 2, w, h),
              const Radius.circular(2),
            ),
            blockPaint,
          );
        }
      }
    }

    // Jalan-jalan
    final thin = Paint()
      ..color = const Color(0xFF2E4466)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final main = Paint()
      ..color = const Color(0xFF3A5278)
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Gang kecil
    canvas.drawLine(Offset(w * 0.52, 0), Offset(w * 0.50, h), thin);
    canvas.drawLine(Offset(w * 0.30, h * 0.15), Offset(w * 0.34, h), thin);
    canvas.drawLine(Offset(w * 0.62, h * 0.20), Offset(w * 0.86, h * 0.20), thin);
    canvas.drawLine(Offset(w * 0.62, h * 0.37), Offset(w * 0.86, h * 0.35), thin);
    canvas.drawLine(Offset(w * 0.60, h * 0.78), Offset(w * 0.86, h * 0.76), thin);
    canvas.drawLine(Offset(0, h * 0.20), Offset(w * 0.30, h * 0.02), thin);
    canvas.drawLine(Offset(w * 0.10, h * 0.85), Offset(w * 0.30, h * 0.62), thin);

    // Jalan utama
    canvas.drawLine(Offset(0, h * 0.64), Offset(w * 0.86, h * 0.58), main);
    canvas.drawLine(Offset(w * 0.88, 0), Offset(w * 0.84, h), main);

    // Nama jalan
    _label(canvas, 'Gg. Bangau Jaya', Offset(w * 0.59, h * 0.12), -0.08);
    _label(canvas, 'Gg. Sejahtera', Offset(w * 0.62, h * 0.30), -0.1);
    _label(canvas, 'Jl. Kamboja', Offset(w * 0.26, h * 0.65), -0.2);
    _label(canvas, 'Gg. Kuantan', Offset(w * 0.60, h * 0.73), 0.05);
    _label(canvas, 'Gg. Arjuna', Offset(w * 0.62, h * 0.88), 0.08);
    _label(canvas, 'Jl. Bangau Sakti', Offset(w * 0.80, h * 0.97), -1.5);
  }

  void _label(Canvas canvas, String text, Offset pos, double angle) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Color(0xFFB9C6DC), fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}