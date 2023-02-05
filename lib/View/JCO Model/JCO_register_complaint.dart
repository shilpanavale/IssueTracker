import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_dialog.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/User%20Model/Model/HouseModelPage.dart';
import 'package:untitled/View/User%20Model/Model/IssueTypeModelPage.dart';
import 'package:untitled/View/User%20Model/Model/LocationModelPage.dart';
import 'package:untitled/View/User%20Model/Model/SubIssueTypeModelPage.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;

import '../User Model/api_constant.dart';
import 'JCO_complaints_list.dart';
import 'Model/JCOLocationModel.dart';


class JCORegisterComplaint extends StatefulWidget {
  const JCORegisterComplaint({Key? key}) : super(key: key);


  @override
  State<JCORegisterComplaint> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<JCORegisterComplaint> {

  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();

  dynamic selectIssueType;
  dynamic selectSubIssueType;
  dynamic selectedLocation;
  dynamic selectedHouseType;
  dynamic selectHouseNo;
  List<HouseNumberModel> houseList=[];
  List<JCOLocationData> locationList=[];
  List<IssueTypeModel> issueTypeList=[];
  List<SubIssueTypeModel> subIssueTypeList=[];

  List<AccommodationModel> accommodationList=[];

  File? image1;
  File? image2;
  File? image3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationList();

  }
  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOComplaintList()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOComplaintList()));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("JCO Dashboard",style: StyleForApp.appBarTextStyle,),
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
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint:  const Text(" Select Location",
                                      style: TextStyle(fontWeight: FontWeight.w400,
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
                                    setState(() {
                                      selectedHouseType=null;
                                      selectHouseNo=null;
                                      selectedLocation=newValue;
                                      print('selectedLocation--->$selectedLocation');
                                      getHouseList(selectedLocation);
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
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<AccommodationModel>(
                                  hint:  const Text(" Select House Type",
                                      style:  TextStyle(fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: Colors.black38)
                                  ),

                                  value: selectedHouseType,
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
                                        selectHouseNo=newValue!.houseId;
                                        selectedHouseType=newValue;
                                      });
                                    }else{
                                      Fluttertoast.showToast(msg: "Please first select location");
                                    }
                                  },
                                  items: accommodationList.map((AccommodationModel value) {
                                    return DropdownMenuItem<AccommodationModel>(
                                      value: value,
                                      child: Text(value.houseNo!),
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
                              height: 90,
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
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8.0),
                                  // prefixIcon: Icon(icon, color: SavangadiAppTheme.grey,),
                                  counterText: "",
                                  // iconColor: ColorsForApp.lightGrayColor,
                                  isDense: true,
                                  fillColor: Colors.black,
                                  //border: OutlineInputBorder(),
                                  labelText: "Description",
                                  labelStyle:  TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0, color: Colors.black38),

                                  border: InputBorder.none,

                                ),
                                minLines: 1,
                                maxLines: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 20.0,bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Text("Upload Images (upto 3)",textAlign: TextAlign.start,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // CommonTextField.commonTextField(null, "Add Photos", stationTxt, TextInputType.text),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      pickImage1();
                                    },
                                    child:image1!=null?
                                    Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: Image.file(image1!)
                                    )
                                        :Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: const Icon(Icons.camera_alt)
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      pickImage2();
                                    },
                                    child:image2!=null?
                                    Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: Image.file(image2!)
                                    )
                                        :Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: const Icon(Icons.camera_alt)
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      pickImage3();
                                    },
                                    child:image3!=null?
                                    Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: Image.file(image3!)
                                    )
                                        :Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: ColorsForApp.grayColor,
                                            border: Border.all()
                                        ),
                                        child: const Icon(Icons.camera_alt)
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(height: 40,),
                          CommonButtonForAllApp(
                              onPressed: (){
                                if(selectedLocation.toString().isEmpty || selectedLocation==null||selectedLocation==""){
                                  Fluttertoast.showToast(msg: "Please select location");
                                }else if(selectedHouseType.toString().isEmpty || selectedHouseType==null||selectedHouseType==""){
                                  Fluttertoast.showToast(msg: "Please select house type");
                                } else{
                                  DialogBuilder(context).showLoadingIndicator();
                                  postComplaint();
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
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

  getLocationList() async {
    //DialogBuilder(context).showLoadingIndicator();
    //https://samadhantest.creshsolutions.com/drop-down/1?user_type=1&location=&secret=d146d69ec7f6635f3f05f2bf4a51b318
    var url=Uri.parse("${APIConstant.jcoLocationList}&secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print(url);
    var response= await http.get(url);
    var decodeRes=json.decode(response.body);
    if (response.statusCode == 200) {
      print("decodeRes-->$decodeRes");
      var data=decodeRes["data"] as List;

      locationList = data.map((tagJson) => JCOLocationData.fromJson(tagJson)).toList();

      setState(() {});
      //DialogBuilder(context).hideOpenDialog();
    } else {
      // DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to Location house list');
    }

  }
  getHouseList(String selectedLocation) async {
    DialogBuilder(context).showLoadingIndicator();

    var url=Uri.parse("${APIConstant.jcoLocationList}$selectedLocation&secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.get(url);
    print("Accomadation-->$url");
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body);
      print("accommodationList-->$decodeRes");
      var data=decodeRes["data"] as List;
      accommodationList = data.map((tagJson) => AccommodationModel.fromJson(tagJson)).toList();
      setState(() {});
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load Accomadation list');
    }
  }



  postComplaint() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId=preferences.getInt(UT.userId);


    var url=Uri.parse("${APIConstant.APIURL}/gc-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var request = http.MultipartRequest("POST", url);
    request.fields['user_id'] = "33";
    request.fields['user_type'] = "2";
    request.fields['house_id'] = selectHouseNo;
    request.fields['description'] =describeComplaintTxt.text.isNotEmpty? describeComplaintTxt.text:"";
    print(request.fields);
    if(image1?.path!=null){
      request.files.add(
          http.MultipartFile.fromBytes(
              'fileToUpload[]',
              File(image1!.path).readAsBytesSync(),
              filename: image1!.path.split("/").last
          )
      );
    }if(image2?.path!=null){
      request.files.add(
          http.MultipartFile.fromBytes(
              'fileToUpload[]',
              File(image2!.path).readAsBytesSync(),
              filename: image2!.path.split("/").last
          )
      );
    }if(image3?.path!=null){
      request.files.add(
          http.MultipartFile.fromBytes(
              'fileToUpload[]',
              File(image3!.path).readAsBytesSync(),
              filename: image3!.path.split("/").last
          )
      );
    }
    print(request.files);

    print("url of register complaint-->${url}");
    request.send().then((response) {
      print(response.statusCode);
      print(response.reasonPhrase);
      if (response.statusCode == 201){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Complaint Registered successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const JCOComplaintList()));

      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
    });
  }

  Future pickImage1() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image1 = imageTemp;
        addPhotosTxt.text=imageTemp.path.split('/').last;
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  Future pickImage2() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image2 = imageTemp;
        addPhotosTxt.text=imageTemp.path.split('/').last;
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  } Future pickImage3() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        image3 = imageTemp;
        addPhotosTxt.text=imageTemp.path.split('/').last;
      });
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
}