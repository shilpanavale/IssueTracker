import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  DateTime currentDate=DateTime.now();
  DateTime fromDate=DateTime.now();
  DateTime toDate=DateTime.now();
  String displayFromDate="";
  String displayToDate="";
  Future<List<IssueModelClass>>? registerComplaints;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(toDate);
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
                /*  InkWell(
                    onTap: (){
                      pickDateDialog(context);
                    },
                    child: Container(
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
                          *//*Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Today",style: TextStyle(
                              // fontFamily: fontName,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              letterSpacing: 0.27,
                              color: ColorsForApp.blackColor,
                            ),),
                          )*//*

                        ],
                      ),
                    ),
                  ),*/
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
  Widget issueListItem(IssueModelClass issueModelClass){
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
              Text(issueModelClass.issue!=null?issueModelClass.issue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle20dpBold,),
              const SizedBox(height: 15,),
              Text(issueModelClass.subIssue!=null?issueModelClass.subIssue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 5,),
              //Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Issue Status",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(issueModelClass.status!=null?issueModelClass.status!:"",textAlign:TextAlign.center,style: TextStyle(
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
              issueModelClass.status=="Assigned"?
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
              Text(issueModelClass.issueCreatedOn!=null?issueModelClass.issueCreatedOn!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),



              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }
  Future<List<IssueModelClass>> getRegisterComplaints() async {
    List<IssueModelClass> vendors=[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? mobileNo=preferences.getString(UT.mobileNo);
    var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?number=$mobileNo&secret=d146d69ec7f6635f3f05f2bf4a51b318");
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
      return vendors;
      throw Exception('Failed to load house list');
    }
  }

  pickDateDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, StateSetter setState1) {
                return AlertDialog(
                  content: SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("From"),
                                Container(
                                  height: 45, width: 100,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      left: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      right: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xECEAEAF6)),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5)),
                                    //color: Color(0xECEAEAF6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[

                                        InkWell(
                                          child: Text(
                                              displayFromDate.toString(),
                                              textAlign: TextAlign.center,
                                              style: StyleForApp.textStyle14dp
                                          ),
                                          onTap: () {
                                            fromDatePicker(context,setState1);
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("To"),
                                Container(
                                  height: 45, width: 100,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        left: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        right: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                        bottom: BorderSide(width: 1.0,
                                            color: Color(0xECEAEAF6)),
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          child: Text(
                                              displayToDate.toString(),
                                              textAlign: TextAlign.center,
                                              style: StyleForApp.textStyle14dp
                                          ),
                                          onTap: () {
                                            toDatePicker(context, setState1);
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ])
                  ),
                  actions: <Widget>[
                    ButtonBar(
                      buttonMinWidth: 100,
                      alignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: ColorsForApp.grayColor,
                                textStyle: TextStyle(
                                    color: ColorsForApp.blackColor
                                )
                            ),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child:  Text("Cancel",style: TextStyle(
                                color: ColorsForApp.blackColor
                            ))),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorsForApp.appButtonColor,
                              textStyle: TextStyle(
                                //fontSize: 30,
                                color: ColorsForApp.whiteColor,
                                //fontWeight: FontWeight.bold
                              )
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(context);
                            // DialogBuilder(context).showLoadingIndicator('');
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  ],
                );
              }

          );
        });
  }
  Future<void> fromDatePicker(BuildContext context,
      StateSetter setState2) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2010),
      lastDate:DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.light(
              primary: ColorsForApp.appButtonColor, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ))!;
    if (picked != null && picked != currentDate) {
      setState2(() {
        fromDate = picked;
        displayFromDate=UT.displayDateConverter(fromDate);
        displayToDate=UT.displayDateConverter(fromDate.add(Duration(days: 1)));
        print('displayToDate--->$displayToDate');
      });
    }
  }
  Future<void> toDatePicker(BuildContext context,
      StateSetter setState2) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: fromDate,
      lastDate:DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:  ColorScheme.light(
              primary: ColorsForApp.appButtonColor, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ))!;
    if (picked != null && picked != currentDate) {
      setState2(() {
        toDate = picked;
        displayToDate=UT.displayDateConverter(toDate);
      });
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
