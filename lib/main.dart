import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/kas_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_kas_screen.dart';

void main() {
  runApp(const KasKitaApp());
}

class KasKitaApp extends StatelessWidget {
  const KasKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KasProvider()),
      ],
      child: MaterialApp(
        title: 'KasKita',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green,
            secondary: Colors.blue,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/add': (context) => const AddKasScreen(),
        },
      ),
    );
  }
}
