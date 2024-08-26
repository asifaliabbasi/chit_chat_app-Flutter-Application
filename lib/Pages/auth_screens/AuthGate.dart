import 'package:chit_chat_app/Pages/auth_screens/LoginScreen.dart';
import 'package:chit_chat_app/Pages/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authGate extends StatefulWidget {
  const authGate({super.key});

  @override
  State<authGate> createState() => _authGateState();
}

class _authGateState extends State<authGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
          if (snapshot.hasData){
            return HomeScreen();
          }
          else{
            return LoginScreen();
          }
        },)
    );
  }
}
