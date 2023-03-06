import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/setting_page.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/admin_drawer.dart';
import 'package:untitled/View/Admin%20Model/admin_login_page.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/enter_client_code.dart';
import 'package:untitled/View/User%20Model/select_login.dart';

import '../../CustomeWidget/custome_dialog.dart';
import '../GC Model/GC_admin_dashboard.dart';
import '../GC Model/select_batalion_page.dart';
import '../JCO Model/JCO_admin_dashboard.dart';
import '../select_user_type.dart';



class NewAdminDashboard extends StatefulWidget {
  const NewAdminDashboard({Key? key}) : super(key: key);


  @override
  State<NewAdminDashboard> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NewAdminDashboard> {


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
         automaticallyImplyLeading: false,
         /* leading: Builder(
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
          ),*/
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Admin Dashboard",style: StyleForApp.appBarTextStyle,),
            ],
          ),
        ),
       // drawer: const AdminDrawerPage(),
        body: SafeArea(
          child:Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(3.0),
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(UT.appType, "0");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserAdminDashboardPage()));

                        },
                          child: makeDashboardItem("Officers", Icons.person)),
                      InkWell(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(UT.appType, "1");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOAdminDashboardPage()));
                        },
                          child: makeDashboardItem("JCO/OR", Icons.person)),
                      InkWell(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(UT.appType, "2");
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const BatalionListPage()));
                        },
                          child: makeDashboardItem("GC", Icons.person)),
                      InkWell(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingPage()));
                        },
                          child: makeDashboardItem("Setting", Icons.settings)),

                    ],
                  ),
                  InkWell(
                    onTap: () async {

                      final prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectUserTypePage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 50,
                          //margin: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [ColorsForApp.grayColor, ColorsForApp.grayColor],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(0.0)
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 0.0),
                            child: Center(
                              child: Text('Logout',style: TextStyle(fontSize:16,color: Colors.black),),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

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