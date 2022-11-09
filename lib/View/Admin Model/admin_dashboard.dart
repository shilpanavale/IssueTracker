
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/View/Admin%20Model/admin_drawer.dart';
import 'package:untitled/View/Admin%20Model/complaints_list.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../CustomeWidget/custome_dialog.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);


  @override
  State<AdminDashboardPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminDashboardPage> {
  Map<String, double> dataMap ={};
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  DateTime currentDate=DateTime.now();
  DateTime fromDate=DateTime.now();
  DateTime toDate=DateTime.now();
  String displayFromDate="";
  String displayToDate="";
  double resolvedPer=0;
  double pending=100;
  dynamic assigned,resolved,not_resolved,not_assigned;
  @override
  void initState() {
    // TODO: implement initState
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(fromDate.add(Duration(days: 1)));
  //  displayToDate=UT.displayDateConverter(toDate);
    getData();
    super.initState();
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

          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Admin Dashboard",style: StyleForApp.appBarTextStyle,),
                ],
              ),
            ],
          ),
        ),
        drawer: const AdminDrawerPage(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
             // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                selectDateRange(context),
                const SizedBox(height: 10,),
                statusWiseComplaintUI(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget selectDateRange(BuildContext context){
    return  InkWell(
      onTap: (){
        pickDateDialog(context);
      },
      child: Container(
        // height: 250,
        //width: double.infinity,
        decoration:   BoxDecoration(
          color: HexColor("#F2F2F2"),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(15.0),
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
            dataMap.isNotEmpty? SizedBox(
              height: 100,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 36,
                //chartRadius: MediaQuery.of(context).size.width / 3.2,
                colorList: <Color>[
                  HexColor("#C6BFB7"),
                  HexColor("#BD1D38"),
                ],
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 36,
                //centerText: "HYBRID",
                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.left,
                  showLegends: true,
                  legendShape: BoxShape.rectangle,
                  legendTextStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15
                  ),
                ),
                chartValuesOptions:const ChartValuesOptions(
                  showChartValueBackground: true,
                  //showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: true,
                  decimalPlaces: 1,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              ),
            ):Container(),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
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
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
  Widget statusWiseComplaintUI(BuildContext context){
    return Container(
      //width: double.infinity,
      decoration:   BoxDecoration(
        color: HexColor("#F2F2F2"),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Status wise Complaints",textAlign:TextAlign.start,style: StyleForApp.subHeadline,),
          ),
          importantIssueUI(context),
          notAssignedUI(context),
          const SizedBox(height: 10,),
          notResolved(context),
          const SizedBox(height: 10,),
          assignedUI(context),
          const SizedBox(height: 10,),
          resolvedUI(context),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      _createPDF();
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
            ),
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
  Widget importantIssueUI(BuildContext context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: ColorsForApp.appButtonColor,
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Important Issues",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.whiteColor,
                ),),
                Text("0",style:  TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  letterSpacing: 0.27,
                  color: ColorsForApp.whiteColor,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget notResolved(BuildContext context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage()));
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: HexColor("#C6BFB7"),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Not Resolved",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text(not_resolved!=null?not_resolved.toString():"",style:  TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget notAssignedUI(BuildContext context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage()));
        },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: HexColor("#C6BFB7"),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Not Assigned",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text(not_assigned!=null?not_assigned.toString():"",style:  TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget assignedUI(BuildContext context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage()));
        },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: HexColor("#C6BFB7"),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Assigned",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text(assigned!=null?assigned.toString():"",style:  TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget resolvedUI(BuildContext context){
    return  InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage()));
        },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              color: HexColor("#C6BFB7"),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Resolved",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text(resolved!=null?resolved.toString():"",style:  TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }



  getData() async {
    //https://api.creshsolutions.com/admin-home/?secret=d146d69ec7f6635f3f05f2bf4a51b318
    var url =Uri.parse("${APIConstant.APIURL}/admin-home/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    var decodeRes=json.decode(response.body);
    var statusCount=decodeRes["statusWiseCount"];
    var totalCount=decodeRes["totalCount"];
    var resolvedCount=decodeRes["resolvedCount"];
    if(totalCount!=0){
       resolvedPer=100*resolvedCount/totalCount ;
       pending =100-resolvedPer;
    }
   dataMap= {
      "Resolved": resolvedPer,
    "Pending": pending,
    };
    assigned=statusCount["assigned"];
    resolved=statusCount["resolved"];
    not_resolved=statusCount["not_resolved"];
    not_assigned=statusCount["not_assigned"];
    setState(() {

    });
  }

  //Todo:Create pdf for status wise complaints
  Future<void> _createPDF() async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 14);
    //Add a new page and draw text
    document.pages.add().graphics.drawString(
        'Status Wise Complaints', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 50));

    //Save the document
    List<int> bytes = await document.save();

    //Save the file and launch/download
    saveAndLaunchFile(bytes, 'output.pdf');
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
  _launchURL(String path) async {
    var url = 'https:/$path';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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



