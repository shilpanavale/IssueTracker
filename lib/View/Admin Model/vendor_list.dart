import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/VendorModel.dart';
import 'package:untitled/View/Admin%20Model/add_vendor.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/View/User%20Model/api_constant.dart';

class VendorListPage extends StatefulWidget {
  const VendorListPage({Key? key}) : super(key: key);


  @override
  State<VendorListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VendorListPage> {

  List<VendorModelClass> vendorList=[];

  List issueArray=[
    {
      "issueTpe":"house color",
      "issueName":"Rahul more",
      "issueDetails":"8767567890",
      "issueStatus":"rahul@gmail.com"
    },
    {
      "issueTpe":"house color",
      "issueName":"Rahul more",
      "issueDetails":"8767567890",
      "issueStatus":"rahul@gmail.com"
    },
    {
      "issueTpe":"house color",
      "issueName":"Rahul more",
      "issueDetails":"8767567890",
      "issueStatus":"rahul@gmail.com"
    }

  ];
  Future<List<VendorModelClass>>? _vendorApi;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _vendorApi=getVendorList();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackLeadingButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminDashboardPage()));
        },),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Admin Dashboard",style: StyleForApp.appBarTextStyle,),
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
                Text("List of Vendor",style: StyleForApp.subHeadline,),
                const SizedBox(height: 10,),
                issueListView(context),
                //downloadAndShare()

              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // isExtended: true,
        backgroundColor: ColorsForApp.appButtonColor,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddVendor()));
        },
        // isExtended: true,
        child: const Icon(Icons.add),
      ),
    );
  }
  Widget issueListView(BuildContext context){
    return FutureBuilder<List<VendorModelClass>>(
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
            List<VendorModelClass>? vendor = snapshot.data;
            return  _buildListView(vendor!);
          }
        }
        return const Center(child: CircularProgressIndicator(),);

      },
    );
  }
  Widget _buildListView(List<VendorModelClass> vendors) {
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
  Widget issueListItem(VendorModelClass vendor){
    return  Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        decoration:   BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0)
        ),
        child:ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorsForApp.appButtonColor,
           radius: 18,
            child: Icon(Icons.person,color: Colors.white,),
          ),trailing: CircleAvatar(
            backgroundColor: ColorsForApp.appButtonColor,
            radius: 15,
            child: Icon(Icons.delete,color: Colors.white,size: 17,),
          ),
         // title:Text("Issue Type : "+issue['issueTpe'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
          title:Text(vendor.vendorName!,textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(vendor.vendorEmail!,textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
              const SizedBox(height: 5,),
              Text(vendor.vendoreContact!,textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
              //Text(issue['issueStatus'],textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
            ],
          ),
        )

       /* Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(issue['issueTpe'],textAlign:TextAlign.start,style: StyleForApp.textStyle20dpBold,),
              const SizedBox(height: 15,),
              Text(issue['issueName'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 5,),
              Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              Text(issue['issueStatus'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),




              const SizedBox(height: 10,),

            ],
          ),
        ),*/
      ),
    );
  }

  Future<List<VendorModelClass>> getVendorList() async {
    //List<VendorModelClass> vendors=[];
    var url=Uri.parse("${APIConstant.APIURL}/vendor");
    print("vendor URL-->$url");
    var response= await http.get(url);

    if (response.statusCode == 200) {
     var decodeRes=json.decode(response.body) as List;
     List<VendorModelClass> vendors = decodeRes.map((tagJson) => VendorModelClass.fromJson(tagJson)).toList();
      print("vendors-->$vendors");
      return vendors;
    } else {
      throw Exception('Failed to load house list');
    }

  }

}
