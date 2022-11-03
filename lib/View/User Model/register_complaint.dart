import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/User%20Model/Model/HouseModelPage.dart';
import 'package:untitled/View/User%20Model/Model/LocationModelPage.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'api_constant.dart';
import 'package:http/http.dart' as http;

class RegisterComplaint extends StatefulWidget {
  const RegisterComplaint({Key? key}) : super(key: key);


  @override
  State<RegisterComplaint> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RegisterComplaint> {

  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();

  dynamic selectIssueType;
  dynamic selectSubIssueType;
  dynamic selectedLocation;
  dynamic selectedAccom;
  dynamic selectedHouse;
  List<HouseModel> houseList=[];
  List<LocationModelClass> locationList=[];

  List<dynamic> issueTypeList=[
    {
      "id":"1",
      "value":"blockage related issuses",
    },
    {
      "id":"2",
      "value":"E/M regular complaints",
    },
    {
      "id":"3",
      "value":"seepage concerns",
    },{
      "id":"4",
      "value":"additional intra(addn/altn) work",
    },
  ];List<dynamic> subIssueTypeList=[
    {
      "id":"1",
      "value":"sewage",
    },
    {
      "id":"2",
      "value":"plumbing",
    },
    {
      "id":"3",
      "value":"Carpentry",
    },
  ];
 List<dynamic> accommodationList=[];

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackLeadingButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
        },),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("User Dashboard",style: StyleForApp.appBarTextStyle,),
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
                  Text("Register Complaint",style: StyleForApp.subHeadline,),
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
                        //CommonTextField.commonTextField(null, "Location", stationTxt, TextInputType.text),
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
                                hint:  Text(APIConstant.location,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0, color: Colors.black38)
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
                                  /*setState(() {
                                    selectedLocation=newValue;
                                    getAccommodationList(selectedLocation);
                                  });*/
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
                                hint:  Text(APIConstant.accommodationType,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0, color: Colors.black38)
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
                                 /* setState(() {
                                    selectedAccom=newValue;
                                  });*/
                                },
                                items: accommodationList.map((value) {
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
                      //  CommonTextField.commonTextField(null, "House No", houseNameTxt, TextInputType.text),
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
                                hint:  Text(APIConstant.house,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0, color: Colors.black38)
                                ),
                                value: selectedHouse,
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
                                    selectedHouse=newValue;
                                  });
                                },
                                items: houseList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.houseNo,
                                    child: Text(value.houseLocation!),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
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
                                hint:  Text(" Select Sub Issue Type",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0, color: ColorsForApp.grayLabelColor)
                                ),
                                value: selectSubIssueType,
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
                                    selectSubIssueType=newValue;
                                  });
                                },
                                items: subIssueTypeList.map((value) {
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
                       // CommonTextField.commonTextField(null, "Description", describeComplaintTxt, TextInputType.text),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: ColorsForApp.whiteColor,
                              // border: Border.all()
                            ),
                            child: TextFormField(
                              controller: describeComplaintTxt,
                              textInputAction: TextInputAction.done,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                // prefixIcon: Icon(icon, color: SavangadiAppTheme.grey,),
                                counterText: "",
                                // iconColor: ColorsForApp.lightGrayColor,
                                isDense: true,
                                fillColor: Colors.black,
                                //border: OutlineInputBorder(),
                                labelText: "Description",
                                labelStyle:  TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0, color: ColorsForApp.grayLabelColor),

                                border: InputBorder.none,

                              ),
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0,right: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             // CommonTextField.commonTextField(null, "Add Photos", stationTxt, TextInputType.text),
                              image!=null?
                              Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: ColorsForApp.grayColor,
                                     border: Border.all()
                                  ),
                                  child: Image.file(image!)
                              ):Container(
                                height: 47,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorsForApp.whiteColor,
                                  // border: Border.all()
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text("Upload Image",textAlign:TextAlign.start,style: TextStyle(fontSize: 15,color: Colors.black38),),
                                ),
                              ),
                              IconButton(onPressed: (){
                                pickImage();
                              }, icon: const Icon(Icons.add_box))
                            ],
                          ),
                        ),
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

  getHouseList() async {

    var response= await http.get(Uri.parse(APIConstant.houseList));
    var decodeRes=json.decode(response.body) as List;
    if (response.statusCode == 200) {
      houseList = decodeRes.map((tagJson) => HouseModel.fromJson(tagJson)).toList();
      setState(() {
      });

    } else {
      throw Exception('Failed to load house list');
    }

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

    var response= await http.get(Uri.parse("${APIConstant.accommodation}/$selectedLocation"));

    if (response.statusCode == 200) {
      accommodationList=json.decode(response.body) as List;
      print("accommodationList-->$accommodationList");
    //  locationList = decodeRes.map((tagJson) => LocationModelClass.fromJson(tagJson)).toList();

    } else {
      throw Exception('Failed to load house list');
    }

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
