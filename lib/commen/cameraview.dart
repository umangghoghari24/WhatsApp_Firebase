import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Enum/Enum1.dart';
import '../features/Chat/Controller/ChatController.dart';
import '../features/Status/statusControllerProvider/StatusController.dart';

class cameraview extends ConsumerStatefulWidget {
  final path;
  final uid;
  final bool isStatus;
  final MessageEnum messageEnum;



  const cameraview({Key? key, required this.path,
    required this.isStatus,
    required this.messageEnum,
    required this.uid,
    required type,
    required text
  })
      : super(key: key);

  @override
  ConsumerState<cameraview> createState() => _cameraviewState();
}

class _cameraviewState extends ConsumerState<cameraview> {
  TextEditingController textarea = TextEditingController();
  bool isShow = true;

  void sendFilemessage(
    BuildContext context,
    File pickedFile,
  ) {
    if (widget.isStatus) {
      ref.read(statusControllerProvider).uploadStatus(
        statusImage: pickedFile,
        context: context,
        type: "image",
        statusBGcolor : 5000,
        text: textarea.text,
      );

    } else {
      ref.read(chatClassControllerProvider).sendFilemessage(
        context: context,
        file: pickedFile,
        reciveruid: widget.uid,
        messageEnum: widget.messageEnum,
        isGroup: false
      );
    }
    Navigator.pop(context);
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        actions: [
          SizedBox(
            width: 115,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.crop_rotate,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.emoji_emotions_outlined,
              size: 25,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.title,
              size: 25,
            ),
          ),
          IconButton(
              onPressed: () {
                print('edit');
              },
              icon: Icon(
                Icons.edit,
                size: 25,
              )),
        ],
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 127,
              child: Image.file(
                File(widget.path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: ('Add a caption '),
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.motion_photos_on),
                              ),
                            ],
                          ),
                          prefixIcon: Visibility(
                            visible: isShow,
                            replacement: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.emoji_emotions_outlined),
                              color: Colors.black54,
                            ),
                            child: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Colors.black45,
                              size: 27,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 25,
                child: IconButton(
                    onPressed: () {
                      sendFilemessage(context, File(widget.path));
                    },
                    icon: Icon(Icons.check)),
                backgroundColor: Colors.teal,
              ),
            )
          ],
        ),
      ),
    );
  }
}
