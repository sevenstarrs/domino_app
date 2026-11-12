import 'package:flutter/material.dart';

const _namaBulan = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Dialog pilih tanggal model roda (hari | bulan | tahun), seperti di app asli.
/// Mengembalikan null kalau ditekan Cancel.
Future<DateTime?> showWheelDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  String title = 'Select date',
}) {
  return showDialog<DateTime>(
    context: context,
    builder: (_) => _WheelDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
    ),
  );
}

class _WheelDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;

  const _WheelDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.title,
  });

  @override
  State<_WheelDatePickerDialog> createState() => _WheelDatePickerDialogState();
}

class _WheelDatePickerDialogState extends State<_WheelDatePickerDialog> {
  static const double _tinggiItem = 44;

  late int _day;
  late int _month;
  late int _year;
  late final int _tahunAwal;
  late final int _tahunAkhir;

  late final FixedExtentScrollController _dayC;
  late final FixedExtentScrollController _monthC;
  late final FixedExtentScrollController _yearC;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Paksa tanggal berada di antara firstDate dan lastDate.
  DateTime _kunci(DateTime d) {
    final awal = _dateOnly(widget.firstDate);
    final akhir = _dateOnly(widget.lastDate);
    if (d.isBefore(awal)) return awal;
    if (d.isAfter(akhir)) return akhir;
    return d;
  }

  @override
  void initState() {
    super.initState();
    _tahunAwal = widget.firstDate.year;
    _tahunAkhir = widget.lastDate.year;
    final awal = _kunci(_dateOnly(widget.initialDate));
    _day = awal.day;
    _month = awal.month;
    _year = awal.year;
    _dayC = FixedExtentScrollController(initialItem: _day - 1);
    _monthC = FixedExtentScrollController(initialItem: _month - 1);
    _yearC = FixedExtentScrollController(initialItem: _year - _tahunAwal);
  }

  @override
  void dispose() {
    _dayC.dispose();
    _monthC.dispose();
    _yearC.dispose();
    super.dispose();
  }

  /// Dipanggil tiap roda berubah: rapikan hari (mis. 31 Feb -> 28/29 Feb)
  /// dan batas tanggal, lalu geser roda ke nilai yang sudah dikoreksi.
  void _koreksi() {
    final maxHari = DateTime(_year, _month + 1, 0).day;
    final hari = _day > maxHari ? maxHari : _day;
    final tgl = _kunci(DateTime(_year, _month, hari));

    final berubah =
        tgl.day != _day || tgl.month != _month || tgl.year != _year;
    _day = tgl.day;
    _month = tgl.month;
    _year = tgl.year;
    setState(() {});

    if (berubah) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_dayC.selectedItem != _day - 1) _dayC.jumpToItem(_day - 1);
        if (_monthC.selectedItem != _month - 1) _monthC.jumpToItem(_month - 1);
        if (_yearC.selectedItem != _year - _tahunAwal) {
          _yearC.jumpToItem(_year - _tahunAwal);
        }
      });
    }
  }

  Widget _roda({
    required FixedExtentScrollController controller,
    required int jumlah,
    required int terpilih,
    required String Function(int) teks,
    required ValueChanged<int> onChanged,
  }) {
    return SizedBox(
      height: _tinggiItem * 3,
      child: Stack(
        children: [
          ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: _tinggiItem,
            diameterRatio: 100, // hampir datar, seperti di app asli
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: jumlah,
              builder: (context, i) {
                final dipilih = i == terpilih;
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      teks(i),
                      style: TextStyle(
                        fontSize: 22,
                        color: dipilih ? Colors.black : Colors.black45,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Dua garis di atas & bawah item terpilih
          IgnorePointer(
            child: Center(
              child: Container(
                height: _tinggiItem,
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jumlahTahun = _tahunAkhir - _tahunAwal + 1;

    return Dialog(
      backgroundColor: const Color(0xFFF1F0F6),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            // Lebar roda dibagi dengan flex, bukan angka piksel
            Row(
              children: [
                const Spacer(flex: 1),
                Expanded(
                  flex: 3,
                  child: _roda(
                    controller: _dayC,
                    jumlah: 31,
                    terpilih: _day - 1,
                    teks: (i) => '${i + 1}',
                    onChanged: (i) {
                      _day = i + 1;
                      _koreksi();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: _roda(
                    controller: _monthC,
                    jumlah: 12,
                    terpilih: _month - 1,
                    teks: (i) => _namaBulan[i],
                    onChanged: (i) {
                      _month = i + 1;
                      _koreksi();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 4,
                  child: _roda(
                    controller: _yearC,
                    jumlah: jumlahTahun,
                    terpilih: _year - _tahunAwal,
                    teks: (i) => '${_tahunAwal + i}',
                    onChanged: (i) {
                      _year = _tahunAwal + i;
                      _koreksi();
                    },
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context, DateTime(_year, _month, _day)),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}