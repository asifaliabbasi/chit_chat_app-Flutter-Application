import 'dart:io';
import 'package:chit_chat_app/APIs/FirebaseAPIs.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chit_chat_app/Pages/auth_screens/OTPScreen.dart';
import 'package:chit_chat_app/Pages/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isanimte = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Size mq = MediaQuery.of(context).size;
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 0),(){
      setState(() {
        _isanimte = true;
      });
    });
  }
  _handleGoogleBtnClick(){
    Dailogs.showProgressBar(context);
    _signInWithGoogle().then((user)async {
      Navigator.pop(context);
      if(user != null){
        if((await APIs.userExist())){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        }
        else{
          await APIs.createUser().then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
          });
        }
      }
      
    },);
  }
  Future<UserCredential?>_signInWithGoogle() async{
    try{
      await InternetAddress.lookup('google.com');
    final GoogleSignInAccount ? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication ? googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken
    );
    return await
        FirebaseAuth.instance.signInWithCredential(credential);}
        catch (e){
        Dailogs.showSnackbar(context, "Something Went Wrong (Check Internet)");
        return null;
        }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text(
          "Welcome to ChitChat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned( duration:Duration(seconds: 1),
              width: _isanimte ? mq.width * 1 : -mq.width * 1,  child: Hero(
              tag: "img",
              child: Image.asset("images/Logo (1).png"))),
          Positioned(
            height: mq.height,
            width: mq.width,
            top: mq.height* .44,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: InputDecoration(
                    prefixStyle: TextStyle(color: Colors.black,fontSize: 16),
                    hintText: "  Enter Your Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: mq.height * .53,
            left: 150,
            child: Container(
              child:ElevatedButton(
                onPressed: () async{

                  String phone = phoneController.text.toString();
                  if(phone.isNotEmpty){
                    Dailogs.showProgressBar(context);
                      _auth.verifyPhoneNumber(phoneNumber: phone,verificationCompleted:(PhoneAuthCredential credentail) {
                      }, verificationFailed: (error) {
                        Navigator.pop(context);
                        Dailogs.showSnackbar(context, 'Verification Failed (Please Use Country Code)');
                      }, codeSent: (verificationId, forceResendingToken) {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId),));
                      }, codeAutoRetrievalTimeout: (verificationId) {
                        Dailogs.showSnackbar(context, 'Timeout');
                      },);
                  }
                  else{
                    Dailogs.showSnackbar(context, 'Please Enter Your Phone Number');
                  }


                },
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
              ),
            ),
          ),


          Positioned(
            top: mq.height * .67,
            left: 40,
    child:  InkWell(
    onTap: (){
      _handleGoogleBtnClick();
    },
    child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black,width: 2),
              borderRadius: BorderRadius.circular(7)),
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),

                  child: Row(
                    children: [
                        Container(
                          height: 30,
                          child: Image.asset("images/google.png")),
                    SizedBox(width: 10,),
                    RichText(text: TextSpan(
                      style: TextStyle(
                        color: Colors.black, fontSize: 19,
                      ),
                      children: [
                        TextSpan( text: "Sign In with "),
                        TextSpan(text: "Google", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700))
                      ]
                    )),
                    ],
                  ),
                ),
              )
            ),),
        ],
      ),
    );
  }
}
