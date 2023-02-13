import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/new_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:http/http.dart' as http;

import '../../CustomeWidget/custome_dialog.dart';
import '../GC Model/GC_admin_dashboard.dart';
import '../JCO Model/JCO_admin_dashboard.dart';
import '../User Model/api_constant.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({Key? key}) : super(key: key);


  @override
  State<UpdateEmailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UpdateEmailPage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController email=TextEditingController();
  var selectEmailType;

  List<EmailTypeMode> emailTypeList=[
    EmailTypeMode("EscalationData 1BR",1),
    EmailTypeMode("EscalationData 1BM",2),
    EmailTypeMode("EscalationData 2",3),
    EmailTypeMode("complaint_register",4),
  ];

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
              Text("Update Email",style: StyleForApp.headline,),
              const SizedBox(height: 35,),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text(" Select email type",style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w400,
                          color: Colors.black38)),
                      value: selectEmailType,
                      isExpanded: true,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          size: 20,color: Colors.grey,
                        ),
                      ),
                      isDense: true,
                      onChanged: (newValue) {

                        setState(() {
                          selectEmailType=newValue;
                          print('selectEmailType-->$selectEmailType');
                        });
                      },
                      items: emailTypeList.map((value) {
                        return DropdownMenuItem<int>(
                          value: value.id,
                          child: Text(value.type!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
             CommonTextField.emailTextField(null, "Email", email, TextInputType.emailAddress),
              const SizedBox(height: 10,),
             CommonTextField.emailTextField(null, "Name", userNameTxt, TextInputType.text),
              const SizedBox(height: 30,),

              CommonButtonForAllApp(title: 'UPDATE',onPressed: (){
                if(email.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter email");
                }else if(userNameTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter name");
                }else{
                  DialogBuilder(context).showLoadingIndicator();
                  updateEmailAPI(userNameTxt.text,email.text,selectEmailType,context);
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
  updateEmailAPI(String userName,String email,int id,BuildContext context) async {
    Map<String,dynamic> obj={
      "id":id,
      "email": email,
      "name": userName
    };
    var url=Uri.parse("${APIConstant.APIURL}/escalation-email/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.patch(url, body: jsonEncode(obj));
    var decodeRes=json.decode(response.body);
    print("decodeRes-->$decodeRes");
    if(decodeRes['message']==false){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Invalid details");
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Update  Successfully");

        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));

    }
  }
}

class EmailTypeMode{
  final String type;
  int id;
  EmailTypeMode(this.type,this.id);
}