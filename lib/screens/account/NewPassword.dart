import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/Common.dart';
import 'LoginPage.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool passwordVisible = false;
  bool cpasswordVisible = false;

  void _savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
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
              SizedBox(height: 30.h),
              Center(child: Image.asset("assets/images/app_logo.png", height: 100.h, width: 100.w, fit: BoxFit.fill)),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Enter New Password", style: TextStyle(fontSize: 22.r, color: txtColor)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.r, left: 40.r, right: 40.r),
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
                padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
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
                padding: EdgeInsets.only(top: 30.r, left: 100.r, right: 100.r),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      if (_passwordController.text == _cpasswordController.text) {
                        _savePassword(_passwordController.text);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Passwords do not match'),
                            duration: Duration(seconds: 2),
                          ),
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
                        child: Text("DONE", style: TextStyle(color: txtColor, fontSize: 22.r)),
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
