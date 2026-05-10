import 'package:flutter/material.dart';
import '../models/kas_model.dart';

class KasCard extends StatelessWidget {
  final KasModel kas;

  const KasCard({super.key, required this.kas});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: kas.isPemasukan 
              ? const Color(0xFF10B981).withValues(alpha: 0.1) 
              : const Color(0xFFE11D48).withValues(alpha: 0.1),
          child: Icon(
            kas.isPemasukan ? Icons.arrow_downward : Icons.arrow_upward,
            color: kas.isPemasukan ? const Color(0xFF10B981) : const Color(0xFFE11D48),
          ),
        ),
        title: Text(
          kas.deskripsi,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${kas.tanggal.day}/${kas.tanggal.month}/${kas.tanggal.year}',
        ),
        trailing: Text(
          '${kas.isPemasukan ? '+' : '-'} Rp ${kas.jumlah.toStringAsFixed(0)}',
          style: TextStyle(
            color: kas.isPemasukan ? const Color(0xFF10B981) : const Color(0xFFE11D48),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
