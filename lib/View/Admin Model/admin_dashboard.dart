
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'important_issue_list.dart';
class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);


  @override
  State<AdminDashboardPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminDashboardPage> {
  static GlobalKey previewContainer = new GlobalKey();
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
  bool clickOnShare=false;
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
            dataMap.isNotEmpty? RepaintBoundary(
              key: previewContainer,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: HexColor("#F2F2F2"),
                  ),
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
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                    // gradientList: ---To add gradient colors---
                    // emptyColorGradient: ---Empty Color gradient---
                  ),
                ),
              ),
            ):Container(),
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        _captureSocialPng("");
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
                      _captureSocialPng("Share");
                      //Share.share('check out my website https://example.com');
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
                      _createPDF("");
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

                  _createPDF("Share");
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ImportantIssuePage()));
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        const ComplaintListPage(statusFlag: "Not Resolved",)));
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        const ComplaintListPage(statusFlag: "Not Assigned",)));
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
        const ComplaintListPage(statusFlag: 'Assigned',)));
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ComplaintListPage(statusFlag: "Resolved",)));
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

  Future<void> _captureSocialPng(String flag) {
    String imagePaths ;
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewContainer.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/pieChart.png');
     // imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {

        await GallerySaver.saveImage(imgFile.path).then((value) {
          setState(() {
            // screenshotButtonText = 'screenshot saved!';
            Fluttertoast.showToast(msg: "Image saved into gallery!");
            if(flag=="Share"){
              Share.shareXFiles([XFile('${imgFile.path}')], text: '');
            }else{
              OpenFilex.open('${imgFile.path}');
            }
          });
        });


      }).catchError((onError) {
        print(onError);
      });
    });
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
  Future<void> _createPDF(String flag) async {
    //Create a new PDF document
   // PdfDocument document = PdfDocument();
    PdfFont subHeadingFont = PdfStandardFont(PdfFontFamily.timesRoman, 20);
    PdfDocument document = PdfDocument();

    //Adds page settings
    document.pageSettings.orientation = PdfPageOrientation.portrait;
    document.pageSettings.margins.all = 100;

    //Adds a page to the document
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    PdfBrush solidBrush = PdfSolidBrush(PdfColor(126, 151, 173));
    Rect bounds = const Rect.fromLTWH(0, 160, 500, 30);
    graphics.drawRectangle(brush: solidBrush, bounds: bounds);
    PdfTextElement element =
    PdfTextElement(text: 'Status Wise Complaints\n', font: subHeadingFont);
    element.brush = PdfBrushes.white;

    PdfLayoutResult result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, bounds.top + 8, 0, 0))!;

    element = PdfTextElement(
        text: 'Important Issues count:0 ',
        font: PdfStandardFont(PdfFontFamily.timesRoman, 15,
            style: PdfFontStyle.bold));
    element.brush = PdfSolidBrush(PdfColor(126, 155, 203));
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 25, 0, 0))!;

    PdfFont timesRoman = PdfStandardFont(PdfFontFamily.timesRoman, 10);
    element = PdfTextElement(text: 'Not Assigned  count : $not_assigned ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: 'Not Resolved  count : $not_resolved ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: 'Assigned count : $assigned ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

    element = PdfTextElement(
        text: 'Resolved count : $resolved ', font: timesRoman);
    element.brush = PdfBrushes.black;
    result = element.draw(
        page: page, bounds: Rect.fromLTWH(10, result.bounds.bottom + 15, 0, 0))!;

//Draws a line at the bottom of the address
    graphics.drawLine(
        PdfPen(PdfColor(126, 151, 173), width: 0.7),
        Offset(0, result.bounds.bottom + 6),
        Offset(graphics.clientSize.width, result.bounds.bottom + 3));




    //Save the document
    List<int> bytes = await document.save();

    if(flag=="Share"){
      saveAndShareFile(bytes,'statusWiseReport.pdf');
    }else{
      //Save the file and launch/download
      saveAndLaunchFile(bytes, 'statusWiseReport.pdf');
    }

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



