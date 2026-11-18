import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _tab = 0;
  int _filter = 0;

  final _filters = const [
    'Semua',
    'Sedang berlangsung',
    'Selesai',
    'Dijadwalkan',
    'Tertunda',
    'Dibatalkan'
  ];

  // Data pesanan contoh
  final List<Map<String, dynamic>> _orders = [
    {
      'number': '1774513631',
      'restaurant': "Dominos Pizza - Majalengka",
      'menu': '1x Papi Mini',
      'price': 'Rp 72.000',
      'status': 'Takeaway',
      'date': '',
      'time': '',
      'type': 'ongoing',
      'step': 0,
    },
    {
      'number': '1774517469',
      'restaurant': "Dominos Pizza - Majalengka",
      'menu': '1x Papi Mini',
      'price': 'Rp 72.000',
      'status': 'Completed',
      'date': '16-09-2026',
      'time': '11:05',
      'type': 'completed',
      'step': 3,
    },
    {
      'number': '1774373779',
      'restaurant': "Dominos Pizza - Majalengka",
      'menu': '1x Papi Mini',
      'price': 'Rp 72.000',
      'status': 'Completed',
      'date': '27-08-2026',
      'time': '13:35',
      'type': 'completed',
      'step': 3,
    },
  ];

  Widget _segment() {
    Widget item(String label, int index) {
      final sel = _tab == index;

      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: sel ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: sel ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 8)
        ],
      ),
      child: Row(
        children: [
          item('Memesan', 0),
          item('Pemberitahuan', 1),
        ],
      ),
    );
  }

  Widget _filterChips() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final sel = i == _filter;

          return GestureDetector(
            onTap: () => setState(() => _filter = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? AppColors.primary : AppColors.chipBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _filters[i],
                style: TextStyle(
                  fontSize: 16,
                  color: sel ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Menampilkan pesanan sesuai filter
  List<Map<String, dynamic>> get _filteredOrders {
  if (_filter == 0) {
    return _orders;
  } else if (_filter == 1) {
    return _orders.where((order) => order['type'] == 'ongoing').toList();
  } else if (_filter == 2) {
    return _orders.where((order) => order['type'] == 'completed').toList();
  } else if (_filter == 3) {
    return _orders.where((order) => order['type'] == 'scheduled').toList();
  } else if (_filter == 4) {
    return _orders.where((order) => order['type'] == 'pending').toList();
  } else if (_filter == 5) {
    return _orders.where((order) => order['type'] == 'cancelled').toList();
  }

  return [];
}

  // Kartu pesanan
  Widget _orderCard(Map<String, dynamic> order) {
    final bool completed = order['type'] == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nomor pesanan
          Row(
            children: [
              const Text(
                'Order Number',
                style: TextStyle(fontSize: 14),
              ),
              const Spacer(),
              Text(
                order['number'],
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: order['number']),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nomor pesanan berhasil disalin'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_outlined, size: 22),
                padding: const EdgeInsets.only(left: 8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const Divider(height: 20),

          // Nama restoran dan status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order['restaurant'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _statusBadge(order),
            ],
          ),

          const SizedBox(height: 12),

          // Menu dan tanggal
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  order['menu'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (completed)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order['date'],
                      style: const TextStyle(fontSize: 13),
                    ),
                    Text(
                      order['time'],
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                )
              else
                const Text(
                  '00 mins',
                  style: TextStyle(fontSize: 13),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // Harga
          Row(
            children: [
              Text(
                order['price'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 24,
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(),

          // Progress atau rating
          if (!completed)
            _orderProgress(order['step'])
          else
            _ratingSection(),
        ],
      ),
    );
  }

  // Label status pesanan
  Widget _statusBadge(Map<String, dynamic> order) {
    final bool completed = order['type'] == 'completed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFE8F5D9)
            : const Color(0xFFE5F0FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            completed ? Icons.verified_outlined : Icons.storefront,
            size: 17,
            color: completed
                ? Colors.green
                : AppColors.primary,
          ),
          const SizedBox(width: 5),
          Text(
            order['status'],
            style: TextStyle(
              fontSize: 13,
              color: completed
                  ? Colors.green.shade700
                  : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // Progress pesanan
  Widget _orderProgress(int activeStep) {
    final steps = [
      'Pesanan\nditerima',
      'Pesanan sedang\ndipanggang',
      'Pesanan sedang\ndikemas',
      'Pesanan sudah\ndiambil',
    ];

    return Column(
      children: [
        Row(
          children: List.generate(7, (index) {
            if (index.isEven) {
              final step = index ~/ 2;
              final active = step <= activeStep;

              return Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? const Color(0xFFD66C82)
                      : Colors.white,
                  border: Border.all(
                    color: active
                        ? const Color(0xFFD66C82)
                        : Colors.grey.shade300,
                    width: 4,
                  ),
                ),
              );
            }

            final lineStep = index ~/ 2;

            return Expanded(
              child: Container(
                height: 5,
                color: lineStep < activeStep
                    ? const Color(0xFFD66C82)
                    : Colors.grey.shade300,
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: steps.asMap().entries.map((entry) {
            final active = entry.key <= activeStep;

            return Expanded(
              child: Text(
                entry.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: active
                      ? Colors.black87
                      : Colors.grey.shade300,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Penilaian pesanan selesai
  Widget _ratingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Bagaimana pengalaman Anda?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...List.generate(
            5,
            (index) => const Padding(
              padding: EdgeInsets.symmetric(horizontal: 3),
              child: Icon(
                Icons.star,
                color: Color(0xFFE5E5E5),
                size: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Daftar semua pesanan
  Widget _orderList() {
    final orders = _filteredOrders;

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada pesanan',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _orderCard(orders[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Aktivitas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            _segment(),

            if (_tab == 0) _filterChips(),

            Expanded(
              child: _tab == 0
                  ? _orderList()
                  : const Center(
                      child: Text(
                        'No Notification Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
