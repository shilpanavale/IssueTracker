
import 'package:flutter/material.dart';

import 'package:untitled/App%20Theme/app_theme.dart';

import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/VendorModel.dart';
import 'package:untitled/View/Admin%20Model/new_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/update_email.dart';
import 'package:untitled/View/Admin%20Model/vendor_list.dart';


import 'add_screteKey.dart';
import 'change_password.dart';
import 'house_number_list.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);


  @override
  State<SettingPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SettingPage> {

  dynamic vendorID;
  List<VendorModelClass> vendorList=[];
  Future<List<VendorModelClass>>? vendorApi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));
    return true;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:willPopScopeBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackLeadingButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));
              },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Setting",style: StyleForApp.appBarTextStyle,),
            ],
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));

                    },
                    leading: Container(
                      height: 30,width: 30,
                      padding: const EdgeInsets.all(3.0),

                      child:  const Icon(Icons.person,size: 18, color: Colors.black38),
                    ),

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
                    title: Text("Change password",style: StyleForApp.textStyle15dp),
                  ),
                  Divider(color: ColorsForApp.grayLabelColor,),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const UpdateEmailPage()));

                    },
                    leading: Container(
                      height: 30,width: 30,
                      padding: const EdgeInsets.all(3.0),
                      child:  const Icon(Icons.email,size: 18, color: Colors.black38),
                    ),
                    title: Text("Update Email",style: StyleForApp.textStyle15dp),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
