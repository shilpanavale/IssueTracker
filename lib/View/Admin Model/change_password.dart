import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:http/http.dart' as http;

import '../User Model/api_constant.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({Key? key}) : super(key: key);


  @override
  State<ChangePassPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ChangePassPage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController oldPasswordTxt=TextEditingController();
  final TextEditingController newPasswordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 30,),
              Text("Change password ",style: StyleForApp.headline,),
              const SizedBox(height: 35,),
             /* Container(
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
              ),*/
            //const SizedBox(height: 70,),
             CommonTextField.userNameTextField(null, "Username", userNameTxt, TextInputType.name),
              const SizedBox(height: 10,),
             CommonTextField.passwordText(null, "Old Password", oldPasswordTxt, TextInputType.text),
              const SizedBox(height: 10,),
             CommonTextField.passwordText(null, "New Password", newPasswordTxt, TextInputType.text),
              const SizedBox(height: 20,),
              CommonButtonForAllApp(title: 'CHANGE',onPressed: (){
                if(userNameTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter username");
                }else if(oldPasswordTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter old password");
                }else if(newPasswordTxt.text.length<8){
                  Fluttertoast.showToast(msg: "Password must be minimum 8 character");
                }else{
                  changePassword(userNameTxt.text,oldPasswordTxt.text,newPasswordTxt.text);
                }
                },),
              const SizedBox(height: 10,),
              /*Padding(
                padding: const EdgeInsets.only(right: 30.0,top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",style: StyleForApp.textStyle14dp,),
                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
  changePassword(String userName,String oldPass,String newPassword) async {
    Map<String,dynamic> obj={
      "user_name":userName,
      "old_passcode": oldPass,
      "new_passcode": newPassword
    };
    var url=Uri.parse("${APIConstant.APIURL}/admin-log-up/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.patch(url, body: jsonEncode(obj));
    var decodeRes=json.decode(response.body);
    print("decodeRes-->$decodeRes");
    if(decodeRes['message']==false){
      Fluttertoast.showToast(msg: "Invalid username or password");
    }else{
      Fluttertoast.showToast(msg: "Password Changed Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboardPage()));
    }


  }
}