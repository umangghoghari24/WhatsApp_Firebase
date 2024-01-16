import 'package:firebaseconnection/Mywidget/Mobile/MobileLayout.dart';
import 'package:firebaseconnection/Mywidget/Web/WebLayout.dart';
import 'package:flutter/material.dart';

class myLayout extends StatelessWidget {
   const myLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constraints){

        if(constraints.maxWidth>700){
          return WebLayout();
        }
        else{
          return MobileLayout();
        }
    },);
  }
}
