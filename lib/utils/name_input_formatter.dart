import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    // 1. Remove leading spaces
    text = text.replaceFirst(RegExp(r'^\s+'), '');

    // 2. Collapse multiple spaces into one
    text = text.replaceAll(RegExp(r'\s{2,}'), ' ');

    // 3. Prevent trailing spaces
    if (text.endsWith('  ')) {
      text = text.trimRight();
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
