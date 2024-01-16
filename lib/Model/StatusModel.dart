import 'package:firebaseconnection/Enum/StatusEnum.dart';

class StatusModel {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrl;
  final DateTime createdAt;
  final String profilePic;
  final String statusId;
  final List<String> text;
  final List<String> type;
  final List<String> whoCanSee;
  final List<int> statusBGcolor;

  StatusModel({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrl,
    required this.createdAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
    required this.text,
    required this.type,
    required this.statusBGcolor,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
      'text' : text,
      'type' : type,
      'statusBGcolor' : statusBGcolor
    };
  }

  factory StatusModel.fromMap(Map<String, dynamic> map) {
    return StatusModel(
        uid: map['uid'] ?? '',
        username: map['username'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        photoUrl: List<String>.from(map['photoUrl']),
        createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
        profilePic: map['profilePic'] ?? '',
        statusId: map['statusId'] ?? '',
        whoCanSee: List<String>.from(map['whoCanSee']),
        type: List<String>.from((map['type'])),
        text: List<String>.from((map['text'] ?? '')),
      statusBGcolor: List<int>.from(map['statusBGcolor']),
     );
    }
}
