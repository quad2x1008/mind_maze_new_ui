import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/account/VerifyOTP.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  TextEditingController countryController = TextEditingController();
  var phone = "";

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                      Text("|", style: TextStyle(fontSize: 33.r, color: Colors.grey)),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: TextField(
                            onChanged: (value) {
                              phone = value;
                            },
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                              hintStyle: TextStyle(color: Colors.white)
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.r, left: 100.r, right: 100.r),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      print("NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: '${countryController.text + phone}',
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          print("Done-=====================================");
                          SendOTP.verify = verificationId;
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyOTP()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VerifyOTP()));
                    },
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: dialogBtnColor
                      ),
                      child: Center(
                        child: Text("SEND OTP", style: TextStyle(color: txtColor, fontSize: 22.r)),
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
