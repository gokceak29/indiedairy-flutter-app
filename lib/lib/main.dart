import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'İndieDairy',
      debugShowCheckedModeBanner: false,
      // Koyu (Dark) Tema ve şık başlık ayarları
      theme: ThemeData(
        brightness: Brightness.dark, 
        scaffoldBackgroundColor: Colors.grey[900], // Koyu arka plan
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // AppBar'ı şeffaf yap
          elevation: 0,
          centerTitle: true, // Başlığı ortaya al
          // "İndieDairy" yazısının stili
          titleTextStyle: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold, // Kalın yazı 
            letterSpacing: 2.0, // Harf arası boşluk 
            color: Colors.tealAccent, // renk
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}   