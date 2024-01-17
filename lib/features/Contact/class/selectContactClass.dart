
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseconnection/Model/modal.dart';
import 'package:firebaseconnection/features/Chat/views/personal%20sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/UserModal.dart';
import '../../../commen/utils.dart';

final selectContactsClassProvider = Provider(
      (ref) => SelectContactsClass(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsClass {
  final FirebaseFirestore firebaseFirestore;

  SelectContactsClass({
    required this.firebaseFirestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
      } else {
        FlutterContacts.requestPermission();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }


  void selectContact(Contact selectedcontact, BuildContext context, String displayName) async {
    try {
      var userCollection = await firebaseFirestore.collection("users").get();
      bool isRegisterd = false;
      UserModel userData;
      for (var document in userCollection.docs) {
        userData = UserModel.fromJson(document.data());
        String selectedNumber = selectedcontact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (userData.phoneNumber == selectedNumber) {
          isRegisterd = true;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => personalsms(
                uid:userData.uid!,
                uname: displayName,
                isGroup: true,
                members: userData.name.toString(),
                groupPic: '',
                // members_name: userData.name.toString(),
              ),
            ),
          );
          break;
        }
      }
      if (isRegisterd == false) {
        showSnackBar(
          context: context,
          message: "This User is not Registered in this app.",
        );
      }
    } catch (e) {
      showSnackBar(
          context: context,
          message: e.toString(),
      );
    }
  }
}
