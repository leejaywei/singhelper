import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Songs table
    await db.execute('''
      CREATE TABLE songs (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        artist TEXT NOT NULL,
        original_file_path TEXT NOT NULL,
        vocal_file_path TEXT,
        instrumental_file_path TEXT,
        is_processed INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        processed_at TEXT
      )
    ''');

    // Lyrics table
    await db.execute('''
      CREATE TABLE lyrics (
        id TEXT PRIMARY KEY,
        song_id TEXT NOT NULL,
        line_number INTEGER NOT NULL,
        text TEXT NOT NULL,
        start_time REAL NOT NULL,
        end_time REAL NOT NULL,
        reference_pitch REAL,
        is_high_note INTEGER DEFAULT 0,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');

    // Scores table
    await db.execute('''
      CREATE TABLE scores (
        id TEXT PRIMARY KEY,
        song_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        total_score REAL NOT NULL,
        pitch_score REAL NOT NULL,
        rhythm_score REAL NOT NULL,
        high_note_score REAL NOT NULL,
        stability_score REAL NOT NULL,
        recording_file_path TEXT,
        FOREIGN KEY (song_id) REFERENCES songs (id) ON DELETE CASCADE
      )
    ''');

    // Line scores table
    await db.execute('''
      CREATE TABLE line_scores (
        id TEXT PRIMARY KEY,
        score_id TEXT NOT NULL,
        line_number INTEGER NOT NULL,
        score REAL NOT NULL,
        pitch_accuracy REAL NOT NULL,
        rhythm_accuracy REAL NOT NULL,
        FOREIGN KEY (score_id) REFERENCES scores (id) ON DELETE CASCADE
      )
    ''');

    // Settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Create indexes
    await db.execute('CREATE INDEX idx_lyrics_song_id ON lyrics(song_id)');
    await db.execute('CREATE INDEX idx_scores_song_id ON scores(song_id)');
    await db.execute('CREATE INDEX idx_line_scores_score_id ON line_scores(score_id)');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
