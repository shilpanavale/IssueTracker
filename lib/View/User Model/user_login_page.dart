import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/otp_page.dart';
import 'package:http/http.dart' as http;

import '../GC Model/GC_complaints_list.dart';
import '../JCO Model/JCO_complaints_list.dart';
import 'my_complaints.dart';
class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);


  @override
  State<UserLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UserLoginPage> {
  TextEditingController phoneController = TextEditingController();

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
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 60,),
            //Text("Welcome User",style: StyleForApp.headline,),
            //const SizedBox(height: 35,),
            Container(
              height: 150,
              //width: double.infinity,
              decoration:  const BoxDecoration(
                color: Colors.transparent,
                image:  DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(
                    AssetFiles.login1,
                  ),
                ),

              ),
            ),
            const SizedBox(height: 40,),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        constraints: const BoxConstraints(
                            maxWidth: 500
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: 'Login with ', style: TextStyle(color: ColorsForApp.blackColor)),
                            TextSpan(
                                text: 'OTP ', style: TextStyle(color: ColorsForApp.blackColor, fontWeight: FontWeight.bold)),
                            TextSpan(text: 'on this mobile number', style: TextStyle(color: ColorsForApp.blackColor)),
                          ]),
                        )),
                    const SizedBox(height: 10,),
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorsForApp.whiteColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        controller: phoneController,
                        style: const TextStyle(fontSize: 15,color: Colors.black38,fontWeight: FontWeight.w400),
                        maxLength: 10,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        placeholder: '+91...',
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if(phoneController.text.isEmpty){
                            Fluttertoast.showToast(msg: "Please enter mobile number");
                          }else if(phoneController.text.length<10){
                            Fluttertoast.showToast(msg: "Please enter valid number");
                          }else {
                            getOTP(phoneController.text);
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
                              const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  color: ColorsForApp.whiteColor,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  getOTP(String mobile) async {
    //https://api.creshsolutions.com/otp/
    var url=Uri.parse("${APIConstant.APIURL}/otp/?secret=d146d69ec7f6635f3f05f2bf4a51b318");

    var obj={
      "mobile_no":mobile,
    };
 //   var response= await http.post(url, body: jsonEncode(obj));
   // var decodeRes=json.decode(response.body);

    //var status=decodeRes['status'];
   // var status1=status['status'];
    var status1=true;
    var userId=33;
    //var userId=status['user_id'];

    if(status1==false){
      Fluttertoast.showToast(msg: "Error Occurred");
    }else{
     /* final prefs = await SharedPreferences.getInstance();
      prefs.setString(UT.mobileNo, mobile);
      prefs.setInt(UT.userId, userId);
      Fluttertoast.showToast(msg: "OTP sent to your mobile number");*/
     // Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpPage()));
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(UT.loginStatus, "True");
      var userType=prefs.getString(UT.appType);
      if(userType=="GC"){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const GCComplaintList()));
      }else if(userType=="JCO"){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const JCOComplaintList()));
      }else{
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MyComplaintListPage()));
      }
    }


  }
}