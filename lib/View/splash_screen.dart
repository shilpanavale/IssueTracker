import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/GC%20Model/GC_complaints_list.dart';
import 'package:untitled/View/JCO%20Model/JCO_complaints_list.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:untitled/View/select_user_type.dart';
import 'Admin Model/admin_login_page.dart';


class SplashPage extends StatefulWidget {
  static const String id = 'SplashPage';

  const SplashPage({Key? key}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  String? loginStatus;

  startTime() async {

    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    loginStatus = preferences.getString(UT.loginStatus);
    String? appType=preferences.getString(UT.appType);

    print("loginStatus-->$loginStatus");
    print("loginStatus-->$appType");
   if(loginStatus=="True"&&appType=="User"){
     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>MyComplaintListPage()));
   }else if(loginStatus=="True"&&appType=="GC"){
     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>GCComplaintList()));
   }else if(loginStatus=="True"&&appType=="JCO"){
     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>JCOComplaintList()));
   }
   else if(loginStatus=="True"&&appType=="Admin"){
     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>UserAdminDashboardPage()));
   }
   else{
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(
         builder: (BuildContext context) =>  const SelectUserTypePage(),
       ),
           (route) => false,
     );
   }


  }

  @override
  void initState() {
    startTime();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text("SAMADHAN",style: StyleForApp.headline,),
                const SizedBox(height: 10),
              Container(
              height: 150,
              //width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(
                AssetFiles.loaderGif,
              ),
            ),

              ),
              ),
                Text("App for Issue Tracking",style: StyleForApp.headline,),
                const SizedBox(height: 100),
                Text("This app allows you to report,\n track issues",textAlign:TextAlign.center,style: StyleForApp.textStyle20dp,)
              ],
            )
        ),
      ),

    );
  }
}
