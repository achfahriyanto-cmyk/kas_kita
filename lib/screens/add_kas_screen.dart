import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/kas_model.dart';
import '../providers/kas_provider.dart';

class AddKasScreen extends StatefulWidget {
  const AddKasScreen({super.key});

  @override
  State<AddKasScreen> createState() => _AddKasScreenState();
}

class _AddKasScreenState extends State<AddKasScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deskripsiController = TextEditingController();
  final _jumlahController = TextEditingController();
  bool _isPemasukan = true;

  @override
  void dispose() {
    _deskripsiController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final kas = KasModel(
        id: DateTime.now().toString(),
        deskripsi: _deskripsiController.text,
        jumlah: double.parse(_jumlahController.text),
        isPemasukan: _isPemasukan,
        tanggal: DateTime.now(),
      );

      Provider.of<KasProvider>(context, listen: false).addKas(kas);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('Pemasukan'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('Pengeluaran'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_isPemasukan},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isPemasukan = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Jumlah tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
