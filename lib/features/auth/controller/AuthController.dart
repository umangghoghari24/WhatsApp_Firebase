import 'dart:io';
import 'dart:ui';

import 'package:firebaseconnection/features/auth/class/AuthClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/UserModal.dart';

final authControllerProvider = Provider((ref) {

  final authClass = ref.watch(authClassProvider);
  return AuthController(
    authClass: authClass,
    ref: ref,
  );
});

final userLogindataProvider = FutureProvider((ref) {
  final authController = ref.watch(authClassProvider);
  return authController.getUserLogindata();
});


class AuthController {

  AuthClass authClass;
  final ProviderRef ref;

  AuthController({
    required this.authClass,
    required this.ref
  });


  void signInWithPhone(BuildContext context, String phonenumber)  {
      authClass.signInWithPhone(context, phonenumber );
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authClass.verifyOTP(
      context,
      verificationId,
      userOTP,
    );
  }

  void createUserProfile(String name,
      File? profilePic,
      BuildContext context) {
    authClass.createUserProfile(name, profilePic, ref, context);
  }
    Stream<UserModel> getUserdatafromid(String uid) {
     return authClass.getUserdatafromid(uid);
    }

  void changeUserstate(bool isOnline) {
      authClass.changeUserstate(isOnline);
  }
  }
