import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:untitled/App%20Theme/app_theme.dart';

import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/house_number_list.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:http/http.dart' as http;

import '../../CustomeWidget/custome_dialog.dart';

class AddHouseNumber extends StatefulWidget {
  const AddHouseNumber({Key? key}) : super(key: key);


  @override
  State<AddHouseNumber> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddHouseNumber> {

  final TextEditingController houseLocationTxt=TextEditingController();
  final TextEditingController accommodationTxt=TextEditingController();
  final TextEditingController houseNumberTxt=TextEditingController();


  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const HouseNumberListPage()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const HouseNumberListPage()));
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Add House Number",style: StyleForApp.subHeadline,),
                    const SizedBox(height: 30,),
                    Container(
                      width: double.infinity,
                      // height: 40,
                      decoration: BoxDecoration(
                          color: HexColor("#4A50C9").withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 10,),

                          //CommonTextField.commonTextField(null, "Complaint Type", complaintTypeTxt, TextInputType.text),
                          /* Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                            child: Container(
                              height: 40,
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint:  Text(" Select Issue Type",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: ColorsForApp.grayLabelColor)
                                  ),
                                  value: selectIssueType,
                                  icon: const Padding(
                                    padding: EdgeInsets.only(right: 16.0),
                                    child: Icon(
                                      Icons.arrow_drop_down_circle,
                                      size: 20,color: Colors.grey,
                                    ),
                                  ),
                                  isExpanded: true,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectIssueType=newValue;
                                    });
                                  },
                                  items: issueTypeList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value["id"],
                                      child: Text(value["value"]),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),*/
                          const SizedBox(height: 10,),
                          CommonTextField.commonTextField(null, "Location", houseLocationTxt, TextInputType.text),
                          const SizedBox(height: 10,),
                          CommonTextField.mobileTextField(null, "Accommodation", accommodationTxt, TextInputType.text),
                          const SizedBox(height: 10,),
                          CommonTextField.emailTextField(null, "House Number", houseNumberTxt, TextInputType.text),

                          const SizedBox(height: 40,),

                          CommonButtonForAllApp(
                              onPressed: (){
                                if(houseLocationTxt.text.isEmpty){
                                  Fluttertoast.showToast(msg: "Please enter house location");
                                }else if(accommodationTxt.text.isEmpty){
                                  Fluttertoast.showToast(msg: "Please enter accommodation");
                                }else if(houseNumberTxt.text.isEmpty){
                                  Fluttertoast.showToast(msg: "Please enter house number");
                                }
                                else {
                                  DialogBuilder(context).showLoadingIndicator();
                                  postHouseNumber();
                                }
                              }, title: "Submit"),
                          const SizedBox(height: 20,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),

                    //downloadAndShare()

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  postHouseNumber() async {

    Map<String,dynamic> obj={
      "house_type": accommodationTxt.text,
      "house_location": houseLocationTxt.text,
      "house_no": houseNumberTxt.text
    };

    //print('add house number-->$obj');
    var url=Uri.parse("${APIConstant.apiUrl}/house/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.post(url, body: jsonEncode(obj));
   // print("RES-->${response.body}");
    var decodeRes=json.decode(response.body);
    var msg=decodeRes["message"];
    if(msg=="House Created") {
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "House Number Added Successfully");
      houseLocationTxt.clear();
      houseNumberTxt.clear();
      accommodationTxt.clear();
      setState(() {

      });
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Something went wrong please try again!");
    }

  }
}
