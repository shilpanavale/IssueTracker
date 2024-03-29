import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:untitled/App%20Theme/app_theme.dart';

import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/Model/HouseNumberModel.dart';
import 'package:untitled/View/Admin%20Model/add_house_number.dart';
import 'package:untitled/View/Admin%20Model/setting_page.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/View/User%20Model/api_constant.dart';

import '../../CustomeWidget/custome_dialog.dart';


class HouseNumberListPage extends StatefulWidget {
  const HouseNumberListPage({Key? key}) : super(key: key);


  @override
  State<HouseNumberListPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HouseNumberListPage> {

  dynamic vendorID;
  List<HouseNumberModelClass> houseNumberList=[];
  Future<List<HouseNumberModelClass>>? _houseNumberApi;


  Future<bool> willPopScopeBack() async{

      Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingPage()));

    return true;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop:willPopScopeBack,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackLeadingButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SettingPage()));

          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Setting",style: StyleForApp.appBarTextStyle,),
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
                  Text("List of House Number",style: StyleForApp.subHeadline,),
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddHouseNumber()));
          },
          // isExtended: true,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  Widget issueListView(BuildContext context){
    return FutureBuilder<List<HouseNumberModelClass>>(
      future: _houseNumberApi,
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
            List<HouseNumberModelClass>? houseNumber = snapshot.data;
            return  _buildListView(houseNumber!);
          }
        }
        return const Center(child: CircularProgressIndicator(),);

      },
    );
  }
  Widget _buildListView(List<HouseNumberModelClass> houseNumbers) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      controller: ScrollController(),
      itemBuilder: (ctx, idx) {
        return issueListItem(houseNumbers[idx]);
      },
      itemCount: houseNumbers.length,
    );
  }
  Widget issueListItem(HouseNumberModelClass houseNumber){
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
              backgroundColor: ColorsForApp.appButtonColor,
              radius: 18,
              child: const Icon(Icons.house,color: Colors.white,),
            ),
          /*  trailing: GestureDetector(
            onTap: (){
              DialogBuilder(context).showLoadingIndicator();
              deleteHouse(houseNumber.houseId!);
            },
            child: CircleAvatar(
              backgroundColor: ColorsForApp.appButtonColor,
              radius: 13,
              child: const Icon(Icons.delete,color: Colors.white,size: 15,),
            ),
          ),*/
            // title:Text("Issue Type : "+issue['issueTpe'],textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
            title:Text(houseNumber.houseNo!,textAlign:TextAlign.start,style: StyleForApp.textStyle16dpBold,),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(houseNumber.houseLocation!,textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
                const SizedBox(height: 5,),
                Text(houseNumber.houseType!,textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
                //Text(issue['issueStatus'],textAlign:TextAlign.start,style: StyleForApp.extraSmaller12dp,),
              ],
            ),
          )
      ),
    );
  }

  Future<List<HouseNumberModelClass>> getHouseNumberList() async {

    var url=Uri.parse("${APIConstant.apiUrl}/house/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.get(url);

    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      List<HouseNumberModelClass> houseNumber = decodeRes.map((tagJson) => HouseNumberModelClass.fromJson(tagJson)).toList();
      return houseNumber;
    } else {
      throw Exception('Failed to load house list');
    }

  }
  deleteHouse(String houseId) async{
    var url=Uri.parse("${APIConstant.apiUrl}/house/?id=$houseId&secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.delete(url);
    var decodeRes=json.decode(response.body);
    var msg=decodeRes["message"];
    if(msg.toString().contains("SQLSTATE")) {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "This house assigned with issue ");
    }else {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "House Deleted successfully");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const HouseNumberListPage()));
    }
  }
}
