import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';

class GameService {
  // FreeToGame API'sinin ücretsiz oyunlar listesi URL'si
  static const _url = 'https://www.freetogame.com/api/games';

  Future<List<Game>> fetchGames() async {
    // API'ye GET isteği atıyoruz
    final response = await http.get(Uri.parse(_url));

    // Eğer istek başarılıysa (200 OK kodu dönerse) verileri çeviriyoruz
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Game.fromJson(e)).toList();
    } else {
      // Hata olursa fırlatıyoruz
      throw Exception('Oyunlar yüklenirken bir hata oluştu: ${response.statusCode}');
    }
  }
} 