import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/Enum/StatusEnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../Model/StatusModel.dart';
import '../../../Model/UserModal.dart';
import '../../../commen/utils.dart';
import '../../auth/class/FirebaseStorage.dart';

final statusClassProvider = Provider(
      (ref) => StatusClass(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusClass {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusClass({
    required this.firebaseFirestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
    required String type,
    required String text,
    required int statusBGcolor,
  }) async {
    try {
      firebaseFirestore.collection('status').doc();

      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;

      String uploadUrl = '';
      List<String> types=[];
      List<String> text_list=[];


      int colorindex ;
      List<int> colors = [];
      types.add(type);

      if(type == "text")  {
        uploadUrl = text;
        colorindex = statusBGcolor;
      } else {
        colorindex = 5000;
        uploadUrl =
        await ref.read(firebaseStorageClassProvider).uploadFiles(
            'status/$statusId/$uid',
            statusImage,

        );
    }

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        print('part 1');

        List<String> whoCanSee = [];
        for (var i = 0; i < contacts.length; i++) {
          var userCollection = await firebaseFirestore
              .collection("users")
              .where(
            'phoneNumber',
            isEqualTo: contacts[i].phones[0].number.replaceAll(
              ' ',
              '',
            ),
          )
              .get();

          print('part 2');

          if (userCollection.docs.isNotEmpty) {
            var userData = UserModel.fromJson(userCollection.docs[0].data());
            whoCanSee.add(userData.uid.toString());
          }
        }


        List<String> photoUrl = [];
        var statusData = await firebaseFirestore
            .collection('status')
            .where(
          'uid',
          isEqualTo: auth.currentUser!.uid,
        )
            .get();

        print('part 3');
        if (statusData.docs.isNotEmpty) {
          print('part 4');
          StatusModel statusModel = StatusModel.fromMap(
            statusData.docs[0].data(),
          );

          photoUrl = statusModel.photoUrl;
          photoUrl.add(uploadUrl);

          text_list = statusModel.text;
          text_list.add(text);


          List<String> types = statusModel.type;
          types.add(type);

          colors = statusModel.statusBGcolor;
          colors.add(colorindex);


          await firebaseFirestore
              .collection('status')
              .doc(
            statusData.docs[0].id,
          )
              .update({
            'photoUrl': photoUrl,
            'type':types,
            'statusBGcolor' : colors,
            'text':text_list
          });

        } else {

          print('part 5');
          photoUrl.add(uploadUrl); //new uploaded url
          colors.add(colorindex);
          text_list.add(text);



          StatusModel status = StatusModel(
            uid: uid,
            username: username,
            phoneNumber: phoneNumber,
            photoUrl: photoUrl,
            createdAt: DateTime.now(),
            profilePic: profilePic,
            statusId: statusId,
            whoCanSee: whoCanSee,
            type: types,
              text: text_list,
              statusBGcolor: colors
          );


          print('part 6');

          await firebaseFirestore
              .collection('status')
              .doc(statusId)
              .set(status.toMap());
        }
      } else {
        FlutterContacts.requestPermission();
      }
    } catch (e) {

      print("STatus Error =${e.toString()}");

      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        print(i);
        var statusesSnapshot = await firebaseFirestore
            .collection('status')
            .where(
          'phoneNumber',
          isEqualTo: contacts[i].phones[0].number.replaceAll(
          // isEqualTo: auth.currentUser!.phoneNumber!.replaceAll(
            ' ',
            '',
          ),
        )
            .where(
          'createdAt',
          isGreaterThan: DateTime.now()
              .subtract(const Duration(hours: 24))
              .millisecondsSinceEpoch,
        )
            .get();

        print("statussnapshot = ${statusesSnapshot.docs}");

        for (var tempData in statusesSnapshot.docs) {

          print("data = ${tempData.data()}");

          StatusModel tempStatus = StatusModel.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
    return statusData;
    }
}
