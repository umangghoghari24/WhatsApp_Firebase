import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../Enum/Enum1.dart';
import 'MyAudioPlayer.dart';
import 'VideoPlayer.dart';
//Reciver

class Reciver extends StatelessWidget {
  final String message;
  final String time;
  final bool isSeen;
  final MessageEnum type;

  Reciver({
    required this.message,
    required this.time,
    required this.isSeen,
    required this.type,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width*0.40
          ),
          child: Card(
            color: Colors.teal,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      type == MessageEnum.image
                          ? CachedNetworkImage(
                        imageUrl: message,
                      )
                          : type == MessageEnum.video
                          ? MyVideoPlayer(videotype: 2, videopath: File(''), videourl: message) :
                      type == MessageEnum.audio ? MyAudioPlayer(message : message) :
                      type == MessageEnum.gif ? CachedNetworkImage(imageUrl: message)
                          : SizedBox(width: 150, child: Text(message)),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Row(
                          children: [Text(time), Icon(Icons.done_all),],
                        ),),
                    ],

                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

