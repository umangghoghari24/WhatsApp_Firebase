class GroupContactModel {
  final String name;
  final String profilePic;
   bool isselected ;
   final String phones;

  GroupContactModel({
    required this.name,
    required this.profilePic,
    required this.isselected,
    required this.phones,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'isselected': isselected,
      'phones' : phones,
    };
  }

  factory GroupContactModel.fromMap(Map<String, dynamic> map) {
    return GroupContactModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isselected: map['isselected'],
      phones: map['phones'],
    );
  }
}

