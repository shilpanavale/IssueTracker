import 'dart:convert';
import 'dart:developer';
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
import 'package:untitled/View/User%20Model/Model/issue_type_model_page.dart';
import 'package:untitled/View/User%20Model/Model/LocationModelPage.dart';
import 'package:untitled/View/User%20Model/Model/SubIssueTypeModelPage.dart';
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
  dynamic selectHouseNo;
  List<HouseNumberModel> houseList=[];
  List<LocationModelClass> locationList=[];
  List<IssueTypeModel> issueTypeList=[];
  List<SubIssueTypeModel> subIssueTypeList=[];

  List<dynamic> accommodationList=[];

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationList();
    getIssueType();
  }
  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Officer Dashboard",style: StyleForApp.appBarTextStyle,),
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
                                      selectedAccom=null;
                                      selectHouseNo=null;
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
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint:  const Text(" Select Accommodation Type",
                                      style:  TextStyle(fontWeight: FontWeight.w400,
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
                                    if(selectedLocation!=null){
                                      setState(() {
                                        selectHouseNo=null;
                                        selectedAccom=newValue;
                                        getHouseList(selectedAccom);

                                      });
                                    }else{
                                      Fluttertoast.showToast(msg: "Please first select location");
                                    }
                                  },
                                  items: accommodationList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.houseType,
                                      child: Text(value.houseType!),
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
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  hint: const Text(" Select House number",style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.w400,
                                      color: Colors.black38)),
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
                                      value: value.houseId.toString(),
                                      child: Text(value.houseNo!.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          //CommonTextField.commonTextField(null, "Complaint Type", complaintTypeTxt, TextInputType.text),
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
                                  hint:  const Text(" Select Issue Type",
                                      style:  TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: Colors.black38)
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
                                      selectSubIssueType=null;
                                      selectIssueType=newValue;
                                      getSubIssueType(selectIssueType);
                                    });
                                  },
                                  items: issueTypeList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.issueId.toString(),
                                      child: Text(value.issue.toString()),
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
                                  hint:  const Text(" Select Sub Issue Type",
                                      style:  TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: Colors.black38)
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
                                      value: value.subIssueId.toString(),
                                      child: Text(value.subIssue.toString()),
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
                                  child:  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text("Upload Image",textAlign:TextAlign.start,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black38),),
                                  ),
                                ),
                                IconButton(onPressed: (){
                                  pickImage();
                                }, icon: const Icon(Icons.add_box))
                              ],
                            ),
                          ),
                          const SizedBox(height: 40,),
                          CommonButtonForAllApp(
                              onPressed: (){
                                if(selectedLocation.toString().isEmpty || selectedLocation==null||selectedLocation==""){
                                  Fluttertoast.showToast(msg: "Please select location");
                                }else if(selectedAccom.toString().isEmpty || selectedAccom==null||selectedAccom==""){
                                  Fluttertoast.showToast(msg: "Please select accommodation");
                                }else if(selectHouseNo.toString().isEmpty || selectHouseNo==null||selectHouseNo==""){
                                  Fluttertoast.showToast(msg: "Please select house");
                                }else if(selectIssueType.toString().isEmpty || selectIssueType==null||selectIssueType==""){
                                  Fluttertoast.showToast(msg: "Please select Issue Type");
                                }else if(selectSubIssueType.toString().isEmpty || selectSubIssueType==null||selectSubIssueType==""){
                                  Fluttertoast.showToast(msg: "Please select Sub Issue Type");
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
    var response= await http.get(Uri.parse("${APIConstant.locationList}/?secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=0"));
    var decodeRes=json.decode(response.body) as List;
    if (response.statusCode == 200) {
      locationList = decodeRes.map((tagJson) => LocationModelClass.fromJson(tagJson)).toList();

      setState(() {});
      //DialogBuilder(context).hideOpenDialog();
    } else {
     // DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to Location house list');
    }

  }
  getAccommodationList(String selectedLocation) async {
    DialogBuilder(context).showLoadingIndicator();

    var url=Uri.parse("${APIConstant.accommodation}/?location=$selectedLocation&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=0");
    var response= await http.get(url);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      accommodationList = decodeRes.map((tagJson) => AccommodationModel.fromJson(tagJson)).toList();
      setState(() {});
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load Accomadation list');
    }
  }
  getHouseList(String selectedAccom ) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.houseNo}/?accomType=$selectedAccom&location=$selectedLocation&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=0");
    var response= await http.get(url);

    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      houseList = decodeRes.map((tagJson) => HouseNumberModel.fromJson(tagJson)).toList();
      setState(() {

      });
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load house list');
    }

  }

  getIssueType() async {
    //DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.apiUrl}/issue-category/?secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=0");
    var response= await http.get(url);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;

      issueTypeList = decodeRes.map((tagJson) => IssueTypeModel.fromJson(tagJson)).toList();
      //DialogBuilder(context).hideOpenDialog();
      setState(() {

      });
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load house list');
    }

  }

  getSubIssueType(String selecteIssueId) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.apiUrl}/issue-category/?id=$selectIssueType&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=0");
    var response= await http.get(url);
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;

      subIssueTypeList = decodeRes.map((tagJson) => SubIssueTypeModel.fromJson(tagJson)).toList();
      setState(() {

      });
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to Sub Issue  list');
    }

  }


  postComplaint() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId=preferences.getInt(UT.userId);


    var url=Uri.parse("${APIConstant.apiUrl}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var request = http.MultipartRequest("POST", url);
    var h={
      "Content-Type":"multipart/form-data"
    };
    request.headers.addAll(h);
    request.fields['cat_issue_id']=selectIssueType;
    request.fields['sub_issue_id']=selectSubIssueType;
    request.fields['house_id']=selectHouseNo;
    request.fields['user_id']=userId.toString();
    request.fields['user_type'] ="0";
    request.fields['description'] =describeComplaintTxt.text.isNotEmpty? describeComplaintTxt.text:"";

    if(image?.path!=null){
      request.files.add(
          http.MultipartFile.fromBytes(
              'fileToUpload',
              File(image!.path).readAsBytesSync(),
              filename: image!.path.split("/").last
          )
      );
    }


    request.send().then((response) {
      if (response.statusCode == 201){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Complaint Registered successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));

      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
    });
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
      log(e.toString());
    }
  }
}
