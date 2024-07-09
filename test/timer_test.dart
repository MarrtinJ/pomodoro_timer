import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';

void main() {
  group('TimerNotifier', () {
    late ProviderContainer container;
    late TimerNotifier timerNotifier;
    late ProviderSubscription<TimerState> listener;

    setUp(() {
      container = ProviderContainer();
      timerNotifier = container.read(timerNotifierProvider.notifier);
      listener = container.listen(
        timerNotifierProvider,
        (previous, next) {},
        fireImmediately: true,
      );
    });

    tearDown(() {
      container.dispose();
      listener.close();
    });

    test('Initial state is correct', () {
      final state = container.read(timerNotifierProvider);
      expect(state.isRunning, false);
      expect(state.duration, Duration(minutes: defaultTime));
    });

    test('isRunning is true after starting timer', () async {
      timerNotifier.start();
      var state = container.read(timerNotifierProvider);
      expect(state.isRunning, true);

      // Wait for 5 seconds and check if the timer decremented
      // added 100 millisecond buffer because sometimes the case would fail
      // timer doesn't update exactly at 5 seconds
      await Future.delayed(const Duration(seconds: 5, milliseconds: 100));
      state = container.read(timerNotifierProvider);
      expect(state.duration, Duration(minutes: defaultTime) - const Duration(seconds: 5));
    });

    test('isRunning is false after pausing timer and waiting', () async {
      timerNotifier.start();
      await Future.delayed(const Duration(seconds: 2));
      timerNotifier.pause();

      // Verify that isRunning is false after pausing
      var state = container.read(timerNotifierProvider);
      expect(state.isRunning, false);

      // Wait for 2 more seconds to check if the timer is still paused
      final pausedDuration = state.duration;
      await Future.delayed(const Duration(seconds: 2));
      state = container.read(timerNotifierProvider);     
      expect(state.isRunning, false);
      expect(state.duration, pausedDuration);
    });

    test('isRunning is false after stopping timer, timer duration reset', () async {
      timerNotifier.start();
      await Future.delayed(const Duration(seconds: 2));
      timerNotifier.stop();
      final state = container.read(timerNotifierProvider);
      expect(state.isRunning, false);
      expect(state.duration, Duration(minutes: defaultTime));
    });

    test('Duration updated after setTimer', () {
      timerNotifier.setTimer(5);
      var state = container.read(timerNotifierProvider);
      expect(state.isRunning, false);
      expect(state.duration, const Duration(minutes: 5));
    });

    test('Set timer with an invalid negative value', () {
      // expected behavior with invalid time value is to set Duration to defaultTime
      timerNotifier.setTimer(-1);
      var state = container.read(timerNotifierProvider);

      state = container.read(timerNotifierProvider);
      expect(state.isRunning, false);
      expect(state.duration, Duration(minutes: defaultTime));
    });
  });
}
