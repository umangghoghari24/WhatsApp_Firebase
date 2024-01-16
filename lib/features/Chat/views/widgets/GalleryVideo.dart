import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../Enum/Enum1.dart';
import '../../Controller/ChatController.dart';

class GalleryVideo extends ConsumerStatefulWidget {
  final File? pickedFile;
  final uid;

  GalleryVideo({required this.pickedFile,required this.uid,super.key});

  @override
  ConsumerState<GalleryVideo> createState() => _GalleryPhotoState();
}

class _GalleryPhotoState extends ConsumerState<GalleryVideo> {
  bool isShow = true;

  TextEditingController image = TextEditingController();

  void sendVideoFilemessage(BuildContext context, pickedFile,) {
    ref.read(chatClassControllerProvider).sendFilemessage(
      context: context,
      file: pickedFile,
      reciveruid: widget.uid,
      messageEnum:MessageEnum.video,
      isGroup: false
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body:  Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.80,
              child:
              Image.file(
                widget.pickedFile!,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric( horizontal: 1),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: ('Add a caption'),
                          hintStyle: TextStyle(fontSize: 18,color: Colors.black),
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
                child: IconButton(onPressed: () {
                  sendVideoFilemessage(context, widget.pickedFile);
                },
                    icon: Icon(Icons.send)),
                backgroundColor: Colors.teal,),
            ),
          ],
        ),
      ),
    );
  }
}
