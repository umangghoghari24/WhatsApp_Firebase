import 'package:firebaseconnection/commen/Defaultpic.dart';
import 'package:firebaseconnection/myLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../controller/AuthController.dart';

class CreateProfile extends ConsumerStatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends ConsumerState<CreateProfile> {


  final MyPrivatKey = GlobalKey<FormState>();
  TextEditingController UserPic = TextEditingController();

  File ? _imageFile;

  void createUserProfile ( String name,
      BuildContext context) {
    ref.read(authControllerProvider).createUserProfile(name, _imageFile, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height/15,
            ),
            Center(
              child: Container(
                  child: _imageFile == null
                      ? GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Wrap(children: [
                              ListTile(
                                onTap: () {
                                  getfromcamera();
                                },
                                leading: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 110),
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
                    child: Container(
                      child: CircleAvatar(
                        radius: 45,
                        child: Image.asset("assest/images/person.jpg"),
                      ),
                    ),
                  )
                      : CircleAvatar(
                      radius: 45,
                      child: CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          backgroundImage: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ).image,
                          radius: 45),
                  ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width/1.5,
                    child: Form(
                      key: MyPrivatKey,
                      child: TextFormField(
                        controller: UserPic,
                        decoration: InputDecoration(
                          hintText: 'Enter Your Name'
                        ),
                      ),
                    ),
                ),
                IconButton(onPressed: () {
                  if(MyPrivatKey.currentState!.validate()){
                    createUserProfile(UserPic.text,context);
                  }
                },
                    icon: Icon(Icons.check,)),
              ],
            )
          ],
        ),
      ),
    );
  }

  getfromgallry() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  getfromcamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}