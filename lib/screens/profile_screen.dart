import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/notification_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LanguageProvider, NotificationProvider>(
      builder: (context, lang, notify, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            title: Text(
              lang.getText('Profil Saya', 'My Profile'),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: const Color(0xFF1E293B),
            elevation: 0,
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header Profil
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
                              child: const Icon(Icons.edit, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        lang.getText('Pengguna KasKita', 'KasKita User'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'pengguna@kaskita.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Menu Pengaturan
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.getText('Pengaturan Akun', 'Account Settings'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileMenu(
                        icon: Icons.person_outline,
                        title: lang.getText('Informasi Pribadi', 'Personal Information'),
                        onTap: () {
                          Navigator.pushNamed(context, '/edit_profile');
                        },
                      ),
                      _buildProfileMenu(
                        icon: Icons.security_outlined,
                        title: lang.getText('Keamanan & Kata Sandi', 'Security & Password'),
                        onTap: () {
                          _showInfoDialog(
                            context,
                            lang.getText('Keamanan', 'Security'),
                            lang.getText(
                                'Fitur ubah kata sandi akan segera hadir di versi berikutnya.',
                                'Change password feature will be available in the next version.'),
                          );
                        },
                      ),
                      
                      // --- MENU NOTIFIKASI DENGAN SWITCH ---
                      _buildProfileMenu(
                        icon: Icons.notifications_none_outlined,
                        title: lang.getText('Notifikasi', 'Notifications'),
                        subtitle: notify.isEnabled 
                            ? lang.getText('Aktif', 'On') 
                            : lang.getText('Mati', 'Off'),
                        trailing: Switch(
                          value: notify.isEnabled,
                          activeColor: const Color(0xFF10B981),
                          onChanged: (value) {
                            notify.toggleNotification(value);
                            if (value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(lang.getText('Notifikasi diaktifkan', 'Notifications enabled')),
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          if (notify.isEnabled) {
                            _showNotificationSettings(context, lang, notify);
                          } else {
                            _showInfoDialog(context, lang.getText('Notifikasi', 'Notifications'), 
                              lang.getText('Silakan aktifkan saklar untuk mengatur notifikasi.', 'Please turn on the switch to configure notifications.'));
                          }
                        },
                      ),

                      _buildProfileMenu(
                        icon: Icons.language_outlined,
                        title: lang.getText('Bahasa', 'Language'),
                        subtitle: lang.isIndonesian ? 'Bahasa Indonesia' : 'English',
                        onTap: () {
                          _showLanguageDialog(context, lang);
                        },
                      ),

                      const SizedBox(height: 24),
                      Text(
                        lang.getText('Lainnya', 'Others'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileMenu(
                        icon: Icons.help_outline,
                        title: lang.getText('Bantuan & Dukungan', 'Help & Support'),
                        onTap: () {
                          _showInfoDialog(
                            context,
                            lang.getText('Bantuan', 'Help'),
                            lang.getText('Hubungi kami di support@kaskita.com jika Anda mengalami kendala.',
                                'Contact us at support@kaskita.com if you have any issues.'),
                          );
                        },
                      ),
                      _buildProfileMenu(
                        icon: Icons.info_outline,
                        title: lang.getText('Tentang KasKita', 'About KasKita'),
                        onTap: () {
                          _showInfoDialog(
                            context,
                            lang.getText('Tentang KasKita', 'About KasKita'),
                            lang.getText('KasKita v1.0.0\nAplikasi manajemen keuangan cerdas untuk Anda.',
                                'KasKita v1.0.0\nSmart financial management app for you.'),
                          );
                        },
                      ),
                      _buildProfileMenu(
                        icon: Icons.logout,
                        title: lang.getText('Keluar Akun', 'Logout'),
                        titleColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () {
                          _showLogoutDialog(context, lang);
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context, LanguageProvider lang, NotificationProvider notify) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(lang.getText('Pengaturan Notifikasi', 'Notification Settings')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: Text(lang.getText('Pengingat Harian', 'Daily Reminder')),
                subtitle: Text(lang.getText('Catat transaksi setiap malam', 'Record transactions every night')),
                value: notify.dailyReminder,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) {
                  notify.updateSettings(daily: val);
                  setDialogState(() {});
                },
              ),
              CheckboxListTile(
                title: Text(lang.getText('Laporan Mingguan', 'Weekly Report')),
                subtitle: Text(lang.getText('Ringkasan pengeluaran Anda', 'Your expense summary')),
                value: notify.weeklyReport,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) {
                  notify.updateSettings(weekly: val);
                  setDialogState(() {});
                },
              ),
              CheckboxListTile(
                title: Text(lang.getText('Peringatan Anggaran', 'Budget Alert')),
                subtitle: Text(lang.getText('Jika saldo menipis', 'If balance is low')),
                value: notify.budgetAlert,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) {
                  notify.updateSettings(budget: val);
                  setDialogState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.getText('Selesai', 'Done')),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(lang.getText('Pilih Bahasa', 'Select Language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bahasa Indonesia'),
              leading: Radio<bool>(
                value: true,
                groupValue: lang.isIndonesian,
                onChanged: (value) {
                  lang.setLanguage(true);
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                lang.setLanguage(true);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              leading: Radio<bool>(
                value: false,
                groupValue: lang.isIndonesian,
                onChanged: (value) {
                  lang.setLanguage(false);
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                lang.setLanguage(false);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(lang.getText('Keluar Akun?', 'Logout?')),
        content: Text(lang.getText('Apakah Anda yakin ingin keluar dari aplikasi KasKita?',
            'Are you sure you want to logout from KasKita?')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.getText('Batal', 'Cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text(lang.getText('Keluar', 'Logout'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor ?? const Color(0xFF1E293B)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: titleColor ?? const Color(0xFF1E293B),
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }
}
