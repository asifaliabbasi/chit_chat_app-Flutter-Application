import 'dart:io';
import 'package:chit_chat_app/Pages/UserProfile.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/APIs/FirebaseAPIs.dart';
import 'package:chit_chat_app/Pages/MessageCard.dart';
import 'package:chit_chat_app/models/chat_user.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_emoji_picker/keyboard_emoji_picker.dart';

import '../models/message.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.user});
  final ChatUser user;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  List<Message>_list=[];
  bool _isuploading = false;
  ChatUser curruser = APIs.currUser;
  final TextEditingController _textController = TextEditingController();
  bool _showEmoji = false;
  late Size mq  = MediaQuery.of(context).size;
  @override

  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
              appBar:AppBar(
                backgroundColor: const Color.fromARGB(255, 234, 248, 255),
                  leading: BackButton(),
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUserProfile(user: widget.user,),));
                      },
                      child: StreamBuilder (stream:APIs.getUserUpdateInfo(widget.user) ,builder: (context, snapshot){
                        final data = snapshot.data?.docs;
                        final list =
                            data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

                        return Row(
                          children: [
                            SizedBox(width: 50,),//user Profile Picture
                            ClipRRect(
                              borderRadius: BorderRadius.circular(mq.height * .3),
                              child: CachedNetworkImage(
                                width: mq.height * .055,
                                height: mq.height * .055,
                                imageUrl: list.isNotEmpty? list[0].image : widget.user.image,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => CircleAvatar(child: Icon(Icons.person)),
                              ),
                            ),
                            SizedBox(width: 15,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( list.isNotEmpty ? list[0].name:
                                  widget.user.name,style: TextStyle(fontSize: 17, color: Colors.black54, fontWeight: FontWeight.w500),),
                                Text(
                                    list.isNotEmpty ?
                                    list[0].isOnline ? 'Online':
                                    MyDateUtil.getLastActiveTime(context: context, lastActive:list[0].lastActive):
                                    MyDateUtil.getLastActiveTime(context: context, lastActive: widget.user.lastActive)),
                              ],
                            )
                          ],
                        );
                      },)
                    ),
                  ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: APIs.getAllMessages(widget.user),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                            case ConnectionState.none:
                              return const SizedBox(

                              );
                            case ConnectionState.active:
                            case ConnectionState.done:
                              final data = snapshot.data?.docs;
                              _list = data?.map((e) => Message.fromJson(e.data())).toList() ??
                                  [];


                          if (_list.isNotEmpty) {
                                return ListView.builder(
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index],);
                                  },
                                  itemCount:_list.length,

                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(top: mq.height * .01),
                                );
                              } else {
                                return Center(
                                    child: Text(
                                      "Say Hi to 👋 ${widget.user.name}",
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                    ));
                              }
                          }
                        }),
                  ),

                 //progress indicator if something is uploading
                 if(_isuploading)
                 const Align(
                    alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 16),
                        child: CircularProgressIndicator(color: Colors.blueAccent,),
                      )),
                  _chatInput(),

    // SizedBox(height: 380,
    // child:emojiSelect())
    //               if(_showEmoji)
    //               SizedBox(
    //                 height: mq.height * .35,
    //                 child:
    //
    // EmojiPicker(
    // textEditingController: _textController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
    // config: Config(
    // height: 256,
    // checkPlatformCompatibility: true,
    // emojiViewConfig: EmojiViewConfig(
    // // Issue: https://github.com/flutter/flutter/issues/28894
    // emojiSizeMax: 28 *
    // (foundation.defaultTargetPlatform == TargetPlatform.iOS
    // ?  1.20
    //     :  1.0),
    // ),
    // swapCategoryAndBottomBar:  false,
    // skinToneConfig: const SkinToneConfig(),
    // categoryViewConfig: const CategoryViewConfig(),
    // bottomActionBarConfig: const BottomActionBarConfig(),
    // searchViewConfig: const SearchViewConfig(),
    // ),
    // )
    //
    // ),

                ],
              ),
      ),
    );
  }

  // Widget _appBar() {
  //   return
  // }
  Widget _chatInput(){
    return Padding(

      padding: EdgeInsets.symmetric(horizontal: mq.width * .03,vertical: mq.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  // IconButton(onPressed: (){
                  //   // setState(() {
                  //   //   _showEmoji = ! _showEmoji;
                  //   // });
                  // }, icon: Icon(Icons.emoji_emotions,size: 26,)),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Say Hello to ${widget.user.name}",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () async {
                    setState(() {
                      _isuploading = true;
                    });

                    final ImagePicker picker = ImagePicker();

                    //for picking multiple images
                    final List<XFile> images = await picker.pickMultiImage(imageQuality: 100);
                    for(var i in images){
                      APIs.sendChatImage(widget.user, File(i.path)).then((value) {
                        setState(() {
                          _isuploading = false;
                        });
                      },);
                    }
                  }, icon: Icon(Icons.image,size: 26,)),
                  IconButton(onPressed: ()async{

                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 100);
                    if(image != null) {
                      setState(() {
                        _isuploading = true;
                      });
                      APIs.sendChatImage(widget.user, File(image.path));
                      setState(() {
                        _isuploading = false;
                      });
                    }
                  }, icon: Icon(Icons.camera,size: 26,))
                , SizedBox(width: mq.width * .02,)
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send,size: 25,),
            onPressed: (){
              if(_textController.text .isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text,Type.text);
                _textController.text = "";
              }
            }, )
        ],
      ),
    );
  }




}
