import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/View/Admin%20Model/vendor_list.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';

import '../../App Theme/app_theme.dart';


class AdminDrawerPage extends StatefulWidget {
  const AdminDrawerPage({Key? key}) : super(key: key);

  @override
  AdminDrawerPageState createState() => AdminDrawerPageState();
}

class AdminDrawerPageState extends State<AdminDrawerPage> {





  @override
  Widget build(BuildContext context) {

  return Drawer(
    backgroundColor: ColorsForApp.whiteColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            padding: EdgeInsets.zero,
          child:Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ColorsForApp.appButtonColor,
            ),

          )

        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             /* Container(
                height: 80,
                width: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AssetsFiles.ahhaaLogo,
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        ),
        ListTile(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));

          },
          leading: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),

            child:  Icon(Icons.person,size: 18, color: ColorsForApp.grayColor),
          ),
          /*trailing: Container(
            height: 30,width: 30,
            padding: const EdgeInsets.all(3.0),
            child: Icon(Icons.arrow_forward_ios,size: 16, color: ColorsForApp.white),
          ),*/
          title: Text("Add Vendor",style: StyleForApp.textStyle15dp),
        ),

      ],
    ),
  );


  }
}