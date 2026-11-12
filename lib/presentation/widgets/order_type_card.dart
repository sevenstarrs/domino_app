import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Kartu "Hai Domino's lovers!" dengan toggle Delivery / Takeaway
class OrderTypeCard extends StatefulWidget {
  const OrderTypeCard({super.key});

  @override
  State<OrderTypeCard> createState() => _OrderTypeCardState();
}

class _OrderTypeCardState extends State<OrderTypeCard> {
  bool _takeaway = true;

  Widget _toggle(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 17,
              color: selected ? Colors.white : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hai Domino's lovers!",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              _toggle('Delivery', !_takeaway, () => setState(() => _takeaway = false)),
              const SizedBox(width: 12),
              _toggle('Takeaway', _takeaway, () => setState(() => _takeaway = true)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Domino's Pizza - Soebrantas Pekanbaru",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Jl. HR. Soebrantas, Simpang Baru Kec. Tampan, Kota Pekanbaru, Riau ...',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.location_on_outlined, color: AppColors.textGrey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
