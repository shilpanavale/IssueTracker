import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:untitled/View/select_user_type.dart';

import '../../App Theme/app_theme.dart';
import 'api_constant.dart';


class UserDrawerPage extends StatefulWidget {
  const UserDrawerPage({Key? key}) : super(key: key);

  @override
  UserDrawerPageState createState() => UserDrawerPageState();
}

class UserDrawerPageState extends State<UserDrawerPage> {



  String mobileNo="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMobileNumber();
  }
  getMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNo= prefs.getString(UT.mobileNo)!;
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
              height: 100,
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

                      child:  const Icon(Icons.person,size: 25, color: Colors.white),
                    ),
                    title: Text("Mobile No \n$mobileNo",style: TextStyle(fontSize:18,color: ColorsForApp.whiteColor),),
                  ),
                ),
              ),
            ),
           /* ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));

              },
              leading: Container(
                height: 30,width: 30,
                padding: const EdgeInsets.all(3.0),

                child:  const Icon(Icons.person,size: 18, color: Colors.black38),
              ),
              *//*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*//*
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
              *//*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*//*
              title: Text("Manage Secret Key",style: StyleForApp.textStyle15dp),
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
              *//*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*//*
              title: Text("Change password",style: StyleForApp.textStyle15dp),
            ),*/
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