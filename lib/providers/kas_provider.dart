import 'package:flutter/material.dart';
import '../models/kas_model.dart';

class KasProvider with ChangeNotifier {
  final List<KasModel> _kasList = [
    KasModel(
      id: '1',
      deskripsi: 'Gaji Bulanan',
      jumlah: 5000000,
      isPemasukan: true,
      tanggal: DateTime.now().subtract(const Duration(days: 2)),
    ),
    KasModel(
      id: '2',
      deskripsi: 'Beli Makan',
      jumlah: 50000,
      isPemasukan: false,
      tanggal: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<KasModel> get kasList => _kasList;

  double get totalSaldo {
    double total = 0;
    for (var kas in _kasList) {
      if (kas.isPemasukan) {
        total += kas.jumlah;
      } else {
        total -= kas.jumlah;
      }
    }
    return total;
  }

  void addKas(KasModel kas) {
    _kasList.add(kas);
    notifyListeners();
  }
}
