import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';

class IssueListPage extends StatefulWidget {
  const IssueListPage({Key? key}) : super(key: key);


  @override
  State<IssueListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<IssueListPage> {
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
      "issueStatus":"Issue Status",
      "issueDate":"24 Oct 2022 11:00am",
    },
    {
      "issueId":"#1235",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Issue Status",
      "issueDate":"25 Oct 2022 9:00am",
    },
    {
      "issueId":"#1236",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Issue Status",
      "issueDate":"26 Oct 2022 10:00am",
    },
    {
      "issueId":"#1237",
      "issueName":"Issue Name",
      "issueDetails":"Issue Details",
      "issueStatus":"Issue Status",
      "issueDate":"27 Oct 2022 9:00am",
    }
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackLeadingButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserAdminDashboardPage()));
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
                Container(
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
    return ListView.builder(
      shrinkWrap: true,
        itemCount: issueArray.length,
        physics: const ScrollPhysics(),
        controller: ScrollController(),
        itemBuilder: (context,index){
      return issueListItem(issueArray[index]);
    });
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
                  Text(issue['issueStatus'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
                  Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                        color: ColorsForApp.appButtonColor,
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Assign",textAlign:TextAlign.center,style: TextStyle(
                        // fontFamily: fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        letterSpacing: 0.27,
                        color: ColorsForApp.whiteColor,
                      ),),
                    ),
                  ),
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
}
