import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Global key untuk validasi form
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk input text
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  // State untuk dropdown dan date picker
  String _selectedType = 'expense'; // Default pengeluaran
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // Helper format tanggal untuk ditampilkan di UI
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Fungsi memunculkan kalender (Date Picker)
  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        // Kustomisasi warna kalender
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E293B), // Warna header kalender
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  // Fungsi menyimpan transaksi
  void _saveTransaction() {
    // Jalankan validasi
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
      final category = _categoryController.text.trim();

      // Validasi tambahan untuk nominal
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nominal harus lebih besar dari 0'),
            backgroundColor: Color(0xFFE11D48),
          ),
        );
        return;
      }

      // Buat object model
      final newTransaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID unique dengan timestamp
        title: title,
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        category: category,
      );

      // Simpan ke provider
      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTransaction);

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaksi berhasil ditambahkan!'),
          backgroundColor: Color(0xFF10B981),
          duration: Duration(seconds: 2),
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF1E293B),
        iconTheme: const IconThemeData(color: Colors.white), // Tombol back warna putih
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dekorasi biru di belakang Card form
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
            
            // Form Card (Ditarik ke atas agar overlap dengan biru)
            Transform.translate(
              offset: const Offset(0, -30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Card(
                  elevation: 6,
                  shadowColor: const Color(0xFF1E293B).withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // --- INPUT JUDUL ---
                          TextFormField(
                            controller: _titleController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Judul Transaksi',
                              prefixIcon: const Icon(Icons.title, color: Color(0xFF64748B)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1E293B), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Judul tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- INPUT NOMINAL ---
                          TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Nominal (Rp)',
                              prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF64748B)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1E293B), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nominal tidak boleh kosong';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Masukkan angka yang valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- DROPDOWN TIPE (INCOME / EXPENSE) ---
                          DropdownButtonFormField<String>(
                            value: _selectedType,
                            decoration: InputDecoration(
                              labelText: 'Jenis Transaksi',
                              prefixIcon: Icon(
                                _selectedType == 'income' 
                                    ? Icons.arrow_downward 
                                    : Icons.arrow_upward,
                                color: _selectedType == 'income' 
                                    ? const Color(0xFF10B981) 
                                    : const Color(0xFFE11D48),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1E293B), width: 2),
                              ),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'expense', 
                                child: Text('Pengeluaran', style: TextStyle(color: Color(0xFFE11D48))),
                              ),
                              DropdownMenuItem(
                                value: 'income', 
                                child: Text('Pemasukan', style: TextStyle(color: Color(0xFF10B981))),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectedType = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- INPUT KATEGORI ---
                          TextFormField(
                            controller: _categoryController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: 'Kategori (contoh: Makan, Gaji)',
                              prefixIcon: const Icon(Icons.category, color: Color(0xFF64748B)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1E293B), width: 2),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Kategori tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // --- INPUT TANGGAL (DATE PICKER) ---
                          InkWell(
                            onTap: _pickDate,
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Tanggal Transaksi',
                                prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF64748B)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _formatDate(_selectedDate),
                                style: const TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // --- TOMBOL SIMPAN ---
                          ElevatedButton(
                            onPressed: _saveTransaction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E293B),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Simpan Transaksi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
