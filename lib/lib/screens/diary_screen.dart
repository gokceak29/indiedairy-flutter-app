import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  // Veritabanından gelecek verileri tutacak değişken
  late Future<List<Map<String, dynamic>>> _diaryNotes;

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Sayfa açıldığında notları yükle
  }

  // Veritabanındaki verileri çeken (READ) fonksiyon
  void _loadNotes() {
    setState(() {
      _diaryNotes = DatabaseHelper.instance.getFavorites();
    });
  }

  // Not silen (DELETE) fonksiyon
  void _deleteNote(int id) async {
    await DatabaseHelper.instance.deleteFavorite(id);
    _loadNotes(); // Sildikten sonra ekranı güncelle
    
    // Silindiğine dair bildirim mesajı (SnackBar)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not başarıyla silindi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geliştirici Günlüğüm'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _diaryNotes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Henüz hiç not eklemedin.\nOyunları keşfedip not almaya başla!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final notes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                color: Colors.grey[850],
                margin: const EdgeInsets.symmetric(vertical: 8),
                // ListTile, sol-orta-sağ şeklinde şık bir satır düzeni sağlar
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(note['thumbnail'], width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  title: Text(note['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    note['devNote'], 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Sağ taraftaki silme butonu
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteNote(note['id']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 