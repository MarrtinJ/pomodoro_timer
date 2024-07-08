import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'font_provider.g.dart';

// Kumnbh, RobotoSlab, SpaceMono

@riverpod
class FontNotifier extends _$FontNotifier {
  @override
  String build() {
    return 'Kumnbh';
  }

  void setFont(String newFont) {
    state = newFont;
  }
}