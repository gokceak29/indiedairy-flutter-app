import 'package:flutter/material.dart';
import '../models/game.dart';
import '../services/game_service.dart'; 
import 'detail_screen.dart'; 
import 'diary_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Game>> _games;

  @override
  void initState() {
    super.initState();
    // Uygulama açıldığında API'den oyunları çekme işlemini başlatıyoruz
    _games = GameService().fetchGames(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('İndieDairy'),
          // YENİ: AppBar'ın sağ tarafındaki şık buton tasarımı
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0), // Sağdan ve üstten boşluk
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.tealAccent.withOpacity(0.1), // Hafif neon arka plan efekti
                  borderRadius: BorderRadius.circular(12), // Köşeleri hafif yuvarlatılmış kare
                  border: Border.all(color: Colors.tealAccent, width: 1.5), // Parlak neon çerçeve
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_book, 
                    color: Colors.tealAccent, // İkonun kendi rengini de temanın rengi yaptık
                  ), 
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DiaryScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ), 
      // İnternetten gelen veriyi dinleyen FutureBuilder yapısı
      body: FutureBuilder<List<Game>>(
        future: _games,
        builder: (context, snapshot) {
          // Veri yüklenirken dönen çark göster
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // Hata olursa hatayı ekrana bas
          else if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          } 
          // Veri başarıyla geldiyse listeyi oluştur
          else if (snapshot.hasData) {
            final games = snapshot.data!;
            // YENİ: GridView yerine tam genişlikte kartlar için ListView.builder
            return ListView.builder(
              padding: const EdgeInsets.all(16), // Kenarlardan ferah bir boşluk
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0), // Kartlar arası dikey boşluk
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(game: game),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 4), // Gölgeyi hafifçe aşağı kaydır
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Kartın Üst Kısmı: Tam Boyutlu Oyun Kapak Resmi
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                            child: Hero(
                              tag: 'img_${game.id}',
                              child: Image.network(
                                game.thumbnail,
                                height: 200, // Resmi yatay formata uygun bir yükseklikte sabitliyoruz
                                fit: BoxFit.cover, // Boşluk kalmayacak şekilde sığdır
                              ),
                            ),
                          ),
                          // Kartın Alt Kısmı: Oyun Adı ve Türü
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  game.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 20, // Yazıyı biraz daha büyüttük
                                  ), 
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  game.genre,
                                  style: const TextStyle(
                                    color: Colors.grey, 
                                    fontSize: 15,
                                  ), 
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } 
          return Center(child: Text('Oyun bulunamadı.'));
        },
      ),
    );
  }
} 