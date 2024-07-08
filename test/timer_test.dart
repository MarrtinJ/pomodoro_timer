import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/OLD_timer.dart';

// this file was for testing the timer state
// before I realized I was using legacy code within riverpod (StateProvider, StateNotifier),
// and transitioned to using generated providers
// doesn't work with the new providers

void main() {
  group('TimerNotifier Tests', () {
    late TimerNotifier timerNotifier;

    setUp(() {
      timerNotifier = TimerNotifier();
    });

    tearDown(() {
      // timerNotifier.dispose();
    });

    test('Initial state is correct', () {
      expect(timerNotifier.state.isRunning, false);
      expect(timerNotifier.state.duration, Duration(minutes: defaultTime));
    });

    test('State after starting timer is correct', () async {
      timerNotifier.start();
      expect(timerNotifier.state.isRunning, true);

      // Wait for 5 seconds to let the timer tick
      // added 100 millisecond buffer because sometimes the case would fail
      // timer doesn't update exactly at 5 seconds
      await Future.delayed(const Duration(seconds: 5, milliseconds: 100));

      // Timer should have decreased by 5 seconds
      expect(timerNotifier.state.duration, Duration(minutes: defaultTime) - const Duration(seconds: 5));
    });

    test('State after pausing timer and waiting is correct', () async {
      timerNotifier.start();
      await Future.delayed(const Duration(seconds: 2));
      timerNotifier.pause();

      final pausedDuration = timerNotifier.state.duration;
      expect(timerNotifier.state.isRunning, false);

      // Wait for 2 more seconds to check if the timer is still paused
      await Future.delayed(const Duration(seconds: 2));
      expect(timerNotifier.state.isRunning, false);
      expect(timerNotifier.state.duration, pausedDuration);

    });

    test('State after stopping (resetting) timer', () async {
      timerNotifier.start();
      await Future.delayed(const Duration(seconds: 2));
      timerNotifier.stop();

      expect(timerNotifier.state.isRunning, false);
      expect(timerNotifier.state.duration, Duration(minutes: defaultTime));
    });

    test('Set timer to a specific duration', () {
      timerNotifier.setTimer(5);
      expect(timerNotifier.state.isRunning, false);
      expect(timerNotifier.state.duration, const Duration(minutes: 5));
    });

    test('Set timer with negative value', () {
      // expected behavior with invalid time value is to set Duration to defaultTime
      timerNotifier.setTimer(-1);
      expect(timerNotifier.state.isRunning, false);
      expect(timerNotifier.state.duration, Duration(minutes: defaultTime));
    });
  });
}