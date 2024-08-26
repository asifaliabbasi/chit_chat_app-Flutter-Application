class Message {
  Message({
    required this.fromID,
    required this.toID,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
  });
  late String fromID;
  late String toID;
  late String msg;
  late String read;
  late String sent;
  late Type type;

  Message.fromJson(Map<String, dynamic> json){
    fromID = json['fromID'].toString();
    toID = json['toID'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    sent = json['sent'].toString();
    type = json['type'].toString()== Type.image.name?Type.image: Type.text;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['fromID'] = fromID;
    data['toID'] = toID;
    data['msg'] = msg;
    data['read'] = read;
    data['sent'] = sent;
    data['type'] = type.name;
    return data;
  }


}

enum Type{text,image}