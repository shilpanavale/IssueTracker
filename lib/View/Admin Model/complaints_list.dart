import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_dialog.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/IssueModel.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import '../User Model/api_constant.dart';
import 'package:http/http.dart' as http;

class ComplaintListPage extends StatefulWidget {
  const ComplaintListPage({Key? key}) : super(key: key);


  @override
  State<ComplaintListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ComplaintListPage> {

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
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(toDate);
    super.initState();
    registerComplaints=getRegisterComplaints('','');
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
                Text("List of Complaints",style: StyleForApp.subHeadline,),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    pickDateDialog(context);
                    },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        color: ColorsForApp.grayColor,
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
                ),
                const SizedBox(height: 10,),
                issueListView(context),
                //downloadAndShare()

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(height: 50,
          decoration:   BoxDecoration(
              color: HexColor("#F2F2F2"),
              borderRadius: BorderRadius.circular(10.0)
          ),
        child: downloadAndShare(),),
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
            return  _buildListView(vendor!);
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
              //Text(issueModelClass.issue.toString(),textAlign:TextAlign.start,style: StyleForApp.textStyle20dpBold,),
              Text(issueModelClass.issue!=null?issueModelClass.issue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 15,),
              Text(issueModelClass.subIssue!=null?issueModelClass.subIssue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 5,),
             // Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Status ",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                  Container(
                    height: 40,
                    width: 130,
                    /*decoration: BoxDecoration(
                        color: ColorsForApp.appButtonColor,
                        borderRadius: BorderRadius.circular(10.0)
                    ),*/
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(issueModelClass.status.toString(),textAlign:TextAlign.center,style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                         // letterSpacing: 0.27,
                          color: ColorsForApp.appButtonColor,
                        ),),
                      ),
                    ),
                  ),
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
  Widget downloadAndShare(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: 100,
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
                      AssetFiles.download,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Text("Download",style: StyleForApp.extraSmaller12dp,),
            ],
          ),
        ),
        InkWell(
          onTap: (){
            Share.share('check out my website https://example.com');
          },
          child: SizedBox(
            width: 100,
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
                        AssetFiles.share,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Text("Share",style: StyleForApp.extraSmaller12dp,),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<List<IssueModelClass>> getRegisterComplaints(String fromDate,String toDate) async {
    //List<VendorModelClass> vendors=[];
    //var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    //2022-11-06 00:00:00' AND '2022-11-07 23:59:59'

    var frmDt,toDt;
    var url;
    if(fromDate!=''&&toDate!=''){
      fromDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(fromDate));
      toDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(toDate));
      frmDt="$fromDate 000:00:00";
      toDt="$toDate 000:00:00";
      url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=$frmDt&to=$toDt&secret=d146d69ec7f6635f3f05f2bf4a51b318");

    }else{
      fromDate='';
      toDate='';
      url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=${fromDate.toString()}&to=${toDate.toString()}&secret=d146d69ec7f6635f3f05f2bf4a51b318");

    //https://api.creshsolutions.com/register-complaint/?from=&to=&secret=d146d69ec7f6635f3f05f2bf4a51b318
    }
    print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      List<IssueModelClass> vendors = decodeRes.map((tagJson) => IssueModelClass.fromJson(tagJson)).toList();

      return vendors;
    } else {
      throw Exception('Failed to load house list');
    }
  }
  Future<List<IssueModelClass>> getFilterRegisterComplaints(DateTime fromDate,DateTime toDate) async {
    //List<VendorModelClass> vendors=[];
    //var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    //2022-11-06 00:00:00' AND '2022-11-07 23:59:59'

    var frmDt,toDt;
    var url;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFrm = formatter.format(fromDate);

    final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    final String formattedTo = formatter.format(toDate);

      frmDt="$formattedFrm 000:00:00";
      toDt="$formattedTo 000:00:00";
      url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=$frmDt&to=$toDt&secret=d146d69ec7f6635f3f05f2bf4a51b318");
      print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      DialogBuilder(context).hideOpenDialog();
      var decodeRes=json.decode(response.body) as List;
      List<IssueModelClass> vendors = decodeRes.map((tagJson) => IssueModelClass.fromJson(tagJson)).toList();
      setState(() {

      });
      return vendors;
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load house list');
    }
  }

 /*  Todo:Not in use
  assignComplaint(int userComplaintId,int vendorId,String imageUrl) async {

    var url=Uri.parse("${APIConstant.APIURL}/assign-complaint");
     Map<String,dynamic> obj={
       "user_complaint_id":userComplaintId,
       "vendor_id":vendorId,
       "image_url":imageUrl
     };
    var response= await http.post(url, body: jsonEncode(obj));
    print("RES-->${response.body}");
    var decodeRes=json.decode(response.body);
    //print()

  }*/

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
                             DialogBuilder(context).showLoadingIndicator('');

                            registerComplaints=getFilterRegisterComplaints(fromDate,toDate);
                            Navigator.of(context).pop(context);

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
      });
    }
  }
  Future<void> toDatePicker(BuildContext context,
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
        toDate = picked;
        displayToDate=UT.displayDateConverter(toDate);
      });
    }
  }
}
