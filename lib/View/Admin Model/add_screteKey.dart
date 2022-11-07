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

class AddSecreteKeyPage extends StatefulWidget {
  const AddSecreteKeyPage({Key? key}) : super(key: key);


  @override
  State<AddSecreteKeyPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddSecreteKeyPage> {
  final TextEditingController secreteKey=TextEditingController();

  dynamic oldSecret;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecreteKey();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 30,),
            Text("Update Secret Key ",style: StyleForApp.headline,),
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
           CommonTextField.userNameTextField(null, "Secret Key", secreteKey, TextInputType.name),


            const SizedBox(height: 20,),
            CommonButtonForAllApp(title: 'UPDATE',onPressed: (){
              if(secreteKey.text.isEmpty){
                Fluttertoast.showToast(msg: "Please enter secret key");
              }else{
                updateSecreteKey(oldSecret, secreteKey.text);
              }
              },),
            const SizedBox(height: 10,),

          ],
        ),
      ),
    );
  }
  getSecreteKey() async {
    //https://api.creshsolutions.com/secret/{secret}
   // https://api.creshsolutions.com/secretcode/
    var url=Uri.parse("${APIConstant.APIURL}/secretcode");
    var response=await http.get(url);
    var decodeRes=json.decode(response.body);
    print("SK-->$decodeRes");

    secreteKey.text=decodeRes[0]['secret'];
    oldSecret=decodeRes[0]['secret'];
    setState(() {

    });

  }
  updateSecreteKey(String oldSecret,String newSecret) async {
    Map<String,dynamic> obj={
      "old_secret": oldSecret,
      "new_secret": newSecret
    };

    var url=Uri.parse("${APIConstant.APIURL}/secretcode");
    var response= await http.patch(url, body: jsonEncode(obj));
    var decodeRes=json.decode(response.body);
    print("decodeRes-->$decodeRes");
    if(decodeRes['message']==false){
      Fluttertoast.showToast(msg: "Something went wrong please try again!");
    }else{
      Fluttertoast.showToast(msg: "Update Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboardPage()));
    }


  }
}