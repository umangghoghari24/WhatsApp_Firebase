import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context,  required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ),
  );
}
