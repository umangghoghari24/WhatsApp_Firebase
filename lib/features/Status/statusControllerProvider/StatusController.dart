import 'dart:io';
import 'package:firebaseconnection/Enum/StatusEnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/StatusModel.dart';
import '../../auth/controller/AuthController.dart';
import '../statusClassProvider/StatusClass.dart';

final statusControllerProvider = Provider((ref) {
  final statusClass = ref.read(statusClassProvider);
  return StatusController(
    statusClass: statusClass,
    ref: ref,
  );
});

class StatusController {
  final StatusClass statusClass;
  final ProviderRef ref;

  StatusController({
    required this.statusClass,
    required this.ref,
  });

  void uploadStatus({
    required File statusImage,
    required BuildContext context,
    required String type,
    String text = '',
    required int statusBGcolor,
  }) {
    ref.watch(userLogindataProvider).whenData((logindata) {
      statusClass.uploadStatus(
        username: logindata!.name.toString(),
        profilePic: logindata.photoUrl.toString(),
        phoneNumber: logindata.phoneNumber.toString(),
        statusImage: statusImage,
        context: context,
        type: type,
        text: text,
          statusBGcolor: statusBGcolor
      );
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statuses = await statusClass.getStatus(context);
    // print(statuses);
    return statuses;
    }
}
