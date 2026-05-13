import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String _gender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Pengguna KasKita');
    _emailController = TextEditingController(text: 'pengguna@kaskita.com');
    _phoneController = TextEditingController(text: '081234567890');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save(LanguageProvider lang) {
    if (_formKey.currentState!.validate()) {
      // Simulasi simpan data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(lang.getText('Profil berhasil diperbarui', 'Profile updated successfully')),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
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
              lang.getText('Informasi Pribadi', 'Personal Information'),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1E293B),
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header dengan Foto Profil
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF10B981), width: 3),
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage('assets/icons/icon.png'),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        lang.getText('Ubah Foto Profil', 'Change Profile Photo'),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Form Input
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInputField(
                          label: lang.getText('Nama Lengkap', 'Full Name'),
                          controller: _nameController,
                          icon: Icons.person_outlined,
                          lang: lang,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: lang.getText('Email', 'Email'),
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          lang: lang,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          label: lang.getText('Nomor Telepon', 'Phone Number'),
                          controller: _phoneController,
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          lang: lang,
                        ),
                        const SizedBox(height: 20),
                        
                        // Dropdown Jenis Kelamin
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: InputDecoration(
                            labelText: lang.getText('Jenis Kelamin', 'Gender'),
                            prefixIcon: const Icon(Icons.wc_outlined, color: Color(0xFF64748B)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                          items: [
                            DropdownMenuItem(value: 'Laki-laki', child: Text(lang.getText('Laki-laki', 'Male'))),
                            DropdownMenuItem(value: 'Perempuan', child: Text(lang.getText('Perempuan', 'Female'))),
                          ].toList(),
                          onChanged: (val) => setState(() => _gender = val!),
                        ),

                        const SizedBox(height: 40),

                        // Tombol Simpan
                        ElevatedButton(
                          onPressed: () => _save(lang),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 4,
                          ),
                          child: Text(
                            lang.getText('Simpan Perubahan', 'Save Changes'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required LanguageProvider lang,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (val) => val == null || val.isEmpty 
          ? lang.getText('Kolom ini wajib diisi', 'This field is required') 
          : null,
    );
  }
}
