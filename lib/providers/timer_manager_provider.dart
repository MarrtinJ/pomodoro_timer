import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_manager_provider.g.dart';

// 0: pomodoro, 1: short break, 2: long break
int defaultTime = 25;

class TimerManagerState {
  final int activeTimer;
  final int pomodoroDuration;
  final int sbDuration;
  final int lbDuration;

  TimerManagerState(
      {required this.activeTimer,
      required this.pomodoroDuration,
      required this.sbDuration,
      required this.lbDuration});
  
  TimerManagerState copyWith({
    int? activeTimer,
    int? pomodoroDuration,
    int? sbDuration,
    int? lbDuration,
  }) {
    return TimerManagerState(
      activeTimer: activeTimer ?? this.activeTimer,
      pomodoroDuration: pomodoroDuration ?? this.pomodoroDuration,
      sbDuration: sbDuration ?? this.sbDuration,
      lbDuration: lbDuration ?? this.lbDuration,
    );
  }
}

@riverpod
class TimerManagerNotifer extends _$TimerManagerNotifer {
  @override
  TimerManagerState build() {
    return (TimerManagerState(
        activeTimer: 0, pomodoroDuration: 25, sbDuration: 5, lbDuration: 15));
  }

  void changeActiveTimer(int newActiveTimer) {
    int currentActiveTimer = state.activeTimer;
    if (newActiveTimer == currentActiveTimer) return;

    state = state.copyWith(activeTimer: newActiveTimer);
  }

  void setTimerDuration(int targetTimer, int newDuration) {
    switch (targetTimer) {
        case 0: // pomodoro
          state = state.copyWith(pomodoroDuration: newDuration);
          break;
        case 1: // short break
          state = state.copyWith(sbDuration: newDuration);
          break;
        case 2: // long break
          state = state.copyWith(lbDuration: newDuration);
          break;
        default:
          state = state.copyWith(pomodoroDuration: newDuration);
          break;
      }
  }
}
