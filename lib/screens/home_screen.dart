import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi helper untuk format angka menjadi Rupiah (tanpa package tambahan)
  String _formatCurrency(double amount) {
    String amountStr = amount.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      result = amountStr[i] + result;
      count++;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }

  // Fungsi helper untuk format tanggal sederhana
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Background lebih bersih
      appBar: AppBar(
        title: const Text(
          'KasKita',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B), // Warna biru modern
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. CARD SALDO UTAMA ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Saldo',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatCurrency(provider.totalBalance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // --- 2. CARD INCOME & EXPENSE ---
              Transform.translate(
                offset: const Offset(0, -25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Pemasukan',
                          amount: provider.totalIncome,
                          color: const Color(0xFF10B981),
                          icon: Icons.arrow_downward,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          title: 'Pengeluaran',
                          amount: provider.totalExpense,
                          color: const Color(0xFFE11D48),
                          icon: Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- 3. JUDUL LIST TRANSAKSI TERBARU ---
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Transaksi Terbaru',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              // --- 4. LIST TRANSAKSI ---
              Expanded(
                child: provider.transactions.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada transaksi',
                          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        itemCount: provider.transactions.length,
                        itemBuilder: (context, index) {
                          final tx = provider.transactions[index];
                          final isIncome = tx.type == 'income';

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFFE4E6),
                                child: Icon(
                                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                                  color: isIncome ? const Color(0xFF10B981) : const Color(0xFFE11D48),
                                ),
                              ),
                              title: Text(
                                tx.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _formatDate(tx.date),
                                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                ),
                              ),
                              trailing: Text(
                                '${isIncome ? '+' : '-'} ${_formatCurrency(tx.amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isIncome ? const Color(0xFF10B981) : const Color(0xFFE11D48),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Route '/add' bisa Anda sesuaikan jika belum ada
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color(0xFF1E293B),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget helper untuk merender Card Income & Expense
  Widget _buildInfoCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _formatCurrency(amount),
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
