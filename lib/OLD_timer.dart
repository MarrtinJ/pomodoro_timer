import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

// defaultTime set to 1 minute for testing purposes
int defaultTime = 1;

class TimerState {
  final bool isRunning;
  final Duration duration;

  TimerState({required this.isRunning, required this.duration});
}

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier()
      : super(TimerState(
            isRunning: false, duration: Duration(minutes: defaultTime)));

  Timer? _timer;

  void start() {
    if (state.isRunning) return;
    state = TimerState(isRunning: true, duration: state.duration);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.duration.inSeconds > 0) {
        state = TimerState(
            isRunning: true,
            duration: state.duration - const Duration(seconds: 1));
      } else {
        stop();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = TimerState(isRunning: false, duration: state.duration);
  }

  void stop() {
    _timer?.cancel();
    state =
        TimerState(isRunning: false, duration: Duration(minutes: defaultTime));
  }

  void setTimer(int mins) {
    // edge case handling, if user submits an invalid request, set timer to default state
    if (mins < 0) {
      mins = defaultTime;
    }
    state = TimerState(isRunning: false, duration: Duration(minutes: mins));
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
