import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_provider.g.dart';

const Color buttonRed = Color(0xFFF87070);
const Color buttonCyan = Color(0xFF70F3F8);
const Color buttonPurple = Color(0xFFD881F8);

@riverpod
class ColorNotifier extends _$ColorNotifier {
  @override
  Color build() {
    return buttonRed;
  }

  void setColor(Color newColor) {
    state = newColor;
  }
}