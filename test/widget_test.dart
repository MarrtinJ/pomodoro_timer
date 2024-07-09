import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/main.dart';

void main() {
  group('Widget tests', () {
    testWidgets(
        'Application initializes and updates screen as timer starts/stops',
        (tester) async {
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

      // Verify updated timer state
      expect(find.text('00:55'), findsOneWidget);

      // Tap the pause button and rebuild the widget
      await tester.tap(find.byKey(const Key('pause_timer')));
      await tester.pump();

      // Verify that the button text has reverted back to start
      expect(find.text('S   T   A   R   T'), findsOneWidget);
    });

    testWidgets('Timer value changes when different timer is selected',
        (tester) async {
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

    testWidgets('Settings dialog appears when settings icon is tapped',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Tap the settings icon and rebuild the widget
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      // Verify that the settings dialog appeared
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Settings dialog disappears when close icon is tapped',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Open the settings dialog
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      // Verify that the settings dialog appeared
      expect(find.text('Settings'), findsOneWidget);

      // Tap the close icon and rebuild the widget
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      // Verify that the settings dialog disappeared
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('Font changes when new font is selected in settings dialog',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Retrieve the MaterialApp widget
      final materialAppFinder = find.byType(MaterialApp);
      var materialAppWidget = tester.widget<MaterialApp>(materialAppFinder);

      // Retrieve the textTheme and fontFamily
      var textTheme = materialAppWidget.theme!.textTheme;
      var fontFamily = textTheme.bodyMedium!.fontFamily;

      // Verify that the initial font is Kumnbh
      expect(fontFamily, 'Kumnbh');

      // Open the settings dialog
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      
      // Change the font to RobotoSlab
      await tester.tap(find.byKey(const Key('change_font_robotoslab')));
      await tester.pump();

      //Retrieve the updated textTheme and fontFamily
      materialAppWidget = tester.widget<MaterialApp>(materialAppFinder);
      textTheme = materialAppWidget.theme!.textTheme;
      fontFamily = textTheme.bodyMedium!.fontFamily;

      // Check that the font has been changed to RobotoSlab
      expect(fontFamily, 'RobotoSlab');

      // Change the font to SpaceMono
      await tester.tap(find.byKey(const Key('change_font_spacemono')));
      await tester.pump();

      //Retrieve the updated textTheme and fontFamily
      materialAppWidget = tester.widget<MaterialApp>(materialAppFinder);
      textTheme = materialAppWidget.theme!.textTheme;
      fontFamily = textTheme.bodyMedium!.fontFamily;

      // Check that the font has been changed to SpaceMono
      expect(fontFamily, 'SpaceMono');
    });

    testWidgets(
        'Button color changes when new color is selected in settings dialog',
        (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));

      // Find the pomodoro button by key
      final elevatedButtonFinder = find.byKey(const Key('select_pomodoro'));
      var pomodoroButton = tester.widget<ElevatedButton>(elevatedButtonFinder);

      // Retrieve the pomodoro button styles
      var buttonStyle = pomodoroButton.style!;
      var buttonColor = buttonStyle.backgroundColor!
          .resolve({}); // need resolve to retrieve the actual color

      // Check that initial button color is red
      expect(buttonColor, buttonRed);

      // Open settings, change button color
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();
      await tester.tap(find.byKey(const Key('change_color_cyan')));
      await tester.pump();

      // Re-retrieve the pomodoroButton and its style
      pomodoroButton = tester.widget<ElevatedButton>(elevatedButtonFinder);
      buttonStyle = pomodoroButton.style!;
      buttonColor = buttonStyle.backgroundColor!.resolve({});
      expect(buttonColor, buttonCyan);

      // Change button color to purple
      await tester.tap(find.byKey(const Key('change_color_purple')));
      await tester.pump();

      // Re-retrieve the pomodoroButton and its style
      pomodoroButton = tester.widget<ElevatedButton>(elevatedButtonFinder);
      buttonStyle = pomodoroButton.style!;
      buttonColor = buttonStyle.backgroundColor!.resolve({});
      expect(buttonColor, buttonPurple);
    });
  });
}
