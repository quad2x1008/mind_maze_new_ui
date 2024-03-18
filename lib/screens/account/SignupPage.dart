import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:mind_maze/screens/account/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isPhone(String input) => RegExp(r"""^[+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$""").hasMatch(input);
  bool isEmail(String input) => EmailValidator.validate(input);
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobilenoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();
  late SharedPreferences _prefs;

  bool passwordVisible = false;
  bool cpasswordVisible = false;
  bool showTooltip = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              children: [
                Center(child: Image.asset("assets/images/app_logo.png", height: 80.h, width: 80.w, fit: BoxFit.fill)),
                Padding(
                  padding: EdgeInsets.only(top: 20.r),
                  child: Text("Sign Up", style: TextStyle(fontSize: 25.r, color: txtColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _usernameController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
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
                        labelText: 'Username',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Enter your name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
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
                        labelText: 'Email ID'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Enter your email ';
                      }
                      if (!isEmail(value)) {
                        return 'enter valid email id ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _mobilenoController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
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
                  padding: EdgeInsets.only(top: 10.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
                    obscureText: !passwordVisible,
                    textInputAction: TextInputAction.next,
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
                      if (value == null || value.isEmpty) {
                        return 'Enter A Password';
                      }
                      if (value.length < 6) {
                        return 'minimum length is 6';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _cpasswordController,
                    obscureText: !cpasswordVisible,
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
                          icon: Icon(cpasswordVisible ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              cpasswordVisible = !cpasswordVisible;
                            });
                          },
                        ),
                        suffixIconColor: litetxtColor,
                        labelText: 'Confirm Password'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'enter confirm password ';
                      }
                      if (value != _passwordController.text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 100.r, right: 100.r),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        String password = _passwordController.text;
                        String confirmPassword = _cpasswordController.text;

                        if (password == confirmPassword) {
                          _prefs.setString('name', _usernameController.text);
                          _prefs.setString('email', _emailController.text);
                          _prefs.setString('mobileNumber', _mobilenoController.text);
                          _prefs.setString('password', password);

                          Navigator.pop(context);
                        } else {}
                      },
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: dialogBtnColor),
                        child: Center(
                          child: Text("SIGN UP", style: TextStyle(color: txtColor, fontSize: 22.r)),
                        ),
                      ),
                    ),
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
