import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/common/Common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePage extends StatefulWidget {
  final String? currentName;
  final String? currentEmail;
  final String? currentMobile;

  const UpdatePage({Key? key, this.currentName, this.currentEmail, this.currentMobile}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isPhone(String input) => RegExp(r"""^[+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$""").hasMatch(input);
  bool isEmail(String input) => EmailValidator.validate(input);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
    nameController.text = widget.currentName ?? "";
    emailController.text = widget.currentEmail ?? "";
    mobileController.text = widget.currentMobile ?? "";
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
          child: Form(
            key: _key,
            child: Column(
              children: [
                Center(
                  child: Image.asset("assets/images/app_logo.png", height: 100.h, width: 100.w, fit: BoxFit.fill),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r),
                  child: Text("Update Data", style: TextStyle(fontSize: 25.r, color: txtColor)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    controller: nameController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
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
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      labelText: 'Username'
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
                  padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    controller: emailController,
                    obscureText: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
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
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      labelText: 'Email ID'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Enter your email';
                      }
                      if(!isEmail(value)) {
                        return 'Enter valid email id';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 40.r, right: 40.r),
                  child: TextFormField(
                    controller: mobileController,
                    obscureText: false,
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
                        borderSide: BorderSide(color: litetxtColor, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: litetxtColor, width: 1)
                      ),
                      labelText: 'Mobile No'
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Enter mobile no';
                      }
                      if(!isPhone(value)) {
                        return 'Enter valid mobile number';
                      }
                      if(value.length != 10) {
                        return 'Please check your number';
                      }
                      return null;
                    },
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.r, left: 100.r, right: 100.r),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        if(_key.currentState!.validate()) {
                          Navigator.pop(context, {
                            _prefs.setString('name', nameController.text),
                            _prefs.setString('email', emailController.text),
                            _prefs.setString('mobileNumber', mobileController.text),
                          });
                        }
                      },
                      child: Container(
                        height: 55.0,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: dialogBtnColor),
                        child: Center(
                          child: Text("Update", style: TextStyle(color: txtColor, fontSize: 22.r)),
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
