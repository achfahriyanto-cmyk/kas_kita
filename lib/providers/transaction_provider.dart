import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  // List private untuk menyimpan data transaksi
  final List<TransactionModel> _transactions = [];

  // Getter untuk mengambil semua transaksi
  // Kita kembalikan copy dari list agar tidak bisa dimodifikasi langsung dari luar
  List<TransactionModel> get transactions => [..._transactions];

  // Getter untuk menghitung total pemasukan (income)
  double get totalIncome {
    return _transactions
        .where((tx) => tx.type == 'income')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Getter untuk menghitung total pengeluaran (expense)
  double get totalExpense {
    return _transactions
        .where((tx) => tx.type == 'expense')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Getter untuk menghitung total saldo akhir
  double get totalBalance {
    return totalIncome - totalExpense;
  }

  // Fungsi untuk menambah transaksi baru
  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
    
    // Sortir agar transaksi yang lebih baru berada di atas (opsional tapi disarankan)
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    
    // Memberitahu UI (widget yang listen) untuk build ulang
    notifyListeners();
  }

  // Fungsi untuk menghapus transaksi berdasarkan ID
  void deleteTransaction(String id) {
    // Menyimpan index untuk memastikan data benar-benar ada sebelum dihapus
    final index = _transactions.indexWhere((tx) => tx.id == id);
    if (index != -1) {
      _transactions.removeAt(index);
      notifyListeners();
    }
  }

  // Fungsi opsional untuk mengisi data awal / reset data
  void setTransactions(List<TransactionModel> newTransactions) {
    _transactions.clear();
    _transactions.addAll(newTransactions);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }
}
