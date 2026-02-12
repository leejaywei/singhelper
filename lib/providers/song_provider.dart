import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/song.dart';
import '../data/local/song_dao.dart';

final songDaoProvider = Provider((ref) => SongDao());

final songsProvider = StreamProvider<List<Song>>((ref) async* {
  final songDao = ref.watch(songDaoProvider);
  
  // Initial load
  yield await songDao.getAllSongs();
  
  // In a real app, you would set up a stream from the database
  // For now, we'll just yield the initial value
  // You could use a StateNotifier or similar to handle updates
});

final songProvider = FutureProvider.family<Song?, String>((ref, songId) async {
  final songDao = ref.watch(songDaoProvider);
  return await songDao.getSong(songId);
});
