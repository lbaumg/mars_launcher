import 'package:flutter/material.dart';

class ValueNotifierWithKey<T> extends ValueNotifier<T> {
  final String key;

  ValueNotifierWithKey(T value, String key) : this.key = key, super(value);
}

Widget insertVerticalSpacing(double height) {
  return SizedBox(
    height: height,
  );
}