import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_goldens/flutter_goldens.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:pomodoro_timer/main.dart';

void main() {
  testGoldens('MyWidget golden test', () async {
    await loadAppFonts();

    await tester.pumpWidgetBuilder(
      const MaterialApp(
        home: Scaffold(
          body: (MyApp),
        ),
      ),
      // surfaceSize: Size(200, 200), // Specify the size of the widget
    );
    // await screenMatchesGolden(tester, 'my_widget_golden'); // Provide a name for the golden image
  });
}