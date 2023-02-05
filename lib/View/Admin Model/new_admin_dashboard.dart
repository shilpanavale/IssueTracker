import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/admin_drawer.dart';
import 'package:untitled/View/Admin%20Model/admin_login_page.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/enter_client_code.dart';
import 'package:untitled/View/User%20Model/select_login.dart';

import '../../CustomeWidget/custome_dialog.dart';
import '../GC Model/GC_dashboard.dart';
import '../JCO Model/JCO_dashboard.dart';



class NewAdminDashboard extends StatefulWidget {
  const NewAdminDashboard({Key? key}) : super(key: key);


  @override
  State<NewAdminDashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewAdminDashboard> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController passwordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:  ()async {
        exitAppDialog();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: Container(
                height: 25,width: 25,
                decoration:  const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Image.asset(
                  AssetFiles.menu,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Admin Dashboard",style: StyleForApp.appBarTextStyle,),
            ],
          ),
        ),
        drawer: const AdminDrawerPage(),
        body: SafeArea(
          child:Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(3.0),
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserAdminDashboardPage()));

                  },
                    child: makeDashboardItem("User", Icons.person)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const GCAdminDashboardPage()));
                  },
                    child: makeDashboardItem("GC", Icons.home)),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOAdminDashboardPage()));
                  },
                    child: makeDashboardItem("JCO", Icons.home)),

              ],
            ),
          ),


         /* Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 45,),
              Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserAdminDashboardPage()));
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
                       // final prefs = await SharedPreferences.getInstance();
                       // prefs.setString(UT.appType, "Admin");
                       // Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminLoginPage()));
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
              Padding(
                padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                       // final prefs = await SharedPreferences.getInstance();
                       // prefs.setString(UT.appType, "GC");
                      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ClientCodePage()));
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
                          Text("GC",style: StyleForApp.subHeadline,)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                       *//* final prefs = await SharedPreferences.getInstance();
                        prefs.setString(UT.appType, "JCO");
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ClientCodePage()));*//*
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
                          Text("JCO",style: StyleForApp.subHeadline,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
             // color: Color.fromRGBO(220, 220, 220, 1.0)
            color: ColorsForApp.grayColor
          ),
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                    icon,
                    size: 40.0,
                    color: ColorsForApp.appButtonColor,
                  )),
              SizedBox(height: 20.0),
              Center(
                child:  Text(title,
                    style:
                    TextStyle(fontSize: 18.0, color: Colors.black)),
              )
            ],
          ),
        ));
  }
  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
      ),
    );
  }
}