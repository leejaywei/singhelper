import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class RecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _currentRecordingPath;

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    final hasPermission = await this.hasPermission();
    if (!hasPermission) {
      throw Exception('Recording permission not granted');
    }

    final directory = await getApplicationDocumentsDirectory();
    final recordingsDir = Directory('${directory.path}/recordings');
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }

    final fileName = '${const Uuid().v4()}.m4a';
    _currentRecordingPath = '${recordingsDir.path}/$fileName';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: _currentRecordingPath!,
    );
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    final recordingPath = _currentRecordingPath;
    _currentRecordingPath = null;
    return recordingPath ?? path;
  }

  Future<void> cancelRecording() async {
    await _recorder.stop();
    if (_currentRecordingPath != null) {
      final file = File(_currentRecordingPath!);
      if (await file.exists()) {
        await file.delete();
      }
      _currentRecordingPath = null;
    }
  }

  Stream<RecordState> get onStateChanged => _recorder.onStateChanged();

  bool get isRecording => _recorder.isRecording;

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
