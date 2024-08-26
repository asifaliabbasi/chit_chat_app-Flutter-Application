import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:chit_chat_app/models/chat_user.dart';
import 'package:flutter/material.dart';

class ViewUserProfile extends StatefulWidget {
  const ViewUserProfile({super.key, required this.user});
  final ChatUser user;
  @override
  State<ViewUserProfile> createState() => _ViewUserProfileState();
}

class _ViewUserProfileState extends State<ViewUserProfile> {
  late Size mq = MediaQuery.of(context).size;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(),
      ),floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Joined On : ',style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w500),),
        Text(MyDateUtil.getLastMessageTime(context: context, time: widget.user.createdAt,showYear: true),
          style: TextStyle(color: Colors.black45, fontSize: 15,),
        ),],
    ),
      body:  Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.height * .05),
          child: SingleChildScrollView(
            child: Column(
              children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .2),
                    child:CachedNetworkImage(
                      width: mq.height * .2,
                      height: mq.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.person),
                    ),
                  ),

                SizedBox(
                  width: mq.width,
                  height: mq.height * .05,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(color: Colors.black, fontSize: 18,),
                ),
                SizedBox(
                  width: mq.width,
                  height: mq.height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('About : ',style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.w500),),
                    Text(
                    '${widget.user.about}',
                    style: TextStyle(color: Colors.black45, fontSize: 18,),
                  ),],
                )



              ],
            ),
          ),
        ),
    );

  }
}
