import 'package:flutter/material.dart';
import 'package:my_app/Api.dart';

void showInfoAlert(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Info'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the alert dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
