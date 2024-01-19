import 'dart:typed_data';

import 'package:firebaseconnection/Enum/StatusEnum.dart';
import 'package:firebaseconnection/commen/krmLoader.dart';
import 'package:firebaseconnection/features/Status/StatusView/status.dart';
import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../commen/Defaultpic.dart';

class openstory extends StatefulWidget {
  final List<String> status;
  final List<String> type;
  final List<int> statusBGcolor;
  final List<String> message;
  final String uname;


  const openstory({required this.status, required this.type, required this.statusBGcolor,required this.uname,required this.message ,Key? key})
      : super(key: key);

  @override
  State<openstory> createState() => _openstoryState();
}

class _openstoryState extends State<openstory> {
  final storyController = StoryController();
  List<StoryItem> storyItems = [];

  void createstoryitem() {
    for (int i = 0; i < widget.status.length; i++) {
      widget.type[i] == "image"
          ? storyItems.add(StoryItem.pageImage(
              url: widget.status[i].toString(),
              controller: storyController,
              caption: widget.message[i]
      ))
          : storyItems.add(
              StoryItem.text(
                title: widget.status[i].toString(),
                backgroundColor: Colors.primaries[widget.statusBGcolor[i]]
              ),
            );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createstoryitem();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (storyItems.length == 0) {
      return krmLoader();
    }
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(radius: 25,
              backgroundImage: NetworkImage(userprofilePic),
            ),
            SizedBox(width: 10,),
            Text(widget.uname),

          ],
        ),
        // leading: CircleAvatar(radius: 35,),

      ),
      body: Stack(
        children: [
         StoryView(
          storyItems: storyItems,
          onStoryShow: (s) {
            print("Showing a story");
          },
          onComplete: () {
            print("Completed a cycle");
            Navigator.pop(context);
          },

          progressPosition: ProgressPosition.top,
          repeat: false,
          controller: storyController,
        ),
          Positioned(child: Text(''))
      ],
      ),
    );
  }
}
