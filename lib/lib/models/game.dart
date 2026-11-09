class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String genre;
  final String platform;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.genre,
    required this.platform,
  });

  // İnternetten gelen JSON verisini Flutter nesnesine çeviren kısım
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'] ?? '',
      genre: json['genre'] ?? '',
      platform: json['platform'] ?? '',
    );
  }
} 