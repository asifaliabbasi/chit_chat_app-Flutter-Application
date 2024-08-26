import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/Pages/UserProfile.dart';
import 'package:chit_chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialogs extends StatelessWidget {
  const ProfileDialogs({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(width:MediaQuery.of(context).size.width * .6 , height: MediaQuery.of(context).size.height * .35,
      child: Stack(
        children: [
          
          Align(
            alignment: Alignment.center,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .25),
              child:CachedNetworkImage(
                height: MediaQuery.of(context).size.width * .5,
                fit: BoxFit.cover,
                imageUrl: user.image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.person),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * .04,
              top: MediaQuery.of(context).size.height * .02,
              width: MediaQuery.of(context).size.width * .55,
              child: Text(user.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize:16 ),)),
          Positioned(
              right:8,
              top: 6,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUserProfile(user: user),));
                }, icon: Icon(Icons.info_outline,size: 30, color: Colors.blue,)),
              ))
        ],
      ),),
    );
  }
}
