import '../../domain/models/lyric.dart';
import 'database_helper.dart';

class LyricDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertLyric(LyricLine lyric) async {
    final db = await _dbHelper.database;
    await db.insert('lyrics', lyric.toMap());
  }

  Future<void> insertLyrics(List<LyricLine> lyrics) async {
    final db = await _dbHelper.database;
    final batch = db.batch();
    for (final lyric in lyrics) {
      batch.insert('lyrics', lyric.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<LyricLine>> getLyricsBySongId(String songId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'lyrics',
      where: 'song_id = ?',
      whereArgs: [songId],
      orderBy: 'line_number ASC',
    );
    return maps.map((map) => LyricLine.fromMap(map)).toList();
  }

  Future<void> deleteLyricsBySongId(String songId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'lyrics',
      where: 'song_id = ?',
      whereArgs: [songId],
    );
  }

  Future<void> updateLyric(LyricLine lyric) async {
    final db = await _dbHelper.database;
    await db.update(
      'lyrics',
      lyric.toMap(),
      where: 'id = ?',
      whereArgs: [lyric.id],
    );
  }
}
