import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;
import '../../CustomeWidget/custome_widget.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {

  String text = '';
  int numberOfFields = 6;
  bool clearText = false;
  String _verificationCode = '';
  late List<TextStyle?> otpTextStyles;
  late List<TextEditingController?> controls;
  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }
   String mobileNo="";
  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Center(child: Text(text[position], style: TextStyle(color: Colors.black),)),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
      );
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMobileNumber();
  }
   getMobileNumber() async {
     final prefs = await SharedPreferences.getInstance();
     mobileNo= prefs.getString(UT.mobileNo)!;
     print("mobileNo-->$mobileNo");
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackLeadingButton(onPressed: (){
          Navigator.of(context).pop();
        },),
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Text('Enter 6 digits verification code sent to your number', style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.w500))
                        ),
                        OtpTextField(
                          decoration: const InputDecoration(
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.deepPurpleAccent, //<-- SEE HERE
                          ),
                          numberOfFields: numberOfFields,
                          borderColor: const Color(0xFF512DA8),
                          focusedBorderColor: Colors.red,
                          clearText: clearText,
                          showFieldAsBox: true,
                          textStyle: Theme.of(context).textTheme.subtitle2,
                          onCodeChanged: (String value) {
                            //Handle each value
                          },
                          handleControllers: (controllers) {
                            //get all textFields controller, if needed
                            controls = controllers;
                          },
                          onSubmit: (String verificationCode) {
                            //set clear text to clear text from all fields
                            // setState(() {
                            _verificationCode=verificationCode;
                            // clearText = true;
                            // });
                          }, // end onSubmit
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(
                        maxWidth: 500
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if(_verificationCode==null||_verificationCode==""){
                          Fluttertoast.showToast(msg: "Please enter OTP");
                        }else{
                          validateOTP(_verificationCode);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: ColorsForApp.appButtonColor,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14))
                          ),
                          ),


                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Confirm', style: TextStyle(color: Colors.white),),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: ColorsForApp.whiteColor,
                              ),
                              child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 16,),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  validateOTP(String otp) async {

    var obj={
      "mobile_no":mobileNo,
      "otp": otp
    };
    var url=Uri.parse("${APIConstant.APIURL}/otp/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print("url-->$url");
    var response= await http.patch(url,body: jsonEncode(obj));
    var decodeRes=json.decode(response.body);
    print("decodeRes OTP-->$decodeRes");
    if(decodeRes['message']==false){
      Fluttertoast.showToast(msg: "Invalid OTP");
    }else{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(UT.loginStatus, "True");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MyComplaintListPage()));
    }

  }
}
