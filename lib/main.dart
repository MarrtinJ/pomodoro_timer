import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomodoro_timer/providers/color_provider.dart';
import 'package:pomodoro_timer/providers/font_provider.dart';
import 'package:pomodoro_timer/providers/timer_manager_provider.dart';
import 'package:pomodoro_timer/providers/timer_provider.dart';

// color palette constants
const Color textLight = Color(0xFFD7E0FF);
const Color buttonRed = Color(0xFFF87070);
const Color buttonCyan = Color(0xFF70F3F8);
const Color buttonPurple = Color(0xFFD881F8);
const Color bgDarkBlue = Color(0xFF1E213F);
const Color bgDarkerBlue = Color(0xFF161932);
const Color gradientLight = Color(0xFF2E325A);
const Color gradientDark = Color(0xFF0E112A);
const Color settingsWhite = Color(0xFFFFFFFF);
const Color settingsLight = Color(0xFFEFF1F1);

const textTheme = TextTheme(
    bodyLarge: TextStyle(color: textLight),
    bodyMedium: TextStyle(color: textLight),
    bodySmall: TextStyle(color: textLight));

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String font = ref.watch(fontNotifierProvider);
    return MaterialApp(
      title: 'Pomodoro',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: textLight),
          useMaterial3: true,
          fontFamily: font,
          scaffoldBackgroundColor: bgDarkBlue,
          primaryColor: textLight,
          textTheme: textTheme),
      home: const PomodoroPage(),
    );
  }
}

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void changeTimer(int newTimer) {
      // set the new active timer
      ref
          .read(timerManagerNotiferProvider.notifier)
          .changeActiveTimer(newTimer);

      // read the desired timer duration
      int mins;
      switch (newTimer) {
        case 0: // pomodoro
          mins = ref.watch(timerManagerNotiferProvider).pomodoroDuration;
          break;
        case 1: // short break
          mins = ref.watch(timerManagerNotiferProvider).sbDuration;
          break;
        case 2: // long break
          mins = ref.watch(timerManagerNotiferProvider).lbDuration;
          break;
        default:
          mins = 25;
      }
      // update the timer display
      ref.read(timerNotifierProvider.notifier).stop();
      ref.read(timerNotifierProvider.notifier).setTimer(mins);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'pomodoro',
          style: TextStyle(fontFamily: 'Kumnbh', color: textLight),
        ),
        centerTitle: true,
        backgroundColor: bgDarkBlue,
      ),
      body: Center(
        child: Consumer(
          builder: (context, watch, child) {

            // reading the timer state and manipulating it into a string
            final TimerState timerState = ref.watch(timerNotifierProvider);
            String mins =
                timerState.duration.inMinutes.toString().padLeft(2, '0');
            String secs =
                (timerState.duration.inSeconds % 60).toString().padLeft(2, '0');
            int activeTimer =
                ref.watch(timerManagerNotiferProvider).activeTimer;

            Color currentColor = ref.watch(colorNotifierProvider);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: bgDarkerBlue,
                      borderRadius: BorderRadius.circular(50.0)),
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          key: const Key('select_pomodoro'),
                          onPressed: () => changeTimer(0),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: activeTimer == 0
                                  ? currentColor
                                  : bgDarkerBlue,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20)),
                          child: Text(
                            'pomodoro',
                            style: TextStyle(
                                color:
                                    activeTimer == 0 ? bgDarkBlue : textLight),
                          )),
                      ElevatedButton(
                          key: const Key('select_shortbreak'),
                          onPressed: () => changeTimer(1),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: activeTimer == 1
                                  ? currentColor
                                  : bgDarkerBlue,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20)),
                          child: Text(
                            'short break',
                            style: TextStyle(
                                color:
                                    activeTimer == 1 ? bgDarkBlue : textLight),
                          )),
                      ElevatedButton(
                          key: const Key('select_longbreak'),
                          onPressed: () => changeTimer(2),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: activeTimer == 2
                                  ? currentColor
                                  : bgDarkerBlue,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20)),
                          child: Text(
                            'long break',
                            style: TextStyle(
                                color:
                                    activeTimer == 2 ? bgDarkBlue : textLight),
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 350.0,
                  height: 350.0,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            gradientDark,
                            gradientLight,
                          ])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$mins:$secs',
                        style: const TextStyle(fontSize: 80),
                      ),
                      if (!timerState.isRunning)
                        TextButton(
                            key: const Key('start_timer'),
                            onPressed:
                                ref.read(timerNotifierProvider.notifier).start,
                            child: const Text(
                              'S   T   A   R   T',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textLight),
                            ))
                      else
                        TextButton(
                            key: const Key('pause_timer'),
                            onPressed:
                                ref.read(timerNotifierProvider.notifier).pause,
                            child: const Text(
                              'P   A   U   S   E',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textLight),
                            ))
                    ],
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: bgDarkBlue,
                  elevation: 0.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return const SettingsDialog();
                        });
                  },
                  tooltip: 'Settings',
                  child: const Icon(
                    Icons.settings,
                    size: 40,
                    color: textLight,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTimer = ref.watch(timerManagerNotiferProvider).activeTimer;
    final currentFont = ref.watch(fontNotifierProvider);
    final activeColor = ref.watch(colorNotifierProvider);

    // final List<String> pomodoroDropdownItems = [
    //   '25',
    //   '30',
    //   '45',
    //   '60',
    // ];

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Settings'),
          IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close))
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(),
          const Text(
            'T I M E ( M I N U T E S )',
            style: TextStyle(color: bgDarkerBlue),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text('pomodoro'),
          //     DropdownButton(
          //       items: pomodoroDropdownItems.map((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(value),
          //         );
          //       }).toList(),
          //       onChanged: (String newVal) {

          //       },
          //     )
          //   ],
          // ),
          const Divider(),
          const Text('F O N T', style: TextStyle(color: bgDarkerBlue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor:
                    currentFont == 'Kumnbh' ? bgDarkerBlue : settingsLight,
                elevation: 0.0,
                onPressed: () =>
                    ref.read(fontNotifierProvider.notifier).setFont('Kumnbh'),
                child: Text(
                  'Aa',
                  style: TextStyle(
                      color: currentFont == 'Kumnbh' ? settingsWhite : bgDarkBlue,
                      fontFamily: 'Kumnbh'),
                ),
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor:
                    currentFont == 'RobotoSlab' ? bgDarkerBlue : settingsLight,
                elevation: 0.0,
                onPressed: () => ref
                    .read(fontNotifierProvider.notifier)
                    .setFont('RobotoSlab'),
                child: Text(
                  'Aa',
                  style: TextStyle(
                      color: currentFont == 'RobotoSlab' ? settingsWhite : bgDarkBlue,
                      fontFamily: 'RobotoSlab'),
                ),
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: currentFont == 'SpaceMono' ? bgDarkerBlue : settingsLight,
                elevation: 0.0,
                onPressed: () => ref
                    .read(fontNotifierProvider.notifier)
                    .setFont('SpaceMono'),
                child: Text(
                  'Aa',
                  style: TextStyle(
                    color: currentFont == 'SpaceMono' ? settingsWhite : bgDarkBlue,
                    fontFamily: 'SpaceMono'),
                ),
              ),
            ],
          ),
          const Divider(),
          const Text('C O L O R', style: TextStyle(color: bgDarkerBlue)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: buttonRed,
                elevation: 0.0,
                onPressed: () => ref
                    .read(colorNotifierProvider.notifier)
                    .setColor(buttonRed),
                child: activeColor == buttonRed 
                  ? const Icon(Icons.check, color: bgDarkerBlue)
                  : null,
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: buttonCyan,
                elevation: 0.0,
                onPressed: () => ref
                    .read(colorNotifierProvider.notifier)
                    .setColor(buttonCyan),
                child: activeColor == buttonCyan 
                  ? const Icon(Icons.check, color: bgDarkerBlue)
                  : null,
              ),
              FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: buttonPurple,
                elevation: 0.0,
                onPressed: () => ref
                    .read(colorNotifierProvider.notifier)
                    .setColor(buttonPurple),
                child: activeColor == buttonPurple 
                  ? const Icon(Icons.check, color: bgDarkerBlue)
                  : null,
              ),
            ],
          ),
        ],
      ),
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     child: const Text('Close'),
      //   ),
      // ],
    );
  }
}
