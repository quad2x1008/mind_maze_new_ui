import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mind_maze/screens/HomePage.dart';
import 'package:mind_maze/screens/account/UpdatePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/ClsSound.dart';
import '../../common/Common.dart';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic>? email;
  String? Username;
  String? mobileno;

  ProfilePage({Key? key, this.email, this.Username, this.mobileno}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences _prefs;
  String? _username;
  String? _email;
  String? _mobileNo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
    print("Profile Page = Username : ${widget.Username}, Email ID : ${widget.email?['email']}, Mobile No : ${widget.mobileno}");
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = _prefs.getString('username');
      _email = _prefs.getString('email');
      _mobileNo = _prefs.getString('mobileNo');
    });
  }

  Future<void> _updateData(Map<String, dynamic> updatedData) async {
    setState(() {
      _username = updatedData['name'];
      _email = updatedData['email'];
      _mobileNo = updatedData['mobile'];
    });

    await _prefs.setString('username', _username!);
    await _prefs.setString('email', _email!);
    await _prefs.setString('mobileNo', _mobileNo!);
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?['email'];
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
              ClsSound.playSound(SOUNDTYPE.Tap);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Icon(Icons.chevron_left, size: 30.r, color: primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(child: Image.asset("assets/images/app_logo.png", height: 80.h, width: 80.w, fit: BoxFit.fill)),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Personal Profile", style: TextStyle(fontSize: 25.r, color: txtColor)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Username : ${widget.Username}", style: TextStyle(color: white, fontSize: 20.r)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Email ID : $email", style: TextStyle(color: white, fontSize: 20.r)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.r),
                child: Text("Mobile No : ${widget.mobileno}", style: TextStyle(color: white, fontSize: 20.r)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.r, left: 100.r, right: 100.r),
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      final updatedData = await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(
                        currentName: _username,
                        currentEmail: _email,
                        currentMobile: _mobileNo,
                      )));
                      if(updatedData != null) {
                        _updateData(updatedData);
                      }
                    },
                    child: Container(
                      height: 55.0,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.0), color: dialogBtnColor),
                      child: Center(
                        child: Text("UPDATE DATA", style: TextStyle(color: txtColor, fontSize: 22.r)),
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
