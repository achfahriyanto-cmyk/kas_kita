import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan kata sandi tidak boleh kosong!';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi delay jaringan (API Request)
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Mengambil data user yang terdaftar di SharedPreferences (Simulasi Database)
      final String? userData = prefs.getString('registered_user');
      
      if (userData != null) {
        final Map<String, dynamic> user = json.decode(userData);
        if (user['email'] == email && user['password'] == password) {
          await prefs.setBool('isLoggedIn', true);
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _errorMessage = 'Email atau kata sandi salah!';
        }
      } else {
        // Jika belum ada user terdaftar, izinkan login default (admin/admin)
        if (email == 'admin' && password == 'admin') {
          await prefs.setBool('isLoggedIn', true);
          _isAuthenticated = true;
          _isLoading = false;
          notifyListeners();
          return true;
        }
        _errorMessage = 'Akun tidak ditemukan. Silakan daftar.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan sistem.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Email dan kata sandi tidak boleh kosong!';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 2));

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Simulasi register: simpan data di SharedPreferences
      final userData = json.encode({
        'email': email,
        'password': password,
      });
      await prefs.setString('registered_user', userData);
      
      // Otomatis login setelah daftar
      await prefs.setBool('isLoggedIn', true);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isAuthenticated = false;
    notifyListeners();
  }
}
