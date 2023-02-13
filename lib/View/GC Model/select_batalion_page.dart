import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/VendorModel.dart';
import 'package:untitled/View/Admin%20Model/add_vendor.dart';
import 'package:untitled/View/Admin%20Model/new_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/setting_page.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/View/GC%20Model/GC_admin_dashboard.dart';
import 'package:untitled/View/JCO%20Model/JCO_admin_dashboard.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';

import 'Model/BattalionListModel.dart';

class BatalionListPage extends StatefulWidget {
  const BatalionListPage({Key? key}) : super(key: key);


  @override
  State<BatalionListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BatalionListPage> {


  Future<List<Message>>? _vendorApi;


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
          leading: BackLeadingButton(onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewAdminDashboard()));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Select Batalion",style: StyleForApp.appBarTextStyle,),
              //Text("Admin Dashboard",style: StyleForApp.appBarTextStyle,),
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
                  Text("List of Battalions",style: StyleForApp.subHeadline,),
                  const SizedBox(height: 10,),
                  issueListView(context),
                  //downloadAndShare()

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget issueListView(BuildContext context){
    return FutureBuilder<List<Message>>(
      future: _vendorApi,
      builder: (context,snapshot){
        // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occurred',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            List<Message>? vendor = snapshot.data;
            return  _buildListView(vendor!);
          }
        }
        return const Center(child: CircularProgressIndicator(),);

      },
    );
  }
  Widget _buildListView(List<Message> vendors) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      controller: ScrollController(),
      itemBuilder: (ctx, idx) {
        return issueListItem(vendors[idx]);
      },
      itemCount: vendors.length,
    );
  }
  Widget issueListItem(Message vendor){
    return  Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
          width: double.infinity,
          decoration:   BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child:ListTile(
            title:Text(vendor.battalion ?? "",style: StyleForApp.textStyle14dp) ,
            leading: Icon(Icons.circle_sharp,color: ColorsForApp.appButtonColor,) ,
            trailing: Text(vendor.pending.toString()??"",style: StyleForApp.textStyle15dpBold),
          )
      ),
    );
  }

  Future<List<Message>> getMessage() async {
    var url=Uri.parse("${APIConstant.APIURL}/gc-option/?secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=2");
    print("vendor URL-->$url");
    var response= await http.get(url);
    var decodeRes=json.decode(response.body);
    if (response.statusCode == 200) {
      var messagelist=decodeRes["message"] as List;
      List<Message> message = decodeRes.map((tagJson) => Message.fromJson(tagJson)).toList();
      return message;
    } else {
      throw Exception('Failed to load house list');
    }

  }
}
