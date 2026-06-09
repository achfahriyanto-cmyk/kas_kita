import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/language_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  
  String _selectedType = 'expense';
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E293B),
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

  void _executeSave(TransactionModel newTransaction, LanguageProvider lang) {
    Provider.of<TransactionProvider>(context, listen: false).addTransaction(newTransaction);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang.getText('Transaksi berhasil ditambahkan!', 'Transaction added successfully!')),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  void _showBalanceWarningDialog(TransactionModel newTransaction, double currentBalance, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE11D48),
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  lang.getText('Saldo Tidak Cukup', 'Insufficient Balance'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lang.getText(
                  'Saldo Anda saat ini tidak mencukupi untuk melakukan pengeluaran ini.',
                  'Your current balance is not enough to make this expense.'
                ),
                style: const TextStyle(color: Color(0xFF475569)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.getText('Saldo Saat Ini:', 'Current Balance:'),
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                        Text(
                          _formatCurrency(currentBalance),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          lang.getText('Nominal Pengeluaran:', 'Expense Amount:'),
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                        Text(
                          _formatCurrency(newTransaction.amount),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE11D48)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lang.getText(
                  'Apakah Anda yakin tetap ingin menyimpan transaksi ini?',
                  'Are you sure you want to save this transaction anyway?'
                ),
                style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lang.getText('Batal', 'Cancel'),
                style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _executeSave(newTransaction, lang);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: Text(
                lang.getText('Tetap Simpan', 'Save Anyway'),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveTransaction(LanguageProvider lang) {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang.getText('Nominal harus lebih besar dari 0', 'Amount must be greater than 0')),
            backgroundColor: const Color(0xFFE11D48),
          ),
        );
        return;
      }

      final newTransaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: amount,
        type: _selectedType,
        date: _selectedDate,
        category: _categoryController.text.trim(),
      );

      final txProvider = Provider.of<TransactionProvider>(context, listen: false);

      if (_selectedType == 'expense' && txProvider.totalBalance < amount) {
        _showBalanceWarningDialog(newTransaction, txProvider.totalBalance, lang);
      } else {
        _executeSave(newTransaction, lang);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, lang, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: Text(
              lang.getText('Tambah Transaksi', 'Add Transaction'), 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
            backgroundColor: const Color(0xFF1E293B),
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                              TextFormField(
                                controller: _titleController,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  labelText: lang.getText('Judul Transaksi', 'Transaction Title'),
                                  prefixIcon: const Icon(Icons.title, color: Color(0xFF64748B)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => (value == null || value.trim().isEmpty) 
                                    ? lang.getText('Judul tidak boleh kosong', 'Title cannot be empty') 
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: lang.getText('Nominal (Rp)', 'Amount (Rp)'),
                                  prefixIcon: const Icon(Icons.attach_money, color: Color(0xFF64748B)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) return lang.getText('Nominal tidak boleh kosong', 'Amount cannot be empty');
                                  if (double.tryParse(value) == null) return lang.getText('Masukkan angka yang valid', 'Enter a valid number');
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedType,
                                decoration: InputDecoration(
                                  labelText: lang.getText('Jenis Transaksi', 'Transaction Type'),
                                  prefixIcon: Icon(
                                    _selectedType == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                                    color: _selectedType == 'income' ? const Color(0xFF10B981) : const Color(0xFFE11D48),
                                  ),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: 'expense', 
                                    child: Text(lang.getText('Pengeluaran', 'Expense'), style: const TextStyle(color: Color(0xFFE11D48))),
                                  ),
                                  DropdownMenuItem(
                                    value: 'income', 
                                    child: Text(lang.getText('Pemasukan', 'Income'), style: const TextStyle(color: Color(0xFF10B981))),
                                  ),
                                ],
                                onChanged: (value) => setState(() => _selectedType = value!),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _categoryController,
                                textCapitalization: TextCapitalization.sentences,
                                decoration: InputDecoration(
                                  labelText: lang.getText('Kategori (contoh: Makan, Gaji)', 'Category (e.g., Food, Salary)'),
                                  prefixIcon: const Icon(Icons.category, color: Color(0xFF64748B)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                validator: (value) => (value == null || value.trim().isEmpty) 
                                    ? lang.getText('Kategori tidak boleh kosong', 'Category cannot be empty') 
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: _pickDate,
                                borderRadius: BorderRadius.circular(12),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: lang.getText('Tanggal Transaksi', 'Transaction Date'),
                                    prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF64748B)),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(_formatDate(_selectedDate), style: const TextStyle(fontSize: 16)),
                                ),
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                onPressed: () => _saveTransaction(lang),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1E293B),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  lang.getText('Simpan Transaksi', 'Save Transaction'),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
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
      },
    );
  }
}
