
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../Model/VideoCall.dart';
import '../../auth/controller/AuthController.dart';
import '../Class/VideoCallClass.dart';

final videocallClasscontrollerProvider = Provider(
      (ref) => VideoCallController(
    auth: FirebaseAuth.instance,
    videoCallClass: ref.read(videocallClassProvider),
    ref: ref,
  ),
);

class VideoCallController {
  FirebaseAuth auth;
  VideoCallClass videoCallClass;

  final ProviderRef ref;

  VideoCallController({
    required this.auth,
    required this.videoCallClass,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callstream => videoCallClass.callstream;

  // Future<DocumentSnapshot> get call => videoCallClass.call(BuildContext,context);

  Future<List<VideoCall>> call(BuildContext context) async {
    return await videoCallClass.call(BuildContext, context);
  }


  void startCall(BuildContext context,
      String receiverName,
      String receiverUid,
      String receiverProfilePic,
      bool isGroupChat,) {
    ref.read(userLogindataProvider).whenData((logindata) {
      String callId = const Uuid().v1();

      VideoCall senderData = VideoCall(
          callerId: auth.currentUser!.uid,
          callerName: logindata!.name.toString(),
          callerPic: logindata.photoUrl.toString(),
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: true,
          timeSent: DateTime.now()
      );

      VideoCall receiverData = VideoCall(
          callerId: auth.currentUser!.uid,
          callerName: logindata.name.toString(),
          callerPic: logindata.photoUrl.toString(),
          receiverId: receiverUid,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: false,
          timeSent: DateTime.now()
      );

      if (isGroupChat) {
        videoCallClass.startGroupCall(
          senderData,
          receiverData,
          context,
        );
      } else {
        videoCallClass.startCall(
          context,
          senderData,
          receiverData,
        );
      }
    });
  }

  void endCall(String callerId,
      String receiverId,
      BuildContext context,
      {bool isGroupChat = false}) {

    if (isGroupChat) {
      print("Call == Group");
      videoCallClass.endGroupCall(
        callerId,
        receiverId,
        context,
      );
    } else {
      print("Call == Normal");

      videoCallClass.endCall(
        callerId,
        receiverId,
        context,
      );
    }
  }
}
