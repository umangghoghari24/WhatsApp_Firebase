import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Enum/Enum1.dart';
import '../../../Model/ChatContactModel.dart';
import '../../../Model/GroupModel.dart';
import '../../../Model/MessageModel.dart';
import '../../auth/controller/AuthController.dart';
import '../Class/ChatClass.dart';

final chatClassControllerProvider = Provider((ref) {
  final chatClass = ref.read(chatClassProvider);
  return ChatClassController(
    chatClass: chatClass,
    ref: ref,
  );
});

class ChatClassController {
  final ChatClass chatClass;
  final ProviderRef ref;

  ChatClassController({
    required this.chatClass,
    required this.ref,
  });

  void sendTextmessage({
    required BuildContext context,
    required String message,
    required String reciveruid,
    required bool isGroup,


  }) {
    ref.read(userLogindataProvider).whenData((senderUserdata) {
      chatClass.sendTextmessage(
        context: context,
        message: message,
        reciveruid: reciveruid,
        senderUserdata: senderUserdata!,
        isGroup: isGroup,

      );
    });
  }

  void sendGifmessage({
    required BuildContext context,
    required String gifurl,
    required String reciveruid,
    required bool isGroup,

  }) {
    int gifUrlPartIndex = gifurl.lastIndexOf('-') + 1;
    String gifUrlPart = gifurl.substring(gifUrlPartIndex);
    String newgifurl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userLogindataProvider).whenData((senderUserdata) {
      chatClass.sendGifmessage(
          context: context,
          gifurl: newgifurl,
          reciveruid: reciveruid,
          senderUserdata: senderUserdata!,
          isGroup: isGroup,

      );
      });
    }

  void sendFilemessage({
    required BuildContext context,
    required File file,
    required String reciveruid,
    required MessageEnum messageEnum,
    required bool isGroup,

  }) {
    ref.read(userLogindataProvider).whenData((senderUserdata) {
      chatClass.sendFilemessage(
        context: context,
        file: file,
        reciveruid: reciveruid,
        senderUserdata: senderUserdata!,
        ref: ref,
        messageEnum: messageEnum,
        isGroup: isGroup,
      );
    });
  }

  Stream<List<ChatContactModel>> getChatcontacts() {
    return chatClass.getChatcontacts();
  }

  Stream<List<MessageModel>> getMessages(String reciveruid) {
    return chatClass.getMessages(reciveruid);
    }

  Stream<List<GroupModel>> getGroups() {
    return chatClass.getGroups();
  }
  Stream<List<MessageModel>> getGroupMessages(String groupId) {
    return chatClass.getGroupMessages(groupId);
  }

}

