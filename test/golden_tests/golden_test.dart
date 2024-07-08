import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';

void main() {
  group('Golden tests', () {
    testGoldens('Main screen initial state', (WidgetTester tester) async {
      await loadAppFonts();
      await tester.pumpWidgetBuilder(
        const ProviderScope(child: MyApp()),
        surfaceSize: const Size(412, 869), // approximate pixel 8 screen size
      );

      await screenMatchesGolden(tester, 'main_screen_golden');
    });
  });

  testGoldens('Settings dialog initial state', (WidgetTester tester) async {
    await loadAppFonts();
    await tester.pumpWidgetBuilder(
      const ProviderScope(child: SettingsDialog()),
    );

    await screenMatchesGolden(tester, 'settings_dialog_golden');
  });

  // testGoldens('Main screen running state', (WidgetTester tester) async {
  //   await loadAppFonts();

  //   TimerState runningState = TimerState(
  //       isRunning: true, duration: const Duration(minutes: 1, seconds: 23));

  //   await tester.pumpWidgetBuilder(
  //     ProviderScope(
  //       child: MyApp(),
  //       overrides: [
  //         timerNotifierProvider.overrideWith((ref) => TimerNotifier(runningState))
  //       ],
  //     ),
  //     surfaceSize: const Size(412, 869), // approximate pixel 8 screen size
  //   );
  // });
}
