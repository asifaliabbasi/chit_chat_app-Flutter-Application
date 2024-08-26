import 'package:chit_chat_app/Pages/homeScreen.dart';
import 'package:chit_chat_app/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key,required this.verificationId});
  final verificationId;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Size mq = MediaQuery.of(context).size;
  TextEditingController OtpController = TextEditingController();
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
              Positioned(
                  width: mq.width * 1, child: Image.asset("images/Logo (1).png")),
              Positioned(
                top: mq.height * .0,
                  left: mq.width * .1,
                  child: Column(
                    children: [
                      Text("OTP", style: TextStyle(fontWeight: FontWeight.w700),),
                      Text("We have sent a 6 digit code to Your Phone Number")
                    ],
                  )),
              Positioned(
                height: mq.height,
                width: mq.width,
                top: mq.height * .44,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: OtpController,
                      decoration: InputDecoration(
                        hintText: "Enter OTP",
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
                top: mq.height * .54,
                left: 150,
                child: Container(
                  child:ElevatedButton(
                    onPressed: () async{
                      String Otp = OtpController.text.toString();
                      if(Otp.isNotEmpty){
                        Dailogs.showProgressBar(context);
                        try {
                          PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: Otp);
                      FirebaseAuth.instance.signInWithCredential(credential).then((value){
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                      });
                        }
                        catch (e){
                          Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
    }
                    },
                    child: Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
                  ),
                ),
              ),
            ],
          ),
        );

  }
}
