// // ignore_for_file: use_build_context_synchronously
//
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_contacts/contact.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../../Model/GroupModel.dart';
// import '../../../Model/VideoCall.dart';
// import '../../../commen/utils.dart';
// import '../Views/CallScreen.dart';
//
// final videocallClassProvider = Provider(
//       (ref) => VideoCallClass(
//     firestore: FirebaseFirestore.instance,
//     auth: FirebaseAuth.instance,
//     ref: ref,
//   ),
// );
//
// class VideoCallClass {
//   final FirebaseFirestore firestore;
//   final FirebaseAuth auth;
//   final ProviderRef ref;
//   VideoCallClass({
//     required this.firestore,
//     required this.auth,
//     required this.ref,
//   });
//
//   Stream<DocumentSnapshot> get callstream =>
//       firestore.collection("videocalls").doc(auth.currentUser!.uid).snapshots();
//
//   void startCall(
//       BuildContext context,
//       VideoCall senderData,
//       VideoCall receiverData,
//       ) async {
//     try {
//       //
//       await firestore.collection('videocalls').doc(senderData.callerId).set(
//         senderData.toMap(),
//       );
//       await firestore.collection('videocalls').doc(senderData.receiverId).set(
//         receiverData.toMap(),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallScreen(
//             channelId: senderData.callId,
//             videoCall: senderData,
//             isGroupChat: false,
//           ),
//         ),
//       );
//       //
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         message: e.toString(),
//       );
//     }
//   }
//
//   void endCall(
//       String callerId,
//       String receiverId,
//       BuildContext context,
//       ) async {
//     try {
//       await firestore.collection('videocalls').doc(callerId).delete();
//       await firestore.collection('videocalls').doc(receiverId).delete();
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         message: e.toString(),
//       );
//     }
//   }
//
//   void startGroupCall(
//       VideoCall senderCallData,
//       VideoCall receiverCallData,
//       BuildContext context,
//       ) async {
//     try {
//       await firestore
//           .collection('videocalls')
//           .doc(senderCallData.callerId)
//           .set(senderCallData.toMap());
//
//       var groupSnapshot = await firestore
//           .collection('groups')
//           .doc(senderCallData.receiverId)
//           .get();
//       GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);
//
//       for (var id in group.members) {
//         await firestore
//             .collection('videocalls')
//             .doc(id)
//             .set(receiverCallData.toMap());
//       }
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallScreen(
//             channelId: senderCallData.callId,
//             videoCall: senderCallData,
//             isGroupChat: true,
//           ),
//         ),
//       );
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         message: e.toString(),
//       );
//     }
//   }
//
//   void endGroupCall(
//       String callerId,
//       String receiverId,
//       BuildContext context,
//       ) async {
//     try {
//       await firestore.collection('videocalls').doc(callerId).delete();
//       var groupSnapshot =
//       await firestore.collection('groups').doc(receiverId).get();
//       GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);
//       for (var id in group.members) {
//         await firestore.collection('videocalls').doc(id).delete();
//       }
//     } catch (e) {
//       showSnackBar(
//         context: context,
//         message: e.toString(),
//       );
//     }
//   }
// }
