import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/enter_feedback.dart';
import 'package:untitled/View/User%20Model/register_complaint.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/View/User%20Model/user_drawer.dart';
import '../../CustomeWidget/custome_dialog.dart';
import '../Admin Model/Model/IssueModel.dart';

class MyComplaintListPage extends StatefulWidget {
  const MyComplaintListPage({Key? key}) : super(key: key);


  @override
  State<MyComplaintListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyComplaintListPage> {
  Map<String, double> dataMap = {
    "Resolved": 80,
    "Pending": 20,
  };
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  List issueArray=[
    {
      "issueId":"#1234",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Pending",
      "issueDate":"24 Oct 2022 11:00am",
    },
    {
      "issueId":"#1235",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Assigned",
      "issueDate":"25 Oct 2022 9:00am",
    },
    {
      "issueId":"#1236",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Resolved",
      "issueDate":"26 Oct 2022 10:00am",
    },
    {
      "issueId":"#1237",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Pending",
      "issueDate":"27 Oct 2022 9:00am",
    }
  ];
  Future<List<IssueModelClass>>? registerComplaints;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerComplaints=getRegisterComplaints();
  }
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
              Text("User Dashboard",style: StyleForApp.appBarTextStyle,),
            ],
          ),
        ),
        drawer: const UserDrawerPage(),
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
                  Text("My Complaints",style: StyleForApp.subHeadline,),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: ColorsForApp.grayColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Row(
                            children: [
                              const SizedBox(width: 8,),
                              Container(
                                height: 25,width: 25,
                                decoration:  const BoxDecoration(
                                  color: Colors.transparent,
                                  image:  DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      AssetFiles.calendar,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5,),
                              Text("Select Date Range",style: StyleForApp.extraSmaller12dp,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Today",style: TextStyle(
                            // fontFamily: fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            letterSpacing: 0.27,
                            color: ColorsForApp.blackColor,
                          ),),
                        )

                      ],
                    ),
                  ),
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterComplaint()));
          },
          // isExtended: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  Widget issueListView(BuildContext context){
    return FutureBuilder<List<IssueModelClass>>(
      future: registerComplaints,
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
            List<IssueModelClass>? vendor = snapshot.data;
            print("in future-->$vendor");
            if(vendor!.isNotEmpty){
              return  _buildListView(vendor);
            }else{
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'No complaints found',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

          }
        }
        return const Center(child: CircularProgressIndicator(),);
      },
    );
  }
  Widget _buildListView(List<IssueModelClass> vendors) {
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
  Widget issueListItem(var issue){
    return  Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        width: double.infinity,
        decoration:   BoxDecoration(
          color: HexColor("#D6D6D6"),
            borderRadius: BorderRadius.circular(10.0)
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(issue['issueId'],textAlign:TextAlign.start,style: StyleForApp.textStyle20dpBold,),
              const SizedBox(height: 15,),
              Text(issue['issueName'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 5,),
              Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Issue Status",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(issue['issueStatus'],textAlign:TextAlign.center,style: TextStyle(
                      // fontFamily: fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      letterSpacing: 0.27,
                      color: ColorsForApp.whiteColor,
                    ),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  issue['issueStatus']=="Assigned"?
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedBackPage()));
                  },
                  child: Container(
                  height: 40,
                  //width: MediaQuery.of(context).size.width,
                  //width: 110,
                  decoration: BoxDecoration(
                      color: ColorsForApp.appButtonColor,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Feedback",textAlign:TextAlign.center,style: TextStyle(
                      // fontFamily: fontName,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      letterSpacing: 0.27,
                      color: ColorsForApp.whiteColor,
                    ),),
                  ),
              ),
                ):Container(),
                 // Text(issue['issueStatus']=="Assigned"?"Give Feedback":"",textAlign:TextAlign.end,style: StyleForApp.textStyle16dpBold,),
                ],
              ),
              Text(issue['issueDate'],textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),



              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
  Future<List<IssueModelClass>> getRegisterComplaints() async {
    List<IssueModelClass> vendors=[];
    var url=Uri.parse("${APIConstant.APIURL}/register-complaint/9604609321");
    print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
       vendors = decodeRes.map((tagJson) => IssueModelClass.fromJson(tagJson)).toList();

      return vendors;
    }else if(response.statusCode==404){
      return vendors;
    }
    else{
      throw Exception('Failed to load house list');
    }
  }

  Future<bool?> exitAppDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
      ),
    );
  }
}
