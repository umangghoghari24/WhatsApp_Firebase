import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/GroupContact.dart';
import '../class/GroupClass.dart';

final groupClasscontrollerProvider = Provider(
      (ref) => GroupClassController(
    groupClass: ref.read(groupClassProvider),
    ref: ref,
  ),
);

class GroupClassController {
  final GroupClass groupClass;
  final ProviderRef ref;

  GroupClassController({
    required this.groupClass,
    required this.ref,
  });

  void createGroup(
      BuildContext context,
      String name,
      File profilePic,
      List<GroupContactModel> selectedContact,
      ) {
    groupClass.createGroup(
      context,
      name,
      profilePic,
      selectedContact,
    );
  }
}
