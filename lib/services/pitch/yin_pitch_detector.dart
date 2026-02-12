import 'dart:math';
import '../../core/constants/app_constants.dart';

/// YIN pitch detection algorithm implementation
/// Reference: http://audition.ens.fr/adc/pdf/2002_JASA_YIN.pdf
class YinPitchDetector {
  final int sampleRate;
  final int bufferSize;
  final double threshold;

  YinPitchDetector({
    this.sampleRate = AppConstants.sampleRate,
    this.bufferSize = AppConstants.yinBufferSize,
    this.threshold = AppConstants.pitchThreshold,
  });

  /// Detect pitch from audio buffer
  /// Returns frequency in Hz, or null if no pitch detected
  double? detectPitch(List<double> audioBuffer) {
    if (audioBuffer.length < bufferSize) {
      return null;
    }

    // Step 1: Calculate difference function
    final difference = _differenceFunction(audioBuffer);

    // Step 2: Calculate cumulative mean normalized difference
    final cmndf = _cumulativeMeanNormalizedDifference(difference);

    // Step 3: Find absolute threshold
    final tau = _absoluteThreshold(cmndf);

    if (tau == -1) {
      return null; // No pitch detected
    }

    // Step 4: Parabolic interpolation
    final betterTau = _parabolicInterpolation(cmndf, tau);

    // Step 5: Convert tau to frequency
    final frequency = sampleRate / betterTau;

    // Validate frequency is in reasonable range
    if (frequency < AppConstants.minPitchHz || 
        frequency > AppConstants.maxPitchHz) {
      return null;
    }

    return frequency;
  }

  /// Step 1: Difference function
  List<double> _differenceFunction(List<double> buffer) {
    final difference = List<double>.filled(bufferSize ~/ 2, 0.0);

    for (int tau = 0; tau < bufferSize ~/ 2; tau++) {
      double sum = 0.0;
      for (int i = 0; i < bufferSize ~/ 2; i++) {
        final delta = buffer[i] - buffer[i + tau];
        sum += delta * delta;
      }
      difference[tau] = sum;
    }

    return difference;
  }

  /// Step 2: Cumulative mean normalized difference
  List<double> _cumulativeMeanNormalizedDifference(List<double> difference) {
    final cmndf = List<double>.filled(difference.length, 0.0);
    cmndf[0] = 1.0;

    double runningSum = 0.0;

    for (int tau = 1; tau < difference.length; tau++) {
      runningSum += difference[tau];
      cmndf[tau] = difference[tau] / (runningSum / tau);
    }

    return cmndf;
  }

  /// Step 3: Find first value below threshold
  int _absoluteThreshold(List<double> cmndf) {
    for (int tau = 2; tau < cmndf.length; tau++) {
      if (cmndf[tau] < threshold) {
        // Find local minimum
        while (tau + 1 < cmndf.length && cmndf[tau + 1] < cmndf[tau]) {
          tau++;
        }
        return tau;
      }
    }
    return -1;
  }

  /// Step 4: Parabolic interpolation for better precision
  double _parabolicInterpolation(List<double> cmndf, int tau) {
    if (tau == 0 || tau >= cmndf.length - 1) {
      return tau.toDouble();
    }

    final s0 = cmndf[tau - 1];
    final s1 = cmndf[tau];
    final s2 = cmndf[tau + 1];

    final adjustment = (s2 - s0) / (2 * (2 * s1 - s2 - s0));
    
    return tau + adjustment;
  }

  /// Convert frequency to MIDI note number
  static double frequencyToMidi(double frequency) {
    return 69 + 12 * log(frequency / 440.0) / ln2;
  }

  /// Convert MIDI note number to frequency
  static double midiToFrequency(double midi) {
    return 440.0 * pow(2, (midi - 69) / 12);
  }

  /// Calculate pitch difference in cents (100 cents = 1 semitone)
  static double calculateCents(double frequency1, double frequency2) {
    return 1200 * log(frequency2 / frequency1) / ln2;
  }
}
