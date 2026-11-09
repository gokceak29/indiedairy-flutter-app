import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern (tek instance) [cite: 4184]
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  // Veritabanını al (yoksa oluştur) [cite: 4187]
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Veritabanını oluştur [cite: 4194]
  Future<Database> _initDatabase() async {
    // Veritabanı dosyasının yolu [cite: 4196]
    String path = join(await getDatabasesPath(), 'indiedairy.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        // Tablo oluştur: id, oyun id'si, oyun adı, resmi ve geliştirici notu [cite: 4203]
        return db.execute(
          "CREATE TABLE favorites (id INTEGER PRIMARY KEY AUTOINCREMENT, gameId INTEGER, title TEXT, thumbnail TEXT, devNote TEXT)"
        );
      },
    );
  }

  // CREATE: İlham panosuna yeni oyun ve not ekle [cite: 4210, 4211]
  Future<int> insertFavorite(Map<String, dynamic> gameData) async {
    final db = await database;
    return await db.insert("favorites", gameData);
  }

  // READ: Kaydedilen tüm oyunları ve notları getir [cite: 4215, 4216]
  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query("favorites");
  }

  // DELETE: Panodan oyunu sil [cite: 4220, 4221]
  Future<int> deleteFavorite(int id) async {
    final db = await database;
    // Güvenlik için '?' placeholder kullanımı 
    return await db.delete("favorites", where: "id = ?", whereArgs: [id]);
  }
} 