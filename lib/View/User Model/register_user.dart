
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';

import 'package:untitled/View/User%20Model/my_complaints.dart';


import 'Model/LocationModelPage.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);


  @override
  State<RegisterUser> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RegisterUser> {
 TextEditingController mobileNoTxt=TextEditingController();


  List<LocationModelClass> locationList=[];
  List<AccommodationModel> accommodationList=[];
  List accommodationList1=["Bungalow","Capts","Lt Col/Maj","Temp/Md"];
  List<HouseNumberModel> houseList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


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
        child: SingleChildScrollView(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 40,),
              Text("Welcome User",style: StyleForApp.headline,),
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
            const SizedBox(height: 50,),
             CommonTextField.mobileTextField(null, "Mobile No", mobileNoTxt, TextInputType.phone),
              const SizedBox(height: 10,),

              CommonButtonForAllApp(title: 'Register',onPressed: (){

                if(mobileNoTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter mobile no");
                }else if(mobileNoTxt.text.length<10){
                  Fluttertoast.showToast(msg: "Invalid mobile no");
                }
                else{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));

                }
                },),
              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }



}