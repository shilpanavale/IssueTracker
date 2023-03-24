import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/App%20Theme/app_theme.dart';

import 'package:untitled/View/Admin%20Model/new_admin_dashboard.dart';
import 'package:http/http.dart' as http;

import '../../CustomeWidget/custome_dialog.dart';

import '../User Model/api_constant.dart';

class UpdateEmailPage extends StatefulWidget {
  const UpdateEmailPage({Key? key}) : super(key: key);


  @override
  State<UpdateEmailPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UpdateEmailPage> {
  final List<TextEditingController>? emailController = [];
  final List<TextEditingController>? userNamelController = [];
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController email=TextEditingController();
  dynamic selectEmailType;

  List<EmailTypeMode> emailTypeList=[
    EmailTypeMode("EscalationData 1BR",1),
    EmailTypeMode("EscalationData 1BM",2),
    EmailTypeMode("EscalationData 2",3),
    EmailTypeMode("complaint_register",4),
  ];
  List emails=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmails();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 30,),
                Text("Update Email",style: StyleForApp.headline,),
                const SizedBox(height: 30,),
               ListView.builder(
                 itemCount: emails.length,
                   shrinkWrap: true,
                   itemBuilder: (context,index){
                 emailController!.add( TextEditingController(text: emails[index]["email"]));
                 return  Padding(
                   padding: const EdgeInsets.only(top: 8, bottom: 3, right: 30, left: 30),
                   child: Row(
                     children: [
                         Expanded(
                      child: Container(
                   // height: 37,
                    width: MediaQuery.of(context).size.width,
                    //padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorsForApp.whiteColor,
                      // border: Border.all()
                    ),
                    child: TextFormField(
                      controller: emailController![index],
                      //autovalidateMode: AutovalidateMode.always,
                      textInputAction: TextInputAction.done,
                      autofocus: false,
                      // maxLength: 10,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 15.0, color: ColorsForApp.blackColor),
                      decoration: InputDecoration(
                        //suffixIcon: Icon(icon, color: ColorsForApp.nearlyWhite,),
                          counterText: "",
                          //iconColor: ColorsForApp.lightGrayColor,
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10.0),
                          fillColor:ColorsForApp.grayColor,
                          //border: OutlineInputBorder(),
                          labelText: emails[index]["email_type"],
                          labelStyle:  TextStyle(fontSize: 14.0, color: ColorsForApp.blackColor),
                          border: InputBorder.none
                      ),
                      minLines: 1,
                      maxLines: 1,
                      validator: (value){
                        String pattern =
                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                            r"{0,253}[a-zA-Z0-9])?)*$";
                        RegExp regex = RegExp(pattern);
                        if(value!.isEmpty){
                          return "Please enter email";
                        } if(!regex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        } else{ return null;}
                      },
                    ),
                  ),
                      ),
                       const SizedBox(width: 5,),
                       Container(
                         //width:100,
                         height: 40,
                         decoration: BoxDecoration(
                             color: ColorsForApp.appButtonColor,
                             boxShadow: <BoxShadow>[
                               BoxShadow(
                                   color: ColorsForApp.appButtonColor.withOpacity(
                                       0.6),
                                   offset: const Offset(1.1, 1.1),
                                   blurRadius: 3.0),
                             ],
                             gradient: LinearGradient(colors: [
                               ColorsForApp.appButtonColor,
                               ColorsForApp.appButtonColor,
                             ]),
                             borderRadius: BorderRadius.circular(10.0)
                         ),
                         child: TextButton(
                           onPressed: (){
                             DialogBuilder(context).showLoadingIndicator();
                             updateEmailAPI(emails[index]["name"],emailController![index].text,emails[index]["id"],context);
                           },
                           child:  Text(
                             "Update",
                             style:  TextStyle(fontSize:16,fontWeight:FontWeight.w700,color: ColorsForApp.whiteColor),
                           ),
                         ),
                       ),

                     ],
                   ),
                 );
               }),
                const SizedBox(height: 30,),


               /* CommonButtonForAllApp(title: 'UPDATE',onPressed: (){
                  if(email.text.isEmpty){
                    Fluttertoast.showToast(msg: "Please enter email");
                  }else if(userNameTxt.text.isEmpty){
                    Fluttertoast.showToast(msg: "Please enter name");
                  }else{
                    DialogBuilder(context).showLoadingIndicator();
                    updateEmailAPI(userNameTxt.text,email.text,selectEmailType,context);
                  }
                  },),*/
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
      ),
    );
  }
  updateEmailAPI(String userName,String email,int id,BuildContext context) async {
    Map<String,dynamic> obj={
      "id":id,
      "email": email,
      "name": userName
    };
    var url=Uri.parse("${APIConstant.apiUrl}/escalation-email/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.patch(url, body: jsonEncode(obj));
    var decodeRes=json.decode(response.body);

    if(decodeRes['message']==false){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Invalid details");
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Update  Successfully");

        Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));

    }
  }
  getEmails() async {
    var url=Uri.parse("${APIConstant.apiUrl}/escalation-email/?secret=d146d69ec7f6635f3f05f2bf4a51b318&get_all=1");
    var response= await http.get(url);
    var decodeRes=json.decode(response.body) as List;
    emails=decodeRes;
    setState(() {

    });
  }
}

class EmailTypeMode{
  final String type;
  int id;
  EmailTypeMode(this.type,this.id);
}