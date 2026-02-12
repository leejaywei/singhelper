import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio/audio_player_service.dart';
import '../services/audio/recording_service.dart';

final audioPlayerProvider = Provider((ref) => AudioPlayerService());

final recordingServiceProvider = Provider((ref) => RecordingService());
