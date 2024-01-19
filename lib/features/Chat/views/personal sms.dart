
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/Model/MessageModel.dart';
import 'package:firebaseconnection/Model/UserModal.dart';
import 'package:firebaseconnection/commen/Defaultpic.dart';
import 'package:firebaseconnection/commen/cameraview.dart';
import 'package:firebaseconnection/commen/krmLoader.dart';
import 'package:firebaseconnection/features/Chat/Controller/ChatController.dart';
import 'package:firebaseconnection/features/Chat/views/widgets/Bottommodal.dart';
import 'package:firebaseconnection/features/Chat/views/widgets/GalleryPhoto.dart';
import 'package:firebaseconnection/features/Chat/views/widgets/Sender.dart';
import 'package:firebaseconnection/features/Chat/views/widgets/reciver.dart';
import 'package:firebaseconnection/features/auth/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../Enum/Enum1.dart';
import '../../../Mywidget/Web/WebLayout.dart';
import '../../../main.dart';

class personalsms extends ConsumerStatefulWidget {
   String uid;
   final String uname;
   final bool isGroup;
   final String members;
   final String members_name;
   final groupPic;

  personalsms({
    required this.uid,
    required this.uname,
    required this.isGroup,
    required this.groupPic,
    required this.members,
    required this.members_name,
    Key? key,}) : super(key: key);

  @override
  ConsumerState<personalsms> createState() => _personalsmsState();
}

class _personalsmsState extends ConsumerState<personalsms> {
  FocusNode messagefocuce = FocusNode();
  // TextEditingController message = TextEditingController();
  TextEditingController textarea = TextEditingController();
  ScrollController msgscrollController = ScrollController();
  // TextEditingController emoji = TextEditingController();
  FocusNode focusNode = FocusNode();
  late bool hideemoji = true;
  bool isShow = true;

  File ? _imageFile;

  //
  // void sendTextmessage(BuildContext context) {
  //   if (textarea.text != '') {
  //     ref.read(chatClassControllerProvider).sendTextmessage(
  //       context: context,
  //       message: textarea.text.trim(),
  //       reciveruid: widget.uid.toString()
  //     );
  //     textarea.text='';
  //   }
  // }
  //

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   focusNode.addListener(() {
  //     if (focusNode.hasFocus) {
  //       setState(() {
  //         hideemoji = true;
  //       });
  //     } else {
  //       setState(() {
  //         hideemoji = false;
  //       });
  //     }
  //   });
  //   textarea.addListener(() {
  //     if (textarea.text!= '') {
  //      setState(() {
  //         isShow = false;
  //      });
  //     } else {
  //      setState(() {
  //         isShow = true;
  //      });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.groupPic),
            radius: 40,
          ),
          title: Column(
            children:[
              widget.isGroup ?
                Column(
                  children: [
                    Text(widget.uname),
                    Text(widget.members_name)
                  ],
                ) :
              Column(
                children: [
                  Text(
                    widget.uname,
                    // style: TextStyle(fontSize: 20,),
      ),
                  StreamBuilder(
                    stream: ref
                        .read(authControllerProvider)
                        .getUserdatafromid(widget.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.data!.isOnline) {
                        return Text(
                          "Online",
                          style: TextStyle(fontSize: 19),
                        );
                      }
                      return Text(
                        "Ofline",
                        style: TextStyle(fontSize: 19),
                      );
                    },
                  )
                ],
              ) ,
            ],
          ),
          actions: [
            Row(
              children: [
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.videocam)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.call)),
                    PopupMenuButton(

                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                              PopupMenuItem(child: Text("View contact")),
                              PopupMenuItem(
                                  child: Text("Media, links and docs")),
                              PopupMenuItem(child: Text("Search")),
                              PopupMenuItem(child: Text("mute notifications")),
                              PopupMenuItem(
                                  child: Text("Disappearing message")),
                              PopupMenuItem(child: Text("Wallpaper"),),

                              PopupMenuItem(child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('More'),
                                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_right))
                                ],
                              )),
                            ])
                  ],
                )
              ],
            )
          ],
        ),
        body: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assest/images/bgimag.jpg'),
                        fit: BoxFit.fill)),

                child: Stack(
                  children: [
                    widget.isGroup ?
                    StreamBuilder<List<MessageModel>>(
                      stream: ref
                          .watch(chatClassControllerProvider)
                          .getGroupMessages(widget.uid),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return const krmLoader();
                        }
                        List<MessageModel> chatmessage = snapshots.data!;

                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          msgscrollController.jumpTo(
                            msgscrollController.position.maxScrollExtent,
                          );
                        });
                        return ListView.builder(
                          controller: msgscrollController,
                          shrinkWrap: true,
                          itemCount: chatmessage.length,
                          itemBuilder: (context, index) {
                            MessageModel groupModel = chatmessage[index];
                            var timeSent =
                            DateFormat.Hm().format(groupModel.time);

                            if (groupModel.type == MessageEnum.gif) {
                              // print(" url = ${groupModel.message}");
                            }
                            // return Text(contactlist.message);
                            if (groupModel.reciverId==
                                FirebaseAuth.instance.currentUser?.uid) {
                              return Reciver(
                                message: groupModel.message,
                                time: timeSent,
                                isSeen: true,
                                type: groupModel.type,
                              );
                            }
                            return Sender(
                              message: groupModel.message,
                              time: timeSent,
                              isSeen: true,
                              type: groupModel.type,
                            );
                          },
                        );
                      },
                    ) :
                    StreamBuilder<List<MessageModel>>(
                        stream: ref.watch(chatClassControllerProvider).getMessages(widget.uid),
                        builder: (context, snapshots) {
                          if (snapshots.connectionState == ConnectionState.waiting) {
                            return krmLoader();
                          }
                          List<MessageModel> chatmessage = snapshots.data!;
                          {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              msgscrollController.jumpTo(
                              msgscrollController.position.maxScrollExtent,
                              );
                          });
                         }
                          return ListView.builder(
                            controller: msgscrollController,
                            itemCount: chatmessage.length,
                            itemBuilder: (context, index) {
                              MessageModel contactlist = chatmessage[index];

                              var timeSent = DateFormat.Hm().format(contactlist.time);

                              if(contactlist.reciverId==FirebaseAuth.instance.currentUser?.uid){
                                return Reciver(
                                  message:contactlist.message  ,
                                  time: timeSent,
                                  isSeen: true,
                                  type: contactlist.type,
                                );
                              }else{
                                return Sender(
                                  message:contactlist.message  ,
                                  time: timeSent,
                                  isSeen: true,
                                  type: contactlist.type,
                                );
                              }
                              // return ListTile(
                              //   onTap: () {
                              //   },
                              //   leading: Text(contactlist.message ?? ''),
                              // );
                            },
                          );
                        }),

                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Bottommodal(
                              uid: widget.uid,
                              isGroup: widget.isGroup,
                            ),
                          ),
                  ],
                ),
              ),
    );
  }
  // Widget MyEmoji() {
  //   return Container(
  //     child: Offstage(
  //       offstage: hideemoji,
  //       child: SizedBox(
  //           width: MediaQuery.of(context).size.width - 20,
  //           height: 270,
  //           child: EmojiPicker(
  //             textEditingController: textarea,
  //           )),
  //     ),
  //   );
  // }

  // Widget Bottommodal() {
  //   return Container(
  //     height: 250,
  //     //  width: MediaQuery.of(context).size.width,
  //     child: Card(
  //       margin: EdgeInsets.all(10),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
  //         child: Column(
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 iconcreation(IconButton(onPressed: () {}, icon: Icon(Icons.file_copy)), Colors.indigo, 'Document'),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconcreation(
  //                   IconButton(onPressed: () {
  //                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Cameraapp()));
  //
  //                   }, icon: Icon(Icons.camera_alt)),
  //                   Colors.pink,
  //                   'Camera',
  //                 ),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconcreation(IconButton(onPressed: () {
  //                   getfromgallery();
  //                 }, icon: Icon(Icons.photo)), Colors.purple, 'Gallery'),
  //               ],
  //             ),
  //             SizedBox(
  //               width: 40,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 iconcreation(IconButton(onPressed: () {}, icon: Icon(Icons.audio_file)), Colors.orange, 'Audio'),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconcreation(IconButton(onPressed: () {}, icon: Icon(Icons.location_pin)), Colors.green, 'Location'),
  //                 SizedBox(
  //                   width: 40,
  //                 ),
  //                 iconcreation(IconButton(onPressed: () {}, icon: Icon(Icons.person)), Colors.blue, 'Contact'),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget iconcreation(
  //   IconButton Icons,
  //   Color color,
  //   String text,
  // ) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 30,
  //         backgroundColor: color,
  //         child: Icons,
  //       ),
  //       SizedBox(
  //         height: 5,
  //       ),
  //       Text(text),
  //     ],
  //   );
  // }

  // getfromgallry() async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile == null) return;
  //   setState(() {
  //     _imageFile = File(pickedFile.path);
  //   });
  // }

  // getfromgallery() async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   if (pickedFile == null) {
  //     // print("object 111");
  //   }else{
  //     File imageFile = File(pickedFile.path);
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>GalleryPhoto(pickedFile: imageFile,uid: widget.uid)));
  //   }
  //
  //   }
}
