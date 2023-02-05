import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/vendor_list.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;

class AddVendor extends StatefulWidget {
  const AddVendor({Key? key}) : super(key: key);


  @override
  State<AddVendor> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddVendor> {

  final TextEditingController vendorNameTxt=TextEditingController();
  final TextEditingController contactTxt=TextEditingController();
  final TextEditingController emailIDTxt=TextEditingController();

  var selectIssueType;

  List<dynamic> issueTypeList=[
    {
      "id":"plumping",
      "value":"1234",
    },
    {
      "id":"Paint house",
      "value":"1235",
    },
    {
      "id":"Pipe leakage",
      "value":"1235",
    },
  ];

  Future<bool> willPopScopeBack() async{
     Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const VendorListPage()));
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Add MES Reps",style: StyleForApp.subHeadline,),
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
                           CommonTextField.commonTextField(null, "Name", vendorNameTxt, TextInputType.text),
                          const SizedBox(height: 10,),
                           CommonTextField.mobileTextField(null, "Contact Number", contactTxt, TextInputType.number),
                          const SizedBox(height: 10,),
                          CommonTextField.emailTextField(null, "Email Id", emailIDTxt, TextInputType.emailAddress),

                          const SizedBox(height: 40,),

                          CommonButtonForAllApp(
                              onPressed: (){
                            if(vendorNameTxt.text.isEmpty){
                              Fluttertoast.showToast(msg: "Please enter name");
                            }else if(contactTxt.text.isEmpty){
                              Fluttertoast.showToast(msg: "Please enter contact");
                            }else if(emailIDTxt.text.isEmpty){
                              Fluttertoast.showToast(msg: "Please enter email");
                            }else if(contactTxt.text.length<10){}
                            else {
                              postVendor();
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

 postVendor() async {
    //https://api.creshsolutions.com/vendor
   Map<String,dynamic> obj={
     "vendor_name": vendorNameTxt.text,
     "vendor_email": emailIDTxt.text,
     "vendor_contact": contactTxt.text
   };

   print('add vendor-->$obj');
    var url=Uri.parse("${APIConstant.APIURL}/vendor/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.post(url, body: jsonEncode(obj));
    print("RES-->${response.body}");
     var decodeRes=json.decode(response.body);
      var msg=decodeRes["message"];
      if(msg=="Vendor Created") {
        Fluttertoast.showToast(msg: "Vendor Created successfully");
        vendorNameTxt.clear();
        emailIDTxt.clear();
        contactTxt.clear();
      }else{
        Fluttertoast.showToast(msg: "Vendor Created successfully");
      }

 }
}
