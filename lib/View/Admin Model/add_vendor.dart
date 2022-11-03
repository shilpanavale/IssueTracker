import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/vendor_list.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';

class AddVendor extends StatefulWidget {
  const AddVendor({Key? key}) : super(key: key);


  @override
  State<AddVendor> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddVendor> {

  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();

  var selectIssueType;
  var selectedLocation;
  var selectedAccom;
  var selectedHouse;
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
  List<dynamic> locationList=[
    {
      "id":"1",
      "value":"Main Road",
    },
    {
      "id":"2",
      "value":"Tones view",
    },
    {
      "id":"3",
      "value":"Main Road",
    },
  ];List<dynamic> accommodationList=[
    {
      "id":"1",
      "value":"Bungalow",
    },
    {
      "id":"2",
      "value":"Capts",
    },
    {
      "id":"3",
      "value":"Bungalow",
    },
  ];
  List<dynamic> houseList=[
    {
      "id":"1",
      "value":"P-1",
    },
    {
      "id":"2",
      "value":"P-2",
    },
    {
      "id":"3",
      "value":"P-3",
    },
  ];
  File? image;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                  Text("Add Vendor",style: StyleForApp.subHeadline,),
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
                        Padding(
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
                        ),
                        const SizedBox(height: 10,),
                         CommonTextField.commonTextField(null, "Vendor Name", describeComplaintTxt, TextInputType.text),
                        const SizedBox(height: 10,),
                         CommonTextField.commonTextField(null, "Vendor Contact Number", describeComplaintTxt, TextInputType.text),
                        const SizedBox(height: 10,),
                        CommonTextField.emailTextField(null, "Email Id", describeComplaintTxt, TextInputType.text),

                        const SizedBox(height: 40,),

                        CommonButtonForAllApp(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
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
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        addPhotosTxt.text=imageTemp.path.split('/').last;
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
}
