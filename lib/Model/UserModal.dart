 class UserModel{

    String? name;
    String ? uid;
    String ? photoUrl;
    bool isOnline = true;
    String ? phoneNumber;
    List ? groupId;

    UserModel({
        this.name,
        this.uid,
        this.photoUrl,
        this.isOnline = true,
        this.phoneNumber,
        this.groupId
 });

    UserModel.fromJson(Map<String, dynamic> json)
        : name = json['name'],
            uid = json['uid'],
          photoUrl = json['photoUrl'],
          isOnline = json['isOnline'],
          phoneNumber = json['phoneNumber'],
          groupId = json['groupId'];

    Map<String, dynamic> toJson() => {
        'name' : name,
        'uid' : uid,
        'photoUrl' : photoUrl,
        'isOnline' : isOnline,
        'phoneNumber': phoneNumber,
        'groupId' : groupId,
    };
 }


