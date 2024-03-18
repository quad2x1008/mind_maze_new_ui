import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/HomePage.dart';
import 'package:mind_maze/screens/account/SendOTP.dart';
import 'package:mind_maze/screens/account/SignupPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String? initialEmailOrMobile;
  final String? username;
  final String? mobileno;

  const LoginPage({Key? key, this.initialEmailOrMobile, this.username, this.mobileno}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  bool isPhone(String input) => RegExp(r'^\+?[(]?\d{3}[)]?[-\s.]?\d{3}[-\s.]?\d{4,6}$').hasMatch(input);
  bool isEmail(String input) => EmailValidator.validate(input);
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
    if(widget.initialEmailOrMobile != null) {
      mobileController.text = widget.initialEmailOrMobile!;
    }
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
            onTap: () {},
            child: Icon(Icons.chevron_left, size: 30.r, color: Colors.transparent),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Center(child: Image.asset("assets/images/app_logo.png", height: 100.h, width: 100.w, fit: BoxFit.fill)),
                Padding(
                  padding: EdgeInsets.only(top: 20.r),
                  child: Text("Login", style: TextStyle(fontSize: 25.r, color: txtColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      prefixIconColor: litetxtColor,
                      labelStyle: TextStyle(color: litetxtColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      labelText: 'Mobile No'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter mobile no';
                      }
                      if (!isPhone(value)) {
                        return "enter valid mobile number";
                      }
                      if (value.length != 10) {
                        return "please check your number";
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: passController,
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.key),
                      prefixIconColor: litetxtColor,
                      labelStyle: TextStyle(color: litetxtColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            passwordVisible = !passwordVisible;
                          });
                        },
                      ),
                      suffixIconColor: litetxtColor,
                      labelText: 'Password'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Enter A Password';
                      } else if(value.length < 6) {
                        return 'Minimum length is 6';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.r, right: 50.r),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SendOTP()));
                      },
                      child: Text("Forget Password ?", style: TextStyle(color: txtColor, fontSize: 16.r)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30.r, left: 100.r, right: 100.r),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        String mobileNumber = mobileController.text;
                        String password = passController.text;

                        String? savedMobileNumber = _prefs.getString('mobileNumber');
                        String? savedPassword = _prefs.getString('password');

                        if (mobileNumber == savedMobileNumber && password == savedPassword) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Not Valid Mobile no & Password..!!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      },
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: dialogBtnColor
                        ),
                        child: Center(
                          child: Text("SIGN IN", style: TextStyle(color: txtColor, fontSize: 22.r)),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 10.r, right: 10.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don’t have an account?", style: TextStyle(color: txtColor, fontSize: 16.r)),
                      SizedBox(width: 5.r),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                        },
                        child: Text("Sign Up", style: TextStyle(color: litetxtColor, fontSize: 16.r)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> saveUserDataToFirestore(String name, String email, String mobileNumber) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    await users.add({
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
    });

    print('User data saved to Firestore');
  } catch (e) {
    print('Error saving user data: $e');
  }
}
