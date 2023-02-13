import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_dialog.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/ImportantModelclass.dart';
import 'package:untitled/View/Admin%20Model/Model/IssueModel.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import '../User Model/api_constant.dart';
import 'package:http/http.dart' as http;


class ImportantIssuePage extends StatefulWidget {
  final escalationNo;
  const ImportantIssuePage({Key? key, this.escalationNo}) : super(key: key);


  @override
  State<ImportantIssuePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ImportantIssuePage> {
  static GlobalKey previewContainerKey =  GlobalKey();
  final colorList = <Color>[
    Colors.greenAccent,
  ];
  DateTime currentDate=DateTime.now();
  DateTime fromDate=DateTime.now();
  DateTime toDate=DateTime.now();
  String displayFromDate="";
  String displayToDate="";
  Future<List<ImportantIssueModel>>? importantComplaints;
  @override
  void initState() {
    // TODO: implement initState
    displayFromDate=UT.displayDateConverter(fromDate);
    displayToDate=UT.displayDateConverter(toDate);
    super.initState();
    importantComplaints=getRegisterComplaints();
  }
  List<int> bytes=[];
  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AdminDashboardPage()));
    return true;
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
                  Text("List of Important Complaints",style: StyleForApp.subHeadline,),
                  const SizedBox(height: 10,),
                  RepaintBoundary(
                    key: previewContainerKey,
                      child: issueListView(context)),
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
    return FutureBuilder<List<ImportantIssueModel>>(
      future: importantComplaints,
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
            List<ImportantIssueModel>? vendor = snapshot.data;
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
  Widget _buildListView(List<ImportantIssueModel> vendors) {
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

  Widget issueListItem(ImportantIssueModel issueModelClass){
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
              Text("House No : ${issueModelClass.houseNo.toString()}",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              const SizedBox(height: 8,),
              Text(issueModelClass.issue!=null?issueModelClass.issue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
              const SizedBox(height: 5,),
              Text(issueModelClass.subIssue!=null?issueModelClass.subIssue!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
              const SizedBox(height: 5,),
              // Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Status ",textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                  SizedBox(
                    height: 40,
                    //width: 130,
                    /*decoration: BoxDecoration(
                        color: ColorsForApp.appButtonColor,
                        borderRadius: BorderRadius.circular(10.0)
                    ),*/
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(issueModelClass.status.toString()=="2"?"Not Resolved"
                          :issueModelClass.status.toString()=="1"?"Resolved":"Assigned",
                          textAlign:TextAlign.end,style: TextStyle(
                          // fontFamily: fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          // letterSpacing: 0.27,
                          color: ColorsForApp.appButtonColor,
                        ),),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      //width: 130,
                      /*decoration: BoxDecoration(
                          color: ColorsForApp.appButtonColor,
                          borderRadius: BorderRadius.circular(10.0)
                      ),*/
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text("Escalation:"+issueModelClass.escalation.toString(),textAlign:TextAlign.end,style: TextStyle(
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
              Text(issueModelClass.issueCreatedOn!=null?issueModelClass.issueCreatedOn!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
              const SizedBox(height: 10,),
            ],
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
       /*   Expanded(
            child: InkWell(
              onTap: (){



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
          ),*/
          InkWell(
            onTap: (){
             // Share.share('check out my website https://example.com');
              _captureScreenShot("Share");

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


  Future<void> _captureScreenShot(String flag) {
    String imagePaths ;
    final RenderBox box = context.findRenderObject() as RenderBox;
    return Future.delayed(const Duration(milliseconds: 20), () async {
      RenderRepaintBoundary? boundary = previewContainerKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image image = await boundary!.toImage();
      final directory = (await getApplicationDocumentsDirectory()).path;
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      File imgFile = new File('$directory/complaints.png');
      // imagePaths.add(imgFile.path);
      imgFile.writeAsBytes(pngBytes).then((value) async {

        await GallerySaver.saveImage(imgFile.path).then((value) {
          setState(() {
           // screenshotButtonText = 'screenshot saved!';
            Fluttertoast.showToast(msg: "Image saved into gallery!");
            if(flag=="Share"){
              Share.shareXFiles([XFile('${imgFile.path}')], text: '');
            }
          });
        });
      }).catchError((onError) {
        print(onError);
      });
    });
  }


  Future<List<ImportantIssueModel>> getRegisterComplaints() async {
    List<ImportantIssueModel> impComplaintsList=[];
    //https://api.creshsolutions.com/important-issue/?escalation=1,2%20or%203&secret=d146d69ec7f6635f3f05f2bf4a51b318
    var url=Uri.parse("${APIConstant.APIURL}/important-issue/?escalation=${widget.escalationNo}&secret=d146d69ec7f6635f3f05f2bf4a51b318");

    print("url-->$url");
    var response= await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      impComplaintsList = decodeRes.map((tagJson) => ImportantIssueModel.fromJson(tagJson)).toList();
      return impComplaintsList;
    } else {
      return impComplaintsList;
    }
  }


}