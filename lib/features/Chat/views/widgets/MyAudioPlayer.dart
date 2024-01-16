import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioPlayer extends StatefulWidget {
  final String message;
  const MyAudioPlayer({ required this.message,super.key});
  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {


  final AudioPlayer audioPlayer=AudioPlayer();
  bool isplay = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 300,
        child: Row(
            children:[
              Text("Audo.mp3"),
              IconButton(onPressed: ()async{
                if(isplay) {
                  await audioPlayer.pause();
                }else{
                  await audioPlayer.setUrl(widget.message);
                  audioPlayer.play();
                }
                setState(() {
                  isplay=!isplay;
                });
              }, icon: isplay?Icon(Icons.pause): Icon(Icons.play_circle,),)
            ]
            ),
        );
    }
}