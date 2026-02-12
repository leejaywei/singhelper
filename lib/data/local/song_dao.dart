import '../../domain/models/song.dart';
import 'database_helper.dart';

class SongDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertSong(Song song) async {
    final db = await _dbHelper.database;
    await db.insert('songs', song.toMap());
  }

  Future<Song?> getSong(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Song.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Song>> getAllSongs() async {
    final db = await _dbHelper.database;
    final maps = await db.query('songs', orderBy: 'created_at DESC');
    return maps.map((map) => Song.fromMap(map)).toList();
  }

  Future<void> updateSong(Song song) async {
    final db = await _dbHelper.database;
    await db.update(
      'songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<void> deleteSong(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
