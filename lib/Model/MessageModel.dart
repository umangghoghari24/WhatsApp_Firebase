import 'package:firebaseconnection/Enum/Enum1.dart';

class MessageModel {
  final String senderId;
  final String reciverId;
  final String message;
  final MessageEnum type;
  final DateTime time;
  final String messageId;
  final bool isSeen;

  MessageModel({
    required this.senderId,
    required this.reciverId,
    required this.message,
    required this.type,
    required this.time,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverId': reciverId,
      'message': message,
      'type': type.type,
      'time': time.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
        senderId: map['senderId'],
        reciverId: map['reciverId'],
        message: map['message'],
        type: (map['type'] as String).toEnum(),
        time: DateTime.fromMillisecondsSinceEpoch(map['time']),
        messageId: map['messageId'],
        isSeen: map['isSeen'],
        );
    }
}
