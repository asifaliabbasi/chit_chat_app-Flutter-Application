import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:chit_chat_app/models/message.dart';
import 'package:flutter/cupertino.dart';
// import 'package:googleapis/androidpublisher/v3.dart';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';


import '../APIs/FirebaseAPIs.dart';
import '../APIs/PushNotification.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late Size mq = MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {
    bool isme =APIs.auth.currentUser!.uid == widget.message.fromID;
    return  InkWell(
      onLongPress: (){
        _showBottomSheet(isme);
      },
      child: isme ? _greenMessage()
        : _blueMessage(),);


  }


Widget _blueMessage() {

    //update last seen message
  if(widget.message.read.isEmpty){
    APIs.updateMessageReadStatus(widget.message);
  }

  return Row(

    children: [
      Flexible(
        child: Container( padding: EdgeInsets.all(widget.message == Type.text ?mq.width * 0.03: mq.width *.025),
          margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height*.01),
          decoration:BoxDecoration(
            color: Colors.blueAccent.shade100,
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20), bottomRight: Radius.circular(20))
          ),

          child: widget.message.type == Type.text ?
          Text(widget.message.msg,style: const TextStyle(fontSize: 15,color:Colors.black87),):
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child:CachedNetworkImage(
              width: mq.height * .25,
              height: mq.height * .3,
              fit: BoxFit.cover,
              imageUrl: widget.message.msg,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:80,vertical: 100),
                      child:CircularProgressIndicator(strokeWidth: 3,value:downloadProgress.progress,)),
              errorWidget: (context, url, error) => Icon(Icons.image,size: 70,),
            ),
          ),
        ),
      ),
         SizedBox(width: 10,),
      Text(MyDateUtil.getFormatedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 12,color:Colors.black),)
    ],
  );
}

Widget _greenMessage() {

  return Row(
    mainAxisAlignment: MainAxisAlignment.end,

    children: [
      if(widget.message.read.isNotEmpty)
        Icon(Icons.done_all,color: Colors.blue,),

      Text(MyDateUtil.getFormatedTime(context: context, time: widget.message.sent),style: TextStyle(fontSize: 12,color:Colors.black),),
       SizedBox(width: 10,),

      Flexible(
        child: Container(
          padding: EdgeInsets.all(widget.message == Type.text ? mq.width * 0.3 : mq.width * .025 ),
          margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height*.01),
          decoration:BoxDecoration(
              color: Colors.green.shade300,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.only( topLeft: Radius.circular(15),topRight: Radius.circular(15), bottomLeft: Radius.circular(15))
          ),

          child:widget.message.type == Type.text ?
          Text(widget.message.msg,style: const TextStyle(fontSize: 15,color:Colors.black87),):
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child:CachedNetworkImage(
              width: mq.height * .25,
              height: mq.height * .3,
              fit: BoxFit.cover,
              imageUrl: widget.message.msg,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal:80,vertical: 100),
                      child:CircularProgressIndicator(strokeWidth: 3,value:downloadProgress.progress,)),
              errorWidget: (context, url, error) => Icon(Icons.image,size: 70,),
            ),
          ),
        ),
      ),

    ],
  );
}



  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children:[
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: mq.height*.015, horizontal:mq.width*.4 ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey

                ),
              ),

           widget.message.type ==Type.text ? OptionItems(icon: Icon(Icons.copy_all,color: Colors.blueAccent,size: 26,), name: 'Copy Text', onTap: () async {
             await Clipboard.setData(ClipboardData(text: widget.message.msg)).then((value) {
               Navigator.pop(context);
               Dailogs.showSnackbar(context, "Text Copied");
             },);
           })
: OptionItems(icon: Icon(Icons.download_rounded,color: Colors.blueAccent,size: 26,), name: 'Save Image', onTap: (){
                _saveImage();
                Navigator.pop(context);
           }),

          if(isMe)
          Divider(
              color: Colors.black54,
              endIndent: mq.width * .04,
              indent: mq.width * .04,
            ),

              if(widget.message.type == Type.text && isMe) OptionItems(icon: Icon(Icons.edit,color: Colors.blueAccent,size: 26,), name: 'Edit Message', onTap: (){}),
              if(isMe)OptionItems(icon: const Icon(Icons.delete_forever,color: Colors.red,size: 26,), name: 'Delete Message', onTap: () async {

                await APIs.deleteMessage(widget.message).then((value) {
                 Navigator.pop(context);
               },);
              }),
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
              OptionItems(icon: Icon(Icons.remove_red_eye,color: Colors.blueAccent,), name: 'Sent At : ${MyDateUtil.getSentTime(context: context, time: widget.message.sent)}', onTap: (){}),

              OptionItems(icon: const Icon(Icons.remove_red_eye_outlined,color: Colors.green,), name: widget.message.read.isEmpty ? "Read At : Not seen yet" :
              'Read At : ${MyDateUtil.getSentTime(context: context, time: widget.message.read)}', onTap: (){}),

            ],
          );
        });
  }
  _saveImage() async {
    var response = await http.get(Uri.parse(widget.message.msg));
    Directory documentDirectory =
        await getApplicationDocumentsDirectory();
    File file = new File(
        path.join(documentDirectory.path, path.basename(widget.message.msg)));
    await file.writeAsBytes (response.bodyBytes);
    showDialog(context: context, builder: (BuildContext context) => AlertDialog(
      title: Text("Image saved Successfully!"),

      content: Image.file(file),));
  }

}

class OptionItems extends StatelessWidget {
  OptionItems({required this.icon,required this.name,required this.onTap});
final Icon icon;
final String name;
final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*.05,
        top:  MediaQuery.of(context).size.height*.015,
        bottom:  MediaQuery.of(context).size.height*.02),
        child: Row(
          children: [
           icon,
            Flexible(child: Text('    ${name}',style: TextStyle(fontSize: 15,color: Colors.black45,letterSpacing: .5),))
          ],
        ),
      ),
    );
  }

}


