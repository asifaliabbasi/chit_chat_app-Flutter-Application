import 'package:chit_chat_app/APIs/FirebaseAPIs.dart';
import 'package:chit_chat_app/Pages/Profile_screen.dart';
import 'package:chit_chat_app/Widgets/ChatUserCard.dart';
import 'package:chit_chat_app/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  _signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();

    //for setting user status to active


    //for updating user active status
    SystemChannels.lifecycle.setMessageHandler((message){
      if(APIs.auth.currentUser != null){
      if(message.toString().contains('pause')){
        APIs.UpdateActiveStatus(false);
      }
      if(message.toString().contains('resume')){
        APIs.UpdateActiveStatus(true);
      }}
      return Future.value(message);
    });
  }

  late Size mq = MediaQuery.of(context).size;
  List<ChatUser> list = [];
  final List<ChatUser> _searchList =[];
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //for hiding keyboard
      onTap: ()=> FocusScope.of(context).unfocus,
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
          }
          else{
            return Future.value(true);
          }
          return Future.value(false);
        },
        child: Scaffold(
          //appbar
          appBar: AppBar(
            title:_isSearching? TextField(
              autofocus: true,
              onChanged: (val){
                //search Logic
                _searchList.clear();
                for(var i in list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
        
              },
              style: TextStyle(fontSize: 17, letterSpacing: 1),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name, Email",
              ),
            ):Text(
              "ChitChat",
              style: TextStyle(color: Colors.black),
            ),
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.black,
            ),
            actions: [
              //Search Button
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
              //More Options Button
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(user: APIs.currUser),
                        ));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          //Add Contacts Button
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                widget._signout();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
         body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];
                    if (list.isNotEmpty) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ChatUserCard(user:_isSearching?_searchList[index] : list[index]);
                        },
                        itemCount:_isSearching? _searchList.length : list.length,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: mq.height * .01),
                      );
                    } else {
                      return Center(
                          child: Text(
                        "No User Found",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                      ));
                    }
                }
              }),
        ),
      ),
    );
  }
}
