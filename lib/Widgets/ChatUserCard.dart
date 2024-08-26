import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/Pages/ChatScreen.dart';
import 'package:chit_chat_app/Widgets/profile_Dialogs.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:chit_chat_app/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../APIs/FirebaseAPIs.dart';
import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  ChatUserCard({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  late Size mq = MediaQuery.of(context).size;

  //last message info
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chatscreen(
                    user: widget.user,
                  ),
                ));
          },
          child: StreamBuilder(
              stream: APIs.getLastMessage(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (list.isNotEmpty) {
                  _message = list[0];
                }

                return ListTile(
                    title: Text("${widget.user.name}"),
                    subtitle: Text(
                      _message != null ?
                      _message!.type == Type.image?
                          "🖼️ Image":
                      _message!.msg : widget.user.about,
                      maxLines: 1,
                    ),
                    leading: InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (_) => ProfileDialogs(user: widget.user));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .3),
                        child: CachedNetworkImage(
                          width: mq.height * .055,
                          height: mq.height * .055,
                          imageUrl: widget.user.image,
                          errorWidget: (context, url, error) =>
                              CircleAvatar(child: Icon(Icons.person)),
                        ),
                      ),
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.isEmpty &&
                                _message!.fromID != APIs.auth.currentUser!.uid
                            ? Icon(Icons.mark_chat_unread)
                            : Text(MyDateUtil.getLastMessageTime(context: context, time: _message!.sent)));
              })),
    );
  }
}
