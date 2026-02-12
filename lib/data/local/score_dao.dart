import '../../domain/models/score.dart';
import 'database_helper.dart';

class ScoreDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<void> insertScore(PracticeScore score) async {
    final db = await _dbHelper.database;
    await db.insert('scores', score.toMap());
    
    // Insert line scores
    if (score.lineScores.isNotEmpty) {
      final batch = db.batch();
      for (final lineScore in score.lineScores) {
        batch.insert('line_scores', lineScore.toMap());
      }
      await batch.commit(noResult: true);
    }
  }

  Future<PracticeScore?> getScore(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'scores',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    final score = PracticeScore.fromMap(maps.first);
    
    // Get line scores
    final lineScoreMaps = await db.query(
      'line_scores',
      where: 'score_id = ?',
      whereArgs: [id],
      orderBy: 'line_number ASC',
    );
    
    final lineScores = lineScoreMaps.map((map) => LineScore.fromMap(map)).toList();
    
    return PracticeScore(
      id: score.id,
      songId: score.songId,
      createdAt: score.createdAt,
      totalScore: score.totalScore,
      pitchScore: score.pitchScore,
      rhythmScore: score.rhythmScore,
      highNoteScore: score.highNoteScore,
      stabilityScore: score.stabilityScore,
      recordingFilePath: score.recordingFilePath,
      lineScores: lineScores,
    );
  }

  Future<List<PracticeScore>> getScoresBySongId(String songId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'scores',
      where: 'song_id = ?',
      whereArgs: [songId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PracticeScore.fromMap(map)).toList();
  }

  Future<void> deleteScore(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'scores',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
