import 'package:flutter_test/flutter_test.dart';
import 'package:singhelper/services/pitch/yin_pitch_detector.dart';
import 'dart:math';

void main() {
  group('YinPitchDetector', () {
    late YinPitchDetector detector;

    setUp(() {
      detector = YinPitchDetector();
    });

    test('should detect pitch from sine wave', () {
      // Generate a 440 Hz sine wave (A4 note)
      final frequency = 440.0;
      final sampleRate = 44100;
      final bufferSize = 2048;
      final audioBuffer = List<double>.generate(
        bufferSize,
        (i) => sin(2 * pi * frequency * i / sampleRate),
      );

      final detectedPitch = detector.detectPitch(audioBuffer);

      // Should detect something close to 440 Hz
      expect(detectedPitch, isNotNull);
      expect(detectedPitch!, greaterThan(400));
      expect(detectedPitch, lessThan(480));
    });

    test('should return null for silence', () {
      final audioBuffer = List<double>.filled(2048, 0.0);
      final detectedPitch = detector.detectPitch(audioBuffer);
      expect(detectedPitch, isNull);
    });

    test('frequencyToMidi should convert correctly', () {
      // A4 = 440 Hz = MIDI 69
      final midi = YinPitchDetector.frequencyToMidi(440.0);
      expect(midi, closeTo(69.0, 0.01));
    });

    test('midiToFrequency should convert correctly', () {
      // MIDI 69 = A4 = 440 Hz
      final frequency = YinPitchDetector.midiToFrequency(69.0);
      expect(frequency, closeTo(440.0, 0.01));
    });

    test('calculateCents should compute correctly', () {
      // One semitone = 100 cents
      final cents = YinPitchDetector.calculateCents(440.0, 466.16); // A4 to A#4
      expect(cents, closeTo(100.0, 1.0));
    });
  });
}
