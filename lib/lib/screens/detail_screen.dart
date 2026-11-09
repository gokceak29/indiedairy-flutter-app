import 'package:flutter/material.dart';
import '../models/game.dart';
import '../database/database_helper.dart'; // Veritabanı bağlantımızı ekledik

class DetailScreen extends StatefulWidget {
  final Game game;
  const DetailScreen({super.key, required this.game});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Kullanıcının yazacağı metni kontrol etmek için bir Controller oluşturuyoruz
  final TextEditingController _noteController = TextEditingController();

  // Veritabanına kaydetme fonksiyonu (CREATE İşlemi)
  void _saveToDiary() async {
    // Kaydedilecek veriyi bir Map (sözlük) formatında hazırlıyoruz
    Map<String, dynamic> gameData = {
      'gameId': widget.game.id,
      'title': widget.game.title,
      'thumbnail': widget.game.thumbnail,
      'devNote': _noteController.text, // Metin kutusundan gelen not
    };

    // DatabaseHelper üzerinden veritabanına ekliyoruz
    await DatabaseHelper.instance.insertFavorite(gameData);

    // Hocanın gereksinim listesindeki SnackBar (Bilgilendirme Mesajı) kullanımı
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Günlüğe başarıyla kaydedildi!'),
          backgroundColor: Colors.teal,
        ),
      );
      _noteController.clear(); // Kaydettikten sonra kutuyu temizle
    }
  }

  // Sayfa kapatıldığında Controller'ı hafızadan siliyoruz (Performans için önemli)
  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.game.title)),
      // Klavye açıldığında ekrana sığmama hatası (Overflow) almamak için sayfayı kaydırılabilir yapıyoruz
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'img_${widget.game.id}',
              child: Image.network(
                widget.game.thumbnail,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.game.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.game.platform,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // YENİ: Geliştirici Notu Ekleme Alanı
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _noteController,
                maxLines: 3, // Kutu yüksekliği
                decoration: InputDecoration(
                  hintText: 'Oyunla ilgili geliştirici notunu buraya yaz...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // YENİ: Kaydet Butonu
            ElevatedButton.icon(
              onPressed: _saveToDiary,
              icon: const Icon(Icons.save),
              label: const Text('Günlüğe Kaydet'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
} 