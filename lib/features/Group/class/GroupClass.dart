import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../Model/GroupContact.dart';
import '../../../Model/GroupModel.dart';
import '../../../commen/utils.dart';
import '../../auth/class/FirebaseStorage.dart';

final groupClassProvider = Provider(
      (ref) => GroupClass(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupClass {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  GroupClass({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
      BuildContext context,
      String name,
      File profilePic,
      List<GroupContactModel> selectedContact,
      ) async {
    try {
      //
      List<String> uids = [];
      List<String> members_name = [];
      for (int i = 0; i < selectedContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
          'phoneNumber',
          isEqualTo: selectedContact[i].phones.toString().replaceAll(
            ' ',
            '',
          ),
        )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
          members_name.add(userCollection.docs[0].data()['name']);
        }
      }

      print('members_name =$members_name' );
      var groupId = const Uuid().v1();
      String groupPic =
      await ref.read(firebaseStorageClassProvider).uploadFiles(
        'groups/$groupId',
        profilePic,
      );

      GroupModel groupModel = GroupModel(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: '',
        groupPic: groupPic,
        timeSent: DateTime.now(),
        members: [auth.currentUser!.uid, ...uids],
        members_name: [auth.currentUser!.displayName.toString(), ...members_name],

      );
      await firestore.collection("groups").doc(groupId).set(
        groupModel.toMap(),
      );
      //
    } catch (e) {
      print(e.toString());
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }
}
