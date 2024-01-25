import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebaseconnection/Enum/Enum1.dart';
import 'package:firebaseconnection/Enum/StatusEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../commen/utils.dart';
import '../../../../main.dart';
import '../../Controller/ChatController.dart';
import 'GalleryPhoto.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:giphy_picker/giphy_picker.dart';

import 'Gif.dart';

class Bottommodal extends ConsumerStatefulWidget {
  String uid;

  // final String reciveruid;
  final bool isGroup;

  Bottommodal(
      {required this.uid,
      // required this.reciveruid,
      required this.isGroup,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<Bottommodal> createState() => _BottommodalState();
}

class _BottommodalState extends ConsumerState<Bottommodal> {
  FocusNode messagefocuce = FocusNode();
  TextEditingController textarea = TextEditingController();
  FocusNode focusNode = FocusNode();
  late bool hideemoji = true;
  bool isShow = true;

  FlutterSoundRecorder? _flutterSoundRecorder;
  bool isrecordinit = false;
  bool isrecording = false;
  bool isshowsendbtn = false;

  File? _imageFile;

  void sendTextmessage(BuildContext context) async {
    if (textarea.text != '') {
      ref.read(chatClassControllerProvider).sendTextmessage(
          context: context,
          message: textarea.text.trim(),
          isGroup: widget.isGroup,
          reciveruid: widget.uid.toString());
      textarea.text = '';
      //   }
      //
      // void sendTextmessage(BuildContext context)async {
      //   // textarea.text != ''
      //   if (isshowsendbtn ) {
      //     ref.read(chatClassControllerProvider).sendTextmessage(
      //       context: context,
      //       message: textarea.text.trim(),
      //       reciveruid: widget.uid.toString(),
      //     );
      //     textarea.text = '';
    } else {
      if (!isrecordinit) {
        return;
      }
      var tmpPath = await getTemporaryDirectory();
      var path = '${tmpPath.path}/watshapclone.aac';
      if (isrecording) {
        await _flutterSoundRecorder!.stopRecorder();
        sendFilemessage(context, File(path), ref, MessageEnum.audio);
      } else {
        _flutterSoundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isrecording = !isrecording;
      });
    }
  }

  void sendFilemessage(
      BuildContext context, pickedFile, WidgetRef ref, messageEnum) {
    ref.read(chatClassControllerProvider).sendFilemessage(
          context: context,
          file: pickedFile,
          reciveruid: widget.uid,
          messageEnum: messageEnum,
          isGroup: widget.isGroup,
        );
    if (messageEnum != MessageEnum.audio) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  void sendGifmessage(
    BuildContext context,
  ) async {
    final gif = await pickGif(context);

    if (gif != null) {
      ref.read(chatClassControllerProvider).sendGifmessage(
            context: context,
            gifurl: gif.url!,
            reciveruid: widget.uid,
            isGroup: widget.isGroup,
          );
    }
  }

  void openAudio() {
    Permission.microphone.request().then((permissionstatus) {
      if (permissionstatus.isGranted) {
        _flutterSoundRecorder!.openRecorder().then((_) {
          isrecordinit = true;
        }).catchError((e) {
          print("Error is here ");
          print(e);
        });
      } else if (permissionstatus.isPermanentlyDenied) {
        openAppSettings();
      } else {
        Permission.microphone.request();
        showSnackBar(
            context: context, message: "Please Provide Microphone Permission");
      }
    }).catchError((e) {
      Permission.microphone.request();
      showSnackBar(
          context: context, message: "Please Provide Microphone Permission");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          hideemoji = true;
        });
      } else {
        setState(() {
          hideemoji = false;
        });
      }
    });
    textarea.addListener(() {
      if (textarea.text != '') {
        setState(() {
          isShow = false;
        });
      } else {
        setState(() {
          isShow = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (hideemoji == true) {
          Navigator.pop(context);
        } else {
          setState(() {
            hideemoji = !hideemoji;
          });
        }
        return Future.value();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    onTap: () {},
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 3,
                    controller: textarea,
                    textAlignVertical: TextAlignVertical.center,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Message',
                      contentPadding: EdgeInsets.only(
                        left: 3,
                        right: 3,
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Bottommodal());
                              },
                              icon: Icon(Icons.attach_file)),
                          Visibility(
                            visible: isShow,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Cameraapp(
                                              uid: widget.uid,
                                            )));
                              },
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                        ],
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          focusNode.unfocus();
                          focusNode.canRequestFocus = true;
                          setState(() {
                            hideemoji = !hideemoji;
                          });
                        },
                        icon: Icon(Icons.emoji_emotions),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: isShow,
                replacement: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      sendTextmessage(context);
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
                child: CircleAvatar(
                  child: GestureDetector(
                    onLongPressStart: (_) {
                      sendTextmessage(context);
                    },
                    onLongPressEnd: (_) {
                      sendTextmessage(context);
                    },
                    onTap: () {
                      if (isshowsendbtn) {
                        sendTextmessage(context);
                      }
                    },
                    child: isshowsendbtn
                        ? Icon(Icons.send)
                        : isrecording
                            ? Icon(Icons.close)
                            : Icon(Icons.mic),
                  ),
                ),
              ),
            ],
          ),
          MyEmoji()
        ],
      ),
    );
  }

  Widget MyEmoji() {
    return Container(
      child: Offstage(
        offstage: hideemoji,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 270,
          child: EmojiPicker(
            textEditingController: textarea,
          ),
        ),
      ),
    );
  }

  Widget Bottommodal() {
    return Container(
      height: 250,
      //  width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(
                      IconButton(onPressed: () {}, icon: Icon(Icons.file_copy)),
                      Colors.indigo,
                      'Document'),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Cameraapp(
                                        uid: widget.uid,
                                      )));
                        },
                        icon: Icon(Icons.camera_alt)),
                    Colors.pink,
                    'Camera',
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                      IconButton(
                          onPressed: () {
                            getfromgallery();
                          },
                          icon: Icon(Icons.photo)),
                      Colors.purple,
                      'Gallery'),
                ],
              ),
              SizedBox(
                width: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconcreation(
                      IconButton(
                          onPressed: () {}, icon: Icon(Icons.audio_file)),
                      Colors.orange,
                      'Audio'),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                      IconButton(
                          onPressed: () async {
                            sendGifmessage(context);
                          },
                          icon: Icon(Icons.gif)),
                      Colors.green,
                      'Gif'),
                  SizedBox(
                    width: 40,
                  ),
                  iconcreation(
                      IconButton(
                        onPressed: () {
                          getfromgalleryvideo();
                        },
                        icon: Icon(Icons.videocam),
                      ),
                      Colors.blue,
                      'Video'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconcreation(
    IconButton Icons,
    Color color,
    String text,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icons,
        ),
        SizedBox(
          height: 5,
        ),
        Text(text),
      ],
    );
  }

  getfromgallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      // print("object 111");
    } else {
      File imageFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhoto(
            pickedFile: imageFile,
            uid: widget.uid,
            messageEnum: MessageEnum.image,
            text: '',
            type: "text",
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }

  getfromgalleryvideo() async {
    final pickedFileVideo = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFileVideo == null) {
    } else {
      File VideoFile = File(pickedFileVideo.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhoto(
            pickedFile: VideoFile,
            uid: widget.uid,
            messageEnum: MessageEnum.video,
            text: '',
            type: "text",
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }
}
