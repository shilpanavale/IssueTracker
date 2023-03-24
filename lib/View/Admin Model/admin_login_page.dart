import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:http/http.dart' as http;

import '../User Model/api_constant.dart';
import 'new_admin_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);


  @override
  State<AdminLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminLoginPage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController passwordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 40,),
              Text("Welcome Admin",style: StyleForApp.headline,),
              const SizedBox(height: 35,),
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
             const SizedBox(height: 70,),
             CommonTextField.userNameTextField(null, "Username", userNameTxt, TextInputType.name),
              const SizedBox(height: 10,),
             CommonTextField.passwordText(null, "Password", passwordTxt, TextInputType.text),
              const SizedBox(height: 20,),
              CommonButtonForAllApp(title: 'LOGIN',onPressed: (){
                if(userNameTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter username");
                }else if(passwordTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter password");
                }else{
                  postLogin(userNameTxt.text,passwordTxt.text);
                }
                },),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(right: 30.0,top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Forgot Password?",style: StyleForApp.textStyle14dp,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  postLogin(String userName,String pass) async {
    Map<String,dynamic> obj={
      "user_name":userName,
      "passcode":pass
    };
    var url=Uri.parse("${APIConstant.apiUrl}/admin-log-up/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    //print("url-->$url");
    var response= await http.post(url, body: jsonEncode(obj));
   // print("decode-->${response.body}");
    var decodeRes=json.decode(response.body);

   // print("decode-->${decodeRes['message']}");
    if(decodeRes['message']==false){
      Fluttertoast.showToast(msg: "Invalid username & password");
    }else{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(UT.loginStatus, "True");
      Fluttertoast.showToast(msg: "Login Successfully done");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));
    }
  }
}