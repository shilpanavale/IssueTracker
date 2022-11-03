import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/User%20Model/Model/HouseModelPage.dart';
import 'package:untitled/View/User%20Model/api_constant.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;

import 'Model/LocationModelPage.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);


  @override
  State<RegisterUser> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RegisterUser> {
 TextEditingController mobileNoTxt=TextEditingController();
  dynamic selectedLocation;
  dynamic selectedAccom;
  dynamic selectHouseNo;

  List<LocationModelClass> locationList=[];
  List<AccommodationModel> accommodationList=[];
  List accommodationList1=["Bungalow","Capts","Lt Col/Maj","Temp/Md"];
  List<HouseNumberModel> houseList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationList();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackLeadingButton(onPressed: (){
          Navigator.of(context).pop();
        },),
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              const SizedBox(height: 40,),
              Text("Welcome User",style: StyleForApp.headline,),
              const SizedBox(height: 35,),
              Container(
                height: 150,
                //width: double.infinity,
                decoration:  const BoxDecoration(
                  color: Colors.transparent,
                  image:  DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      AssetFiles.login1,
                    ),
                  ),

                ),
              ),
            const SizedBox(height: 50,),
             CommonTextField.mobileTextField(null, "Mobile No", mobileNoTxt, TextInputType.phone),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: ColorsForApp.grayColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint:  const Text(" Select Location",
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.black54)
                      ),
                      value: selectedLocation,
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
                          selectedLocation=newValue;
                          getAccommodationList(selectedLocation);
                        });
                      },
                      items: locationList.map((value) {
                        return DropdownMenuItem<String>(
                          value: value.houseLocation,
                          child: Text(value.houseLocation!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              // CommonTextField.commonTextField(null, "Type of accommodation", colonyTxt, TextInputType.text),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: ColorsForApp.grayColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint:  const Text(" Select Accommodation Type",
                          style:  TextStyle(
                              fontSize: 15.0, color: Colors.black54)
                      ),

                      value: selectedAccom,
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
                        if(selectedLocation!=null){
                          setState(() {
                            selectedAccom=newValue;
                            getHouseList(selectedAccom);

                          });
                        }else{
                          Fluttertoast.showToast(msg: "Please first select location");
                        }

                      },
                      items: accommodationList1.map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: ColorsForApp.grayColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text(" Select House number",style: TextStyle(
                          fontSize: 15.0, color: Colors.black54)),
                      value: selectHouseNo,
                      isExpanded: true,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.arrow_drop_down_circle,
                          size: 20,color: Colors.grey,
                        ),
                      ),
                      isDense: true,
                      onChanged: (newValue) {

                        setState(() {
                          selectHouseNo=newValue;
                        });
                      },
                      items: houseList.map((value) {
                        return DropdownMenuItem<String>(
                          value: value.houseNo,
                          child: Text(value.houseNo!),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              CommonButtonForAllApp(title: 'Register',onPressed: (){

                if(mobileNoTxt.text.isEmpty){
                  Fluttertoast.showToast(msg: "Please enter mobile no");
                }else if(mobileNoTxt.text.length<10){
                  Fluttertoast.showToast(msg: "Invalid mobile no");
                }else if(selectedLocation==null||selectedLocation==""){
                  Fluttertoast.showToast(msg: "Please select location");
                }else if(selectedAccom==null||selectedAccom==""){
                  Fluttertoast.showToast(msg: "Please select accommodation type");
                }else if(selectHouseNo==null||selectHouseNo==""){
                  Fluttertoast.showToast(msg: "Please select house no");
                }
                else{
                  APIConstant.location=selectedLocation;
                  APIConstant.accommodationType=selectedAccom;
                  APIConstant.house=selectHouseNo;
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));

                }
                },),
              const SizedBox(height: 10,),

            ],
          ),
        ),
      ),
    );
  }


  getLocationList() async {

   var response= await http.get(Uri.parse(APIConstant.locationList));
   var decodeRes=json.decode(response.body) as List;
   if (response.statusCode == 200) {
     print("decodeRes-->$decodeRes");
     locationList = decodeRes.map((tagJson) => LocationModelClass.fromJson(tagJson)).toList();
     setState(() {

     });
   } else {
     throw Exception('Failed to load house list');
   }

 }
  getAccommodationList(String selectedLocation) async {

    var url=Uri.parse("${APIConstant.accommodation}/$selectedLocation");
    var response= await http.get(url);
    print("Accomadation-->$url");
   if (response.statusCode == 200) {
     var decodeRes=json.decode(response.body) as List;
     print("accommodationList-->$decodeRes");
     accommodationList = decodeRes.map((tagJson) => AccommodationModel.fromJson(tagJson)).toList();
      setState(() {

      });
   } else {
     throw Exception('Failed to load house list');
   }

 }
  getHouseList(String selectedAccom ) async {

    var url=Uri.parse("${APIConstant.houseNo}/$selectedAccom");
    print("Accom URL-->$url");
    var response= await http.get(url);

    if (response.statusCode == 200) {
     var decodeRes=json.decode(response.body) as List;
      print("House No-->$houseList");
       houseList = decodeRes.map((tagJson) => HouseNumberModel.fromJson(tagJson)).toList();
      setState(() {

      });
    } else {
      throw Exception('Failed to load house list');
    }

  }
}