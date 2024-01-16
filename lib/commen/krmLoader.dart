import 'package:flutter/material.dart';
class krmLoader extends StatefulWidget {
  const krmLoader({Key? key}) : super(key: key);

  @override
  State<krmLoader> createState() => _krmLoaderState();
}

class _krmLoaderState extends State<krmLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/3,
            ),
            CircularProgressIndicator(),
            SizedBox(height: 7,),
            Text('Loding..',style: TextStyle(fontSize: 17),)
          ],
        ),
      ),
    );
  }
}
