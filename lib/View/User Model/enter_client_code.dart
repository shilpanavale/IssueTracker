import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/otp_page.dart';
import 'package:untitled/View/User%20Model/select_login.dart';
import 'package:untitled/View/User%20Model/user_login_page.dart';
import 'package:http/http.dart' as http;
class ClientCodePage extends StatefulWidget {
  const ClientCodePage({Key? key}) : super(key: key);


  @override
  State<ClientCodePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ClientCodePage> {
  TextEditingController secreteUserCodeTxt = TextEditingController();
  String secreteCode="";

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
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              Container(
                  constraints: const BoxConstraints(
                      maxWidth: 500
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(text: 'Please enter your ', style: TextStyle(color: ColorsForApp.blackColor)),
                      TextSpan(
                          text: 'secret user code ', style: TextStyle(color: ColorsForApp.blackColor, fontWeight: FontWeight.bold)),
                      TextSpan(text: 'here', style: TextStyle(color: ColorsForApp.blackColor)),
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
                  style: const TextStyle(fontSize: 15,color: Colors.black38,fontWeight: FontWeight.w400),
                  controller: secreteUserCodeTxt,
                  maxLength: 10,
                  clearButtonMode: OverlayVisibilityMode.editing,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  placeholder: 'Enter code',
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
                    if(secreteUserCodeTxt.text.isEmpty){
                      Fluttertoast.showToast(msg: "Please enter key");
                    }else {

                      validateUserCode(secreteUserCodeTxt.text);
                    }
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectLoginTypePage()));
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
              ),
              const SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }



  validateUserCode(String key) async {
    //https://api.creshsolutions.com/secret/{secret}
    // https://api.creshsolutions.com/secretcode/
    var url=Uri.parse("${APIConstant.APIURL}/secretcode/$key");
    print("secretcode url-->$url");
    var response=await http.get(url);
    print("secretcode res code-->${response.statusCode}");
    var decodeRes=json.decode(response.body);
    print("SK-->$decodeRes");
    if(decodeRes['message']==false){
      Fluttertoast.showToast(msg: "Invalid Key");
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserLoginPage()));
    }


  }

}