import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../Enum/Enum1.dart';
import '../../../Model/ChatContactModel.dart';
import '../../../Model/GroupModel.dart';
import '../../../Model/MessageModel.dart';
import '../../../Model/UserModal.dart';
import '../../../commen/utils.dart';
import '../../auth/class/FirebaseStorage.dart';

final chatClassProvider = Provider((ref) {
  return ChatClass(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
});

class ChatClass {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatClass({
    required this.firestore,
    required this.auth,
  });

  //for contacts sub collections
  void _savechattoContact(
      UserModel senderUserdata,
      UserModel? recieverUserData,
      String lastMessage,
      DateTime timeSent,
      String reciveruid,
      bool isGroup,
      ) async {
    //for sender
    // var recieverChatdata = ChatContactModel(
    //   name: senderUserdata.name!,
    //   profilePic: senderUserdata.photoUrl!,
    //   contactId: senderUserdata.uid!,
    //   timeSent: timeSent,
    //   lastMessage: lastMessage,
    // );
    // await firestore
    //     .collection('users')
    //     .doc(reciveruid)
    //     .collection('chats')
    //     .doc(auth.currentUser?.uid)
    //     .set(
    //   recieverChatdata.toMap(),
    // );
    //
    // //for reciver
    // var senderchatdata = ChatContactModel(
    //   name: recieverUserData.name!,
    //   profilePic: recieverUserData.photoUrl!,
    //   contactId: recieverUserData.uid!,
    //   timeSent: timeSent,
    //   lastMessage: lastMessage,
    // );
    // await firestore
    //     .collection('users')
    //     .doc(auth.currentUser?.uid)
    //     .collection('chats')
    //     .doc(reciveruid)
    //     .set(
    //   senderchatdata.toMap(),
    // );
    if (isGroup) {
      print('part 1..');
      await firestore.collection('groups').doc(reciveruid).update({
        'lastMessage': lastMessage,
        'timeSent': DateTime.now().microsecondsSinceEpoch,
      });
    } else {
      print('part 2..');
      //for sender
      var recieverChatdata = ChatContactModel(
        name: senderUserdata.name!,
        profilePic: senderUserdata.photoUrl!,
        contactId: senderUserdata.uid!,
        timeSent: timeSent,
        lastMessage: lastMessage,
      );
      await firestore
          .collection('users')
          .doc(reciveruid)
          .collection('chats')
          .doc(auth.currentUser?.uid)
          .set(
        recieverChatdata.toMap(),
      );

      //for reciver
      var senderchatdata = ChatContactModel(
        name: recieverUserData!.name!,
        profilePic: recieverUserData!.photoUrl!,
        contactId: recieverUserData.uid!,
        timeSent: timeSent,
        lastMessage: lastMessage,
      );
      await firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('chats')
          .doc(reciveruid)
          .set(
        senderchatdata.toMap(),
      );
    }
  }

  void _savechattoMessage({
    required String reciveruid,
    required String message,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required recieverUsername,
    required MessageEnum type,
    required bool isGroup,
  }) async {

    // message model

    final messageModel = MessageModel(
      senderId: auth.currentUser!.uid,
      reciverId: reciveruid,
      message: message,
      type: type,
      time: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    // for sender

  //   await firestore
  //       .collection('users')
  //       .doc(auth.currentUser?.uid)
  //       .collection('chats')
  //       .doc(reciveruid)
  //       .collection('messages')
  //       .doc(messageId)
  //       .set(
  //     messageModel.toMap(),
  //   );
  //
  //   // for receiver
  //   await firestore
  //       .collection('users')
  //       .doc(reciveruid)
  //       .collection('chats')
  //       .doc(auth.currentUser?.uid)
  //       .collection('messages')
  //       .doc(messageId)
  //       .set(
  //     messageModel.toMap(),
  //   );
  // }

  //text message

    if (isGroup) {
      await firestore
          .collection('groups')
          .doc(reciveruid)
          .collection('chats')
          .doc(messageId)
          .set(
        messageModel.toMap(),
      );
    } else {
      // for sender
      await firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('chats')
          .doc(reciveruid)
          .collection('messages')
          .doc(messageId)
          .set(
        messageModel.toMap(),
      );

      // for receiver
      await firestore
          .collection('users')
          .doc(reciveruid)
          .collection('chats')
          .doc(auth.currentUser?.uid)
          .collection('messages')
          .doc(messageId)
          .set(
        messageModel.toMap(),
      );
    }
  }
  void sendTextmessage({
    required BuildContext context,
    required String message,
    required String reciveruid,
    required UserModel senderUserdata,
    required bool isGroup,
  }) async {
    try {
      var timeSent = DateTime.now();

      // UserModel recieverUserData;
      // var userDataMap =
      // await firestore.collection('users').doc(reciveruid).get();
      // recieverUserData = UserModel.fromJson(
      //   userDataMap.data()!,
      // );
      UserModel? recieverUserData;
      if (!isGroup) {
        var userDataMap =
        await firestore.collection('users').doc(reciveruid).get();
        recieverUserData = UserModel.fromJson(
          userDataMap.data()!,
        );
      }
      //for list outside
      _savechattoContact(
        senderUserdata,
        recieverUserData,
        message,
        timeSent,
        reciveruid,
        isGroup,
      );

      //for list data
      var messageId = const Uuid().v1();

      _savechattoMessage(
        reciveruid: reciveruid,
        message: message,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserdata.name!,
        recieverUsername: recieverUserData?.name,
        type: MessageEnum.text,
        isGroup: isGroup,
      );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }
  //text message
  void sendGifmessage({
    required BuildContext context,
    required String gifurl,
    required String reciveruid,
    required UserModel senderUserdata,
    required bool isGroup,
  }) async {
    try {
      var timeSent = DateTime.now();

      UserModel ? recieverUserData;
      // var userDataMap =
      // await firestore.collection('users').doc(reciveruid).get();
      // recieverUserData = UserModel.fromJson(
      //   userDataMap.data()!,
      // );
      if (!isGroup) {
        var userDataMap =
        await firestore.collection('users').doc(reciveruid).get();
        recieverUserData = UserModel.fromJson(
          userDataMap.data()!,
        );
      }

      //for list outside
      _savechattoContact(
        senderUserdata,
        recieverUserData,
        'GIF',
        timeSent,
        reciveruid,
        isGroup

      );

      //for list data
      var messageId = const Uuid().v1();
      _savechattoMessage(
        reciveruid: reciveruid,
        message: gifurl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserdata.name!,
        recieverUsername: recieverUserData?.name,
        type: MessageEnum.gif,
        isGroup: isGroup,
      );
    } catch (e) {
      showSnackBar(
          context: context,
          message: e.toString(),
          );
     }
    }

  //file message
  void sendFilemessage({


    required BuildContext context,
    required File file,
    required String reciveruid,
    required UserModel senderUserdata,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required bool isGroup,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = Uuid().v1();
      String fileUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
        'chats/${messageEnum.type}/${senderUserdata.uid}/$reciveruid/$messageId',
        file,
      );
      String text;
      switch (messageEnum) {
        case MessageEnum.image:
          text = '📸 Photo';
          break;
        case MessageEnum.audio:
          text = '🎧 Audio';
          break;
        case MessageEnum.video:
          text = '🎥 Video';
          break;
        case MessageEnum.gif:
          text = 'GIF';
          break;
        default:
          text = 'GIF';
      }

      UserModel ? recieverUserData;
      // var userDataMap =
      // await firestore.collection('users').doc(reciveruid).get();
      // recieverUserData = UserModel.fromJson(
      //   userDataMap.data()!,
      // );
      if (!isGroup) {
        var userDataMap =
        await firestore.collection('users').doc(reciveruid).get();
        recieverUserData = UserModel.fromJson(
          userDataMap.data()!,
        );
      }

      //for list outside
      _savechattoContact(
        senderUserdata,
        recieverUserData,
        text,
        timeSent,
        reciveruid,
        isGroup,

      );

      //for message
      _savechattoMessage(
        reciveruid: reciveruid,
        message: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserdata.name.toString(),
        recieverUsername: recieverUserData?.name,
        type: messageEnum,
          isGroup: isGroup,
    );
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  //get chat messages
  Stream<List<ChatContactModel>> getChatcontacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .orderBy('timeSent', descending: true)
        .snapshots()
        .asyncMap((event) async {
      List<ChatContactModel> contacts = [];
      for (var document in event.docs) {
        var chatContactModel = ChatContactModel.fromMap(document.data());
        contacts.add(chatContactModel);
      }
      return contacts;
    });
  }

  //get chat messages for group

  Stream<List<GroupModel>> getGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<GroupModel> groups = [];
      for (var document in event.docs) {
        var groupModel = GroupModel.fromMap(document.data());
        if (groupModel.members.contains(auth.currentUser!.uid)) {
          groups.add(groupModel);
        }
      }
      return groups;
    });
  }

  Stream<List<MessageModel>> getMessages(String reciveruid) {
    return firestore
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('chats')
        .doc(reciveruid)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .asyncMap((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        var messageModel = MessageModel.fromMap(document.data());
        messages.add(messageModel);
      }
      return messages;
      });
    }

  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('time')
        .snapshots()
        .asyncMap((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        var messageModel = MessageModel.fromMap(document.data());
        messages.add(messageModel);
      }
      return messages;
    });
  }

}