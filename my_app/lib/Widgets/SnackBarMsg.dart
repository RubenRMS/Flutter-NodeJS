import 'package:flutter/material.dart';

dynamic snackbarMsg(String text, int duration, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: Duration(seconds: duration),
    ),
  );
}
