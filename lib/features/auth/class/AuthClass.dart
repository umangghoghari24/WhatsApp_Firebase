// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseconnection/Mywidget/Web/WebLayout.dart';
import 'package:firebaseconnection/features/auth/views/CreateProfile.dart';
import 'package:firebaseconnection/features/auth/views/OTPScreen.dart';
import 'package:firebaseconnection/myLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/UserModal.dart';
import '../../../commen/Colors.dart';
import '../../../commen/Defaultpic.dart';
import '../../../commen/utils.dart';
import 'FirebaseStorage.dart';

//provider
final authClassProvider = Provider(
  (ref) => AuthClass(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);

class AuthClass {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthClass(
    this.auth,
    this.firestore,
  );

  Future<UserModel?> getUserLogindata() async {
    var userdata = await firestore
        .collection('users')
        .doc(
      auth.currentUser?.uid,
    )
        .get();
    UserModel? user;
    if (userdata.data() != null) {
      user = UserModel.fromJson(userdata.data()!);
    }
    return user;
  }

  Stream<UserModel> getUserdatafromid(String uid) {
  return  firestore.collection('users').doc(uid).snapshots().map((event) =>UserModel.fromJson(event.data()!),);

  }
  /////******** Mobile Number Login********////

  void signInWithPhone(BuildContext context, String phonenumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: verificationId,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
  }

  void verifyOTP(
    BuildContext context,
    String verificationId,
    String userOTP,
  ) async {
    try {
      //
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CreateProfile(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
  }

  void createUserProfile(
    String name,
    File? profilePic,
    ProviderRef ref,
    BuildContext context,
  ) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = userprofilePic;

      if (profilePic != null) {
        photoUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
              'profilePic/$uid',
              profilePic,
            );
      }
      var user = UserModel(
        name: name,
        uid: uid,
        photoUrl: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );
      await firestore.collection("users").doc(uid).set(user.toJson());
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const myLayout()),
        // (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  void changeUserstate(bool isOnline){
    firestore.collection('users').doc(auth.currentUser?.uid).update({
      'isOnline':isOnline,
    });
  }

}
