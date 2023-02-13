import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_dialog.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/IssueModel.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/enter_feedback.dart';
import 'package:untitled/View/Admin%20Model/view_details.dart';
import '../User Model/api_constant.dart';
import 'package:http/http.dart' as http;

import '../User Model/enter_feedback.dart';
import 'JCO_admin_dashboard.dart';


class JCOAdminComplaintListPage extends StatefulWidget {
  final statusFlag;
  const JCOAdminComplaintListPage({Key? key, this.statusFlag}) : super(key: key);


  @override
  State<JCOAdminComplaintListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<JCOAdminComplaintListPage> {

  final colorList = <Color>[
    Colors.greenAccent,
  ];
  DateTime currentDate=DateTime.now();
  DateTime fromDate=DateTime.now();
  DateTime toDate=DateTime.now();
  String displayFromDate="";
  String displayToDate="";
  Future<List<IssueModelClass>>? registerComplaints;
  ScreenshotController fullPageScreenshot = ScreenshotController();
  @override
  void initState() {
    // TODO: implement initState
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(toDate);
    super.initState();
    registerComplaints=getRegisterComplaints('','');
  }
  List<int> bytes=[];


  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOAdminDashboardPage()));
    return true;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: willPopScopeBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackLeadingButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOAdminDashboardPage()));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("JCO/OR Admin Dashboard",style: StyleForApp.appBarTextStyle,),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Screenshot(
              controller: fullPageScreenshot,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               // mainAxisSize: MainAxisSize.max,
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
                  Expanded(child: issueListView(context)),
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
        _createPDF('',vendors[idx]);
        return issueListItem(vendors[idx]);
      },
      itemCount: vendors.length,
    );
  }

  Widget issueListItem(IssueModelClass issueModelClass){
    ScreenshotController screenshotController = ScreenshotController();

    return  MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(issueModel: issueModelClass, statusFlag: widget.statusFlag)));

        },
        child: Screenshot(
          controller: screenshotController,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
            //  width: double.infinity,
              //height: 400,
              decoration:   BoxDecoration(
                  color: HexColor("#D6D6D6"),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("House No : ${issueModelClass.houseNo.toString()}",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text("Status ",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,)),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(issueModelClass.status.toString(),textAlign:TextAlign.end,style: TextStyle(
                                  // fontFamily: fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  // letterSpacing: 0.27,
                                  color: ColorsForApp.appButtonColor,
                                ),),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    issueModelClass.status.toString().toLowerCase()=="Not Resolved".toLowerCase()
                        ||issueModelClass.status.toString().toLowerCase()=="Resolved".toLowerCase()||
                        issueModelClass.status.toString().toLowerCase()=="Assigned".toLowerCase()?Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Container(),),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminFeedBackPage(issueModel:issueModelClass,statusFlag: widget.statusFlag,)));
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
                          ),
                        )
                      ],
                    ):Container(),
                    issueModelClass.mobileNo!=null||issueModelClass.mobileNo!=""?Row(
                      children: [
                        Text("Mob No : ", textAlign:TextAlign.start,style: StyleForApp.textStyle15dpBold,),

                        Text(issueModelClass.mobileNo ?? "",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
                      ],
                    ):Container(),
                    const SizedBox(height: 10,),
                    Text(issueModelClass.issueCreatedOn!=null?issueModelClass.issueCreatedOn!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailsScreen(issueModel: issueModelClass, statusFlag: widget.statusFlag)));
                      },
                        child: Text("View details",textAlign:TextAlign.center,style:  StyleForApp.textStyle16dpBold,)),

                    const SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget downloadAndShare(){
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              await fullPageScreenshot.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
                if (image != null) {
                  final directory = await getApplicationDocumentsDirectory();
                  final imagePath = await File('${directory.path}/image.png').create();
                  await imagePath.writeAsBytes(image);
                  print("sharing");

                  /// Share Plugin
                   await GallerySaver.saveImage(imagePath.path).then((value) {
                            setState(()  {
                              // screenshotButtonText = 'screenshot saved!';
                              Fluttertoast.showToast(msg: "Image saved into gallery!");

                             });
                           });
                  await Share.shareXFiles([XFile(imagePath.path)], text: '');

                }
              });

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
      ),
    );
  }






  Future<List<IssueModelClass>> getRegisterComplaints(String fromDate,String toDate) async {
    List<IssueModelClass> vendors=[];
    //var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    //2022-11-06 00:00:00' AND '2022-11-07 23:59:59'

    var frmDt,toDt;
    var url;
    if(fromDate!=''&&toDate!=''){
      fromDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(fromDate));
      toDate = DateFormat('yyyy-MM-dd').format(DateTime.parse(toDate));
      frmDt="$fromDate 000:00:00";
      toDt="$toDate 23:59:59";
      url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=$frmDt&to=$toDt&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=1");

    }else{
      fromDate='';
      toDate='';
      url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=${fromDate.toString()}&to=${toDate.toString()}&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=1");

      //https://api.creshsolutions.com/register-complaint/?from=&to=&secret=d146d69ec7f6635f3f05f2bf4a51b318
    }
    print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
     // vendors = decodeRes.map((tagJson) => IssueModelClass.fromJson(tagJson)).toList();

          for(var res in decodeRes){
            if(res['status'].toString().toLowerCase()==widget.statusFlag.toString().toLowerCase()){
              //print('in if status-->${res['status']}');
              IssueModelClass issueModelClass = IssueModelClass(
                comment: res['comment'],
                rating: res['rating'],
                imageUrl2: res['image_url_2']!=null||res['image_url_2']!=""?res['image_url_2']:"",
                mobileNo: res['mobile_no']!=null||res['mobile_no']!=""?res['mobile_no']:"",
                houseComplaintId: res['house_complaint_id'],
                catIssueId: res['cat_issue_id'],
                subIssueId: res['sub_issue_id'],
                houseId: res['house_id'],
                issueCreatedOn: res['issue_created_on'],
                imageUrl: res['image_url']!=null||res['image_url']!=""?res['image_url']:"",
                description: res['description'],
                userComplaintId: res['user_complaint_id'],
                status: res['status'],
                vendorId: res['vendor_id'],
                createdOn: res['created_on'],
                issue: res['issue'],
                subIssue: res['sub_issue'],
                houseNo: res['house_no'],
                escalation: res['Escalation'],
              );
              vendors.add(issueModelClass);

            }
      }
      return vendors;
    } else {
      return vendors;
    }
  }
  Future<List<IssueModelClass>> getFilterRegisterComplaints(DateTime fromDate,DateTime toDate) async {
    List<IssueModelClass> vendors=[];
    //var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    //2022-11-06 00:00:00' AND '2022-11-07 23:59:59'

    var frmDt,toDt;
    var url;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFrm = formatter.format(fromDate);

    final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    final String formattedTo = formatter.format(toDate);

    frmDt="$formattedFrm 000:00:00";
    toDt="$formattedTo 23:59:59";
    url=Uri.parse("${APIConstant.APIURL}/register-complaint/?from=$frmDt&to=$toDt&secret=d146d69ec7f6635f3f05f2bf4a51b318");
   // print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      DialogBuilder(context).hideOpenDialog();
      var decodeRes=json.decode(response.body) as List;
   //   List<IssueModelClass> vendors = decodeRes.map((tagJson) => IssueModelClass.fromJson(tagJson)).toList();

      for(var res in decodeRes){
        if(res['status'].toString().toLowerCase()==widget.statusFlag.toString().toLowerCase()){
         // print('in if status-->${res['status']}');
          IssueModelClass issueModelClass = IssueModelClass(
            comment: res['comment'],
            rating: res['rating'],
            imageUrl2: res['image_url_2'],
            mobileNo: res['mobile_no'],
            houseComplaintId: res['house_complaint_id'],
            catIssueId: res['cat_issue_id'],
            subIssueId: res['sub_issue_id'],
            houseId: res['house_id'],
            issueCreatedOn: res['issue_created_on'],
            imageUrl: res['image_url'],
            description: res['description'],
            userComplaintId: res['user_complaint_id'],
            status: res['status'],
            vendorId: res['vendor_id'],
            createdOn: res['created_on'],
            issue: res['issue'],
            subIssue: res['sub_issue'],
            houseNo: res['house_no'],
            escalation: res['Escalation'],
          );
          vendors.add(issueModelClass);

        }
      }
      setState(() {

      });
      return vendors;
    } else {
      DialogBuilder(context).hideOpenDialog();
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
                                const SizedBox(width: 30,),
                                Expanded(
                                  child: Container(
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text("To"),
                                const SizedBox(width: 50,),
                                Expanded(
                                  child: Container(
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
                           // Navigator.of(context).pop(context);
                            Navigator.of(context).pop();

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
        toDate=fromDate.add(Duration(days: 1));
       // print('displayToDate--->$displayToDate');
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


  Future<void> _createPDF(String flag,IssueModelClass issueModelClass) async {
    //Create a new PDF document
    // PdfDocument document = PdfDocument();
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 20);
    PdfDocument document = PdfDocument();

    //Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
   // document.pageSettings.margins.all = 100;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = const Rect.fromLTWH(0, 10, 500, 30);
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);
    PdfTextElement element =
    PdfTextElement(text: 'List Of Complaints\n', font: subHeadingFont);
    element.brush = PdfBrushes.white;

    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;

    element = PdfTextElement(
        text: issueModelClass.houseNo!,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 15,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);
    element = PdfTextElement(text: issueModelClass.issue!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: issueModelClass.subIssue!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: issueModelClass.status!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: issueModelClass.issueCreatedOn!, font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 6),
        Offset(graphics.clientSize.width, result.bounds.bottom + 3));




    //Save the document
     bytes = await document.save();


    //Dispose the document
    document.dispose();
  }


  Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');

    await file.writeAsBytes(bytes, flush: true);
    // _launchURL('$path/$fileName');
    //Write PDF data

    //Open the PDF document in mobile
    OpenFilex.open('$path/$fileName');
  }

  Future<void> saveAndShareFile(
      List<int> bytes, String fileName) async {
    //Get external storage directory
    Directory directory = await getApplicationSupportDirectory();
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$fileName');

    await file.writeAsBytes(bytes, flush: true);
    // _launchURL('$path/$fileName');
    //Write PDF data

    //Open the PDF document in mobile
    // OpenFilex.open('$path/$fileName');
    Share.shareXFiles([XFile('$path/$fileName')], text: '');
  }

}