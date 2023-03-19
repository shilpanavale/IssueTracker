import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/View/Admin%20Model/add_screteKey.dart';
import 'package:untitled/View/Admin%20Model/change_password.dart';
import 'package:untitled/View/Admin%20Model/house_number_list.dart';
import 'package:untitled/View/Admin%20Model/vendor_list.dart';
import 'package:untitled/View/select_user_type.dart';

import '../../App Theme/app_theme.dart';
import '../User Model/api_constant.dart';


class AdminDrawerPage extends StatefulWidget {
  const AdminDrawerPage({Key? key}) : super(key: key);

  @override
  AdminDrawerPageState createState() => AdminDrawerPageState();
}

class AdminDrawerPageState extends State<AdminDrawerPage> {


  dynamic userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userType= prefs.getString(UT.appType);
    //print("userType-->$userType");
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

  return Drawer(
    backgroundColor: ColorsForApp.whiteColor,
    child: Column(
     // padding: EdgeInsets.zero,
      children: <Widget>[
        Expanded(child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              // width: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0.0),
                color: ColorsForApp.appButtonColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Center(
                  child: ListTile(
                    leading: Container(
                      height: 30,width: 30,
                      padding: const EdgeInsets.all(3.0),

                      child:  const Icon(Icons.settings,size: 20, color: Colors.white),
                    ),
                    title: userType=="1"?
                    Text("JCO/OR Admin Setting",style: StyleForApp.textStyle16dpBold.copyWith(color: Colors.white),)
                        :userType=="2"?
                    Text("GC Admin Setting",style: StyleForApp.appBarTextStyle,):
                     userType=="0"? Text("Officer Admin Setting",style: StyleForApp.appBarTextStyle,)
                         :Text("Admin Setting",style: StyleForApp.appBarTextStyle,)
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));

              },
              leading: Container(
                height: 30,width: 30,
                padding: const EdgeInsets.all(3.0),

                child:  const Icon(Icons.person,size: 18, color: Colors.black38),
              ),
              /*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*/
              title: Text("Manage MES Reps",style: StyleForApp.textStyle15dp),
            ),
            Divider(color: ColorsForApp.grayLabelColor,),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddSecreteKeyPage()));

              },
              leading: Container(
                height: 30,width: 30,
                padding: const EdgeInsets.all(3.0),
                child:  const Icon(Icons.edit,size: 18, color: Colors.black38),
              ),
              /*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*/
              title: Text("Manage Secret Key",style: StyleForApp.textStyle15dp),
            ),
            Divider(color: ColorsForApp.grayLabelColor,),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HouseNumberListPage()));

              },
              leading: Container(
                height: 30,width: 30,
                padding: const EdgeInsets.all(3.0),
                child:  const Icon(Icons.security,size: 18, color: Colors.black38),
              ),
              /*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*/
              title: Text("Manage House Number",style: StyleForApp.textStyle15dp),
            ),
            Divider(color: ColorsForApp.grayLabelColor,),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChangePassPage()));

              },
              leading: Container(
                height: 30,width: 30,
                padding: const EdgeInsets.all(3.0),
                child:  const Icon(Icons.security,size: 18, color: Colors.black38),
              ),
              /*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*/
              title: Text("Change password",style: StyleForApp.textStyle15dp),
            ),
          ],
        )),


        Container(
            height: 50,
            //margin: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [ColorsForApp.appButtonColor, ColorsForApp.appButtonColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(0.0)
            ),
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: Center(
                    child: ListTile(
                        onTap: () async {

                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const SelectUserTypePage()));
                        },
                         leading: const Icon(Icons.login,color: Colors.white,),
                        title: const Text('Logout',style: TextStyle(fontSize:16,color: Colors.white),)),
                  ),
                )
            )),
      ],
    ),
  );


  }
}