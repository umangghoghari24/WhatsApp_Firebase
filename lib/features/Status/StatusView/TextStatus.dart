import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../Enum/Enum1.dart';
import '../../../Enum/StatusEnum.dart';
import '../../../commen/utils.dart';
import '../../Chat/Controller/ChatController.dart';
import '../statusControllerProvider/StatusController.dart';
class Status1 extends ConsumerStatefulWidget {

  String uid;
  Status1({required this.uid,Key? key}) : super(key: key);

  @override
  ConsumerState<Status1> createState() => _TextStatusState();
}

class _TextStatusState extends ConsumerState<Status1> {

  TextEditingController textarea = TextEditingController();
  bool isShow = true;
  late bool hideemoji = true;
  FocusNode focusNode = FocusNode();

  String ? FontStyle;
  List font=[
    'Times ',
    'Arial',

    'Helvetica','fantasy'
    'Georgia','Verdana','cursive','Times New Roman'
  ];
  int statusBGcolor = Random().nextInt(Colors.primaries.length);
  void getfont(){
    setState(() {
      FontStyle = font[ Random().nextInt(font.length)];
    });
  }


  FlutterSoundRecorder ?_flutterSoundRecorder;
  bool isrecordinit=false;
  bool isrecording=false;
  bool isshowsendbtn=false;

  File ? _imageFile;


  // void sendTextmessage(BuildContext context) async {
  //   if (textarea.text != '') {
  //     ref.read(chatClassControllerProvider).sendTextmessage(
  //         context: context,
  //         message: textarea.text.trim(),
  //         reciveruid: widget.uid.toString());
  //     textarea.text = '';
  //   } else {
  //     if(!isrecordinit){
  //       return;
  //     }
  //     var tmpPath= await getTemporaryDirectory();
  //     var path='${tmpPath.path}/watshapclone.aac';
  //     if(isrecording){
  //       await
  //       _flutterSoundRecorder!.stopRecorder();
  //       sendFilemessage(context, File(path),ref ,MessageEnum.audio);
  //     }else{
  //       _flutterSoundRecorder!.startRecorder(toFile: path);
  //     }
  //     setState(() {
  //       isrecording = !isrecording;
  //     });
  //   }
  // }

  // void sendFilemessage(BuildContext context, pickedFile, WidgetRef ref,messageEnum) {
  //   ref.read(chatClassControllerProvider).sendFilemessage(
  //     context: context,
  //     file: pickedFile,
  //     reciveruid: widget.uid,
  //     messageEnum: messageEnum,
  //   );
  //
  //   // if (messageEnum != MessageEnum.audio) {
  //   //   Navigator.pop(context);
  //   //   Navigator.pop(context);
  //   // }
  // }

  // void openAudio(){
  //   Permission.microphone.request().then((permissionstatus){
  //     if(permissionstatus.isGranted){
  //       _flutterSoundRecorder!.openRecorder().then((_){
  //         isrecordinit = true;
  //       }).catchError((e){
  //         print("Error is here ");
  //         print(e);
  //       });
  //     }else if(permissionstatus.isPermanentlyDenied){
  //       openAppSettings();
  //     }else{
  //       Permission.microphone.request();
  //       showSnackBar(context: context, message: "Please Provide Microphone Permission");
  //     }
  //   }).catchError((e){
  //     Permission.microphone.request();
  //     showSnackBar(context: context, message: "Please Provide Microphone Permission");
  //   });
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _flutterSoundRecorder = FlutterSoundRecorder();
  //   openAudio();
  //
  // }

  // int statusBGcolor = Random().nextInt(Colors.primaries.length);

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   textarea.addListener(() {
  //     if (textarea.text != '') {
  //       setState(() {
  //         isShow = false;
  //       });
  //     } else {
  //       setState(() {
  //         isShow = true;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      child: Scaffold(
        backgroundColor: Colors.primaries[statusBGcolor],
        appBar: AppBar(
          backgroundColor: Colors.transparent,

          actions: [
            SizedBox(
              width: 115,
            ),

            Visibility(
              visible: isShow,
              child: IconButton(
                onPressed: () {
                  focusNode.unfocus();
                  focusNode.canRequestFocus = true;
                  setState(() {
                    hideemoji = !hideemoji;
                  });
                },
                icon: Icon(
                  Icons.emoji_emotions,
                  size: 25,
                  color: Colors.black,
                ),
              ),
              replacement: IconButton(onPressed: () {},
                  icon: Icon(Icons.keyboard,
                    color: Colors.black,
                  )),
            ),
            TextButton(onPressed: () {
              getfont();
            },
                child: Text('T',style: TextStyle(
                    fontFamily: FontStyle,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),)),
            // IconButton(
            //   onPressed: () {},
            //   icon: Icon(
            //     Icons.title,
            //     size: 25,
            //   ),
            // ),
            IconButton(
                onPressed: () {
                  setState(() {
                    statusBGcolor = Random().nextInt(Colors.primaries.length);
                  });
                  print('color');
                },
                icon: Icon(
                  Icons.color_lens,
                  size: 25,
                  color: Colors.black,
                )),
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height/3.3),
                TextFormField(
                    autofocus:true,
                  onTap: () {},
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  cursorHeight: 32,
                  style: TextStyle(fontSize: 28,
                  fontFamily: FontStyle
                  ),
                  keyboardType: TextInputType.text,
                  controller: textarea,
                  minLines: 1,
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a status',
                      hintStyle: TextStyle(fontSize: 28)
                  ),
                ),
              // Stack(
              //   children: [
              //     Positioned(
              //
              //       child: Container(
              //         height: 55,
              //         color: Colors.white,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             height: 35,
              //             width: 180,
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(15),
              //               color: Colors.grey
              //             ),
              //             child: Center(child: Text('Status (50 included)')),
              //           ),
              //           Visibility(
              //               visible: isShow,
              //               replacement: CircleAvatar(
              //                 child: IconButton(
              //                   onPressed: () {
              //                     ref.read(statusControllerProvider).uploadStatus(
              //                       statusImage: File(''),
              //                       context: context,
              //                       type: "text",
              //                       text: textarea.text,
              //                       statusBGcolor: statusBGcolor,
              //
              //                     );
              //                     Navigator.pop(context);
              //                   },
              //                   icon: Icon(Icons.send),
              //                 ),
              //                 backgroundColor: Colors.lightGreen,
              //               ),
              //               child: CircleAvatar(
              //                   child: IconButton(
              //                     onPressed: () {},
              //                     icon: Icon(Icons.mic),
              //                   ),
              //                   backgroundColor: Colors.lightGreen),
              //           ),
              //         ],
              //       ),
              //       ),
              //     )
              //   ],
              // ),
              MyEmoji()
            ],
          ),
        ),

        bottomSheet: Container(
          height: 55,
          color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey
              ),
              child: Center(child: Text('Status (50 included)')),
            ),
            Visibility(
                visible: isShow,
                replacement: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      ref.read(statusControllerProvider).uploadStatus(
                        statusImage: File(''),
                        context: context,
                        type: "text",
                        text: textarea.text,
                        statusBGcolor: statusBGcolor
                      );
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.send),
                  ),
                  backgroundColor: Colors.lightGreen,
                ),
                child: CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic),
                    ),
                    backgroundColor: Colors.lightGreen),
            ),
          ],
        ),
        ),

      ),
    );
  }
  Widget MyEmoji() {
    return Container(
      child: Offstage(
        offstage: hideemoji,
        child: SizedBox(
          // width: MediaQuery
          //     .of(context)
          //     .size
          //     .width - 20,
          height: 400,
          child: EmojiPicker(
            textEditingController: textarea,
          ),

        ),
      ),
    );
  }

}
