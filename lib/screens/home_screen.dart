import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kas_provider.dart';
import '../widgets/kas_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'KasKita',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<KasProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Saldo',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rp ${provider.totalSaldo.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: provider.kasList.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada transaksi',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.kasList.length,
                        itemBuilder: (context, index) {
                          // Display in reverse order (newest first)
                          final kas = provider.kasList[provider.kasList.length - 1 - index];
                          return KasCard(kas: kas);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
