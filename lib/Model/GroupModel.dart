class GroupModel {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final DateTime timeSent;
  final List<String> members;
  final List<String> members_name;

  GroupModel({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.timeSent,
    required this.members,
    required this.members_name,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'members': members,
      'members_name' : members_name
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      members: List<String>.from(map['members']),
      members_name: List<String>.from(map['members_name']),
    );
  }
}
