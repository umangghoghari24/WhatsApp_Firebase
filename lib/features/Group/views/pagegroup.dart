import 'dart:io';
import 'package:firebaseconnection/features/Chat/views/personal%20sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Model/GroupContact.dart';
import '../controller/GroupController.dart';

class pagegroup extends ConsumerStatefulWidget {
  final List<GroupContactModel> group;

  pagegroup({
    required this.group,
    super.key,
  });

  @override
  ConsumerState<pagegroup> createState() => _pagegroupState();
}

class _pagegroupState extends ConsumerState<pagegroup> {
  TextEditingController groupname = TextEditingController();
  var a = 0;
  File? pickedFile;
  var imageFile;

  void createGroup(BuildContext context) {
    if (groupname.text.trim().isNotEmpty && imageFile != null) {
      ref
          .read(groupClasscontrollerProvider)
          .createGroup(context, groupname.text.trim(), imageFile!, widget.group
        //ref.read(selectedGroupContacts),
      );
      //ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.group);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('New group'),
            SizedBox(
              width: 100,
              child: Text(
                'Add subject',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 100,
                ),
                Container(
                    child: imageFile == null
                        ? CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        getfromcamera();
                                      },
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                    ),
                                    ListTile(
                                        onTap: () {
                                          getfromgallery();
                                        },
                                        leading: Icon(Icons.image),
                                        title: Text('Gallery')),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.black26,
                      radius: 30,
                    )
                        : CircleAvatar(
                        radius: 30,
                        child: CircleAvatar(
                          backgroundImage: Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          radius: 30,
                        ))),
                // SizedBox(
                //   width: 10,
                // ),
                SizedBox(
                  width: 250,
                  child: TextFormField(
                    controller: groupname,
                    cursorColor: Colors.teal,
                    cursorHeight: 30,
                    decoration:
                    InputDecoration(hintText: 'Enter Your group Name..'),
                  ),
                ),
                SizedBox(
                    width: 8,
                    child: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.black38,
                      size: 28,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 500,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      Text('Disappearing messages'),
                      SizedBox(
                          width: 150,
                          child: Text(
                            'Off',
                            style: TextStyle(color: Colors.black38),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130,
                ),
                Icon(Icons.av_timer)
              ],
            ),
          ),
          Container(
            height: 100,
            width: 500,
            //color: Colors.red,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.group.length,
                itemBuilder: (context, index) {
                  return  InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        CircleAvatar(
                          // backgroundImage:
                          //     NetworkImage(widget.group[index].profilePic),
                        ),
                        Text(widget.group[index].name ?? ''),
                      ],
                    ),
                  );
                }),
          ),

          //Text('Participants:$a',style:TextStyle(color: Colors.black38),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
        onPressed: () {
          createGroup(context);
        },
      ),
    );
  }

  getfromgallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      imageFile = File(pickedFile.path);
    });
  }

  getfromcamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 100,
      maxHeight: 100,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        });
    }
    }
}