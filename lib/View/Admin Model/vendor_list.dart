import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/add_vendor.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';

class VendorListPage extends StatefulWidget {
  const VendorListPage({Key? key}) : super(key: key);


  @override
  State<VendorListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VendorListPage> {


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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: issueArray.length,
        physics: const ScrollPhysics(),
        controller: ScrollController(),
        itemBuilder: (context,index){
          print(issueArray[index]);
          return issueListItem(issueArray[index]);
        });
  }
  Widget issueListItem(var issue){
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
            backgroundColor: ColorsForApp.appButtonColor.withOpacity(0.3),
           radius: 20,
            child: Icon(Icons.person,color: Colors.white,),
          ),
          title:Text("Issue Type : "+issue['issueTpe'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(issue['issueName'],textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
              const SizedBox(height: 5,),
              Text(issue['issueDetails'],textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
              Text(issue['issueStatus'],textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
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

}
