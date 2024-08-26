import 'dart:async';

import 'package:chit_chat_app/Pages/auth_screens/AuthGate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => authGate(),));
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,statusBarColor: Colors.white
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Image.asset("images/Logo (1).png"),
          RichText(text: TextSpan(
            style: TextStyle(color: Colors.black),
              children: [
              TextSpan(text: "ChitChat ",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                TextSpan(text: "with Your buddies",style: TextStyle(fontSize: 25)),
            ]
          )),

        ],
      ),
    );
  }
}

