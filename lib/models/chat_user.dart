class ChatUser {
  ChatUser({
    required this.id,
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.lastActive,
    required this.isOnline,
    required this.email,
    required this.pushToken,
  });
  late  String image;
  late  String about;
  late  String name;
  late  String createdAt;
  late  String lastActive;
  late  bool isOnline;
  late  String email;
  late  String pushToken;
  late  String id;

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image'].toString() ;
    about = json['about'] ;
    name = json['name'];
    createdAt = json['created_at'] ;
    lastActive = json['last_active'];
    isOnline = json['is_online'] ;
    email = json['email'] ?? "";
    pushToken = json['push_token'] ;
    id = json['id'] ;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['id']= id;
    return data;
  }
}