import 'dart:io';

import 'package:firebaseconnection/commen/Defaultpic.dart';
import 'package:firebaseconnection/commen/cameraview.dart';
import 'package:firebaseconnection/features/Status/StatusView/TextStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../Enum/Enum1.dart';
import '../../../Enum/StatusEnum.dart';
import '../../../Model/StatusModel.dart';
import '../../../commen/krmLoader.dart';
import '../../Chat/views/widgets/GalleryPhoto.dart';
import '../statusControllerProvider/StatusController.dart';
import 'openStroy.dart';
// import 'package:story_view/story_view.dart';

class status extends ConsumerStatefulWidget {
  final uid;
  final isGroup;

  status({required this.uid,required this.isGroup, Key? key}) : super(key: key);

  @override
  ConsumerState<status> createState() => _statusState();
}

File? imageFile;

class _statusState extends ConsumerState<status> {
  final StoryController Statusview = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),

                Text(
                  'Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 280,
                ),
                // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          PopupMenuItem(child: Text("Muted updates")),
                          PopupMenuItem(child: Text("Status privacy")),
                        ])
              ],
            ),
            Container(
              child: ListTile(
                  leading: Stack(children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue,
                      backgroundImage: const NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/11/14/04/45/elephant-1822636_960_720.jpg"),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          border: Border.all(color: Colors.red),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 28,
                      right: 0,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          height: 30,
                          width: 30,
                          child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(children: [
                                        ListTile(
                                          onTap: () {
                                            getfromcamera();
                                          },
                                          leading: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 110),
                                            child: Icon(
                                              Icons.camera_alt,
                                            ),
                                          ),
                                          title: Text('Camera',
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Divider(thickness: 1),
                                        ListTile(
                                            onTap: () {
                                              getfromgallry();
                                            },
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 110),
                                              child: Icon(Icons.image),
                                            ),
                                            title: Text('Gallery',
                                                style: TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ]);
                                    });
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 20,
                              ))),
                    )
                  ]),
                  title: Text("My Status"),
                  subtitle: Text('Today 8:15 AM')),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.1,
              child: Text('recent updates',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 500,
              child: FutureBuilder<List<StatusModel>>(
                  future: ref.read(statusControllerProvider).getStatus(context),
                  builder: (context, snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const krmLoader();
                    }

                    if (snapshots.hasData) {
                      print('data found =${snapshots.data}');

                      return ListView.builder(
                          itemCount: snapshots.data!.length,
                          itemBuilder: (context, index) {
                            StatusModel status = snapshots.data![index];

                            StatusModel contactlist = snapshots.data![index];
                            var timeSent =
                            DateFormat.Hm().format(contactlist.createdAt);


                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => openstory(
                                      status: status.photoUrl,
                                      type: status.type,
                                      statusBGcolor: status.statusBGcolor,
                                      message: status.text,
                                      uname: contactlist.username,
                                    ),
                                  ),
                                );
                              },
                              title: Text(status.username),
                              subtitle: Text(timeSent),

                              leading: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(userprofilePic),
                              ),
                            );
                          });
                    } else {
                      return Text("No Data Found");
                    }
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              heroTag: 1,
              onPressed: () {},
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Status1(
                                uid: widget.uid,
                              )));
                },
                icon: Icon(Icons.edit),
              )),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.camera_alt_outlined),
          ),
        ],
      ),
    );
  }

  getfromgallry() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      imageFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GalleryPhoto(
            pickedFile: imageFile,
            uid: widget.uid,
            messageEnum: MessageEnum.image,
            text: '',
            type: 'text',
            isStatus: true,
            isGroup: widget.isGroup,
          ),
        ),
      );
    });
  }

  getfromcamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryPhoto(
              pickedFile: imageFile,
              uid: widget.uid,
              messageEnum: MessageEnum.image,
              text: '',
              type: 'text',
              isStatus: true,
              isGroup: widget.isGroup,

            ),
          ),
        );
      });
    }
  }
}
