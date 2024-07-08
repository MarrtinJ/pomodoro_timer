import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pomodoro_timer/main.dart';

void main() {
  group('Widget tests', () {
    testWidgets('Application initializes and updates screen as timer starts/stops', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Verify that our counter starts at 01:00
      expect(find.text('01:00'), findsOneWidget);
      expect(find.text('pomodoro'), findsNWidgets(2));
      expect(find.text('short break'), findsOneWidget);
      expect(find.text('long break'), findsOneWidget);
      expect(find.text('S   T   A   R   T'), findsOneWidget);

      // Tap the start button and rebuild the widget
      await tester.tap(find.byKey(const Key('start_timer')));
      await tester.pump();
      
      // Verify that the button text has changed to "Pause"
      expect(find.text('P   A   U   S   E'), findsOneWidget);

      // Simulate the passage of time
      await tester.pump(const Duration(seconds: 5));

      // Verify updated state
      expect(find.text('00:55'), findsOneWidget);

      // Tap the pause button and rebuild the widget
      await tester.tap(find.byKey(const Key('pause_timer')));
      await tester.pump();
      
      // Verify that the button text has reverted back to start
      expect(find.text('S   T   A   R   T'), findsOneWidget);

    });

    testWidgets('Timer value changes when different timer is selected', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Tap the short break button and rebuild the widget
      await tester.tap(find.byKey(const Key('select_shortbreak')));
      await tester.pump();
      
      // Verify that the timer value has updated
      expect(find.text('05:00'), findsOneWidget);

      // Tap the long break button and rebuild the widget
      await tester.tap(find.byKey(const Key('select_longbreak')));
      await tester.pump();
      
      // Verify that the timer value has updated
      expect(find.text('15:00'), findsOneWidget);

      // Tap the pomodoro button and rebuild the widget
      await tester.tap(find.byKey(const Key('select_pomodoro')));
      await tester.pump();
      
      // Verify that the timer value has updated
      expect(find.text('25:00'), findsOneWidget);
    });
  });
}
