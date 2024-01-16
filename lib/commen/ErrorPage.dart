import 'package:flutter/material.dart';
class ErrorPage extends StatelessWidget {
  final error;
  const ErrorPage({Key? key, required this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        Image.asset('assest/images/errorimage.jpg'),
      ),
    );
  }
}
