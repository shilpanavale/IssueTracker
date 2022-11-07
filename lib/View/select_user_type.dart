import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/admin_login_page.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/enter_client_code.dart';
import 'package:untitled/View/User%20Model/select_login.dart';

import 'User Model/user_login_page.dart';

class SelectUserTypePage extends StatefulWidget {
  const SelectUserTypePage({Key? key}) : super(key: key);


  @override
  State<SelectUserTypePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SelectUserTypePage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController passwordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50,),
            Text("Select User Type",style: StyleForApp.headline,),
            const SizedBox(height: 45,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(UT.appType, "User");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const ClientCodePage()));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color:ColorsForApp.appButtonColor ,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: ColorsForApp.appButtonColor.withOpacity(
                                        0.3),
                                    //offset: const Offset(1.1, 1.1),
                                    blurRadius: 3.0),
                              ],
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(AssetFiles.user,fit:BoxFit.contain,color: ColorsForApp.whiteColor,),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text("User",style: StyleForApp.subHeadline,)
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString(UT.appType, "Admin");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminLoginPage()));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                             color:ColorsForApp.appButtonColor ,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: ColorsForApp.appButtonColor.withOpacity(
                                        0.2),
                                    //offset: const Offset(1.1, 1.1),
                                    blurRadius: 3.0),
                              ],
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(AssetFiles.admin,fit:BoxFit.contain,color: ColorsForApp.whiteColor,),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text("Admin",style: StyleForApp.subHeadline,)
                      ],
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
}