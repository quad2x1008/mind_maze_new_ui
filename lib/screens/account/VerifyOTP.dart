import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/account/NewPassword.dart';
import 'package:mind_maze/screens/account/SendOTP.dart';
import 'package:pinput/pinput.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20.r,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(5),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: box_decoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Mind Maze Brain Game", style: TextStyle(fontSize: 20.r, color: txtColor)),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Image.asset("assets/otpverify.png", height: 200.h, width: 200.w, fit: BoxFit.fill)),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Phone Verification", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.r, left: 20.r, right: 20.r),
                child: Text("We need to register your phone without getting started!", style: TextStyle(fontSize: 16.r),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.r, left: 20.r, right: 20.r),
                child: Pinput(
                  length: 6,
                  onChanged: (value) {
                    code = value;
                  },
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.r, left: 100.r, right: 100.r),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: SendOTP.verify, smsCode: code);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewPassword()));
                        print("=====Right OTP=====");
                      } catch(e) {
                        print("=====Wrong OTP=====");
                      }
                    },
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: dialogBtnColor
                      ),
                      child: Center(
                        child: Text("VERIFY OTP", style: TextStyle(color: txtColor, fontSize: 22.r)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
