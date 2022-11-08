import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/admin_drawer.dart';
import 'package:untitled/View/Admin%20Model/complaints_list.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';

import '../../CustomeWidget/custome_dialog.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);


  @override
  State<AdminDashboardPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminDashboardPage> {
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
  @override
  void initState() {
    // TODO: implement initState
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(fromDate.add(Duration(days: 1)));
  //  displayToDate=UT.displayDateConverter(toDate);
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
            SizedBox(
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
            ),
            const SizedBox(height: 20,),
            Row(
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
          openIssueUI(context),
          const SizedBox(height: 10,),
          noUpdateUI(context),
          const SizedBox(height: 10,),
          Row(
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
          ),
          const SizedBox(height: 10,),
        ],
      ),
    );
  }
  Widget noUpdateUI(BuildContext context){
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
                Text("No Updates",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text("10",style:  TextStyle(
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
  Widget openIssueUI(BuildContext context){
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
                Text("Open Issues",style: TextStyle(
                  // fontFamily: fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  letterSpacing: 0.27,
                  color: ColorsForApp.blackColor,
                ),),
                Text("8",style:  TextStyle(
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
                Text("8",style:  TextStyle(
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