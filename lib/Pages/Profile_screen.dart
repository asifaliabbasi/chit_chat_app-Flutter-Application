import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chit_chat_app/APIs/FirebaseAPIs.dart';
import 'package:chit_chat_app/Pages/auth_screens/LoginScreen.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});
  _signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Size mq = MediaQuery.of(context).size;
  var bgColor=Colors.transparent;
  var color = Colors.transparent;
  bool _istransparetn = true;
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        //appbar
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
          leading: BackButton(),
        ),
        //Add Contacts Button
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dailogs.showProgressBar(context);
              await APIs.UpdateActiveStatus(false);
              widget._signout().then(
                (value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  APIs.auth = FirebaseAuth.instance;
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
              );
            },
            icon: Icon(Icons.logout),
            label: Text("Logout"),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.height * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: mq.height * 1,
                      child:LinearProgressIndicator(
                        semanticsValue: APIs.progress.toString(),
                        minHeight: mq.width * .01,
                        color: _istransparetn ? color : Colors.blueAccent,
                        backgroundColor:bgColor,
                      )
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  Stack(children: [
                    _image != null ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .2),
                      child: Image.file(
                        File(_image!),
                        width: mq.height * .2,
                        height: mq.height * .2,
                        fit: BoxFit.cover,
                      ),
                    ):
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
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        child: Icon(Icons.edit),
                        shape: CircleBorder(),
                        color: Colors.white,
                      ),
                    )
                  ]),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.currUser.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.name,
                    decoration: InputDecoration(
                        label: Text("Name"),
                        prefixIcon: const Icon(Icons.account_circle),
                        hintText: "eg. Mr Abc",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              width: 9,
                              color: Colors.blueAccent,
                            ))),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  TextFormField(
                    onSaved: (val) => APIs.currUser.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    initialValue: widget.user.about,
                    decoration: InputDecoration(
                        label: Text("About"),
                        prefixIcon: const Icon(Icons.insert_emoticon),
                        hintText: "eg. Feeling Happy",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              width: 9,
                              color: Colors.blueAccent,
                            ))),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .05,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                       if (_formKey.currentState!.validate()) {
                         _formKey.currentState!.save();
                         APIs.updateUserInfo().then((value) {
                           Dailogs.showSnackbar(context, 'Profile Info Updated');
                         },);
                       }



                    },
                    label: const Text("UPDATE",
                        style: TextStyle(color: Colors.black, fontSize: 17)),
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                  ),SizedBox(height: 40,),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Bottom Sheet for picking Picture
  void _showBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: mq.height * .03,bottom: mq.height * .05),
            children:[
              const Text("Pick Profile Picture",textAlign: TextAlign.center,style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
              ,const SizedBox(height: 20,)
              ,Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize: Size(mq.width * .3,  mq.height * .15)
                    ),
                      onPressed: () async {
                      _istransparetn = false;
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
                      if(image != null) {
                        setState(() {
                          _image = image.path;
                        });
                        APIs.updateProfilePicture(File(_image!)).then((value){
                          setState(() {
                            _istransparetn = true;

                              Dailogs.showSnackbar(
                                context, "Profile Picture Updated Successfully");});
                          },


                        );

                        Navigator.pop(context);
                      }
                      }, child: Image.asset("images/Add from Gallery.jpg") ),
          ElevatedButton(
          style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: Colors.white,
          fixedSize: Size(mq.width * .3,  mq.height * .15)
          ),
          onPressed: () async {
           _istransparetn = false;
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 100);
           if(image != null) {
          setState(() {
         _image = image.path;
           });
          APIs.updateProfilePicture(File(_image!)).then(
                (value) {
                  setState(() {
                    _istransparetn = true;

              Dailogs.showSnackbar(
                  context, "Profile Picture Updated Successfully"); });


          },
          );
          Navigator.pop(context);
           }
            }, child: Image.asset("images/Camera Icon.jpg")
          )],
              )
            ],
          );
        });
  }
}
