import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/User%20Model/Model/HouseModelPage.dart';
import 'package:untitled/View/User%20Model/Model/IssueTypeModelPage.dart';
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

  /*List<dynamic> issueTypeList=[
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
  ];
  List<dynamic> subIssueTypeList=[
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
  ];*/
 List<dynamic> accommodationList=[];

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationList();
    getIssueType();
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
                                    print('selectHouseNo-->$selectHouseNo');
                                  });
                                },
                                items: houseList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.houseId,
                                    child: Text(value.houseNo!),
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
                                    selectIssueType=newValue;
                                    print('selectIssueType-->$selectIssueType');
                                    getSubIssueType(selectIssueType);
                                  });
                                },
                                items: issueTypeList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.issueId,
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
                                    print('selectSubIssueType--->$selectSubIssueType');
                                  });
                                },
                                items: subIssueTypeList.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.subIssueId,
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

    var url=Uri.parse("${APIConstant.houseNo}/$selectedAccom/$selectedLocation");
    print("House URL-->$url");
    var response= await http.get(url);

    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      print("House No-->$decodeRes");
      houseList = decodeRes.map((tagJson) => HouseNumberModel.fromJson(tagJson)).toList();
      print("House No-->$houseList");
      setState(() {

      });
    } else {
      throw Exception('Failed to load house list');
    }

  }

  getIssueType() async {

    var url=Uri.parse("${APIConstant.APIURL}/issue-category");
    print("Issue-category URL-->$url");
    var response= await http.get(url);
    print("Issue-category URL-->${response.body}");
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;

      issueTypeList = decodeRes.map((tagJson) => IssueTypeModel.fromJson(tagJson)).toList();
      print("IssueTypeModel -->$issueTypeList");
      setState(() {

      });
    } else {
      throw Exception('Failed to load house list');
    }

  }

  getSubIssueType(String selecteIssueId) async {

    var url=Uri.parse("${APIConstant.APIURL}/issue-category/$selectIssueType");
    print("House URL-->$url");
    var response= await http.get(url);
    print("sub Issue-category URL-->${response.body}");
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;

      subIssueTypeList = decodeRes.map((tagJson) => SubIssueTypeModel.fromJson(tagJson)).toList();
      print("House No-->$subIssueTypeList");
      setState(() {

      });
    } else {
      throw Exception('Failed to load house list');
    }

  }


  postComplaint() async{

    Map<String,dynamic> obj={
      "cat_issue_id": selectIssueType,
      "sub_issue_id": selectSubIssueType,
      "house_no": selectHouseNo,
      "image_url": addPhotosTxt.text
    };

    print('obj of post complaint--->$obj');
    var url=Uri.parse("${APIConstant.APIURL}/register-complaint");
    var response= await http.post(url, body: jsonEncode(obj));
    print("url of register complaint-->${url}");
    print("RES of register complaint-->${response.body}");
    var decodeRes=json.decode(response.body);
    print("decodeRes of register complaint-->${decodeRes}");
   /* var msg=decodeRes["message"];
    if(msg=="Vendor Created") {
      Fluttertoast.showToast(msg: "Vendor Created successfully");
      vendorNameTxt.clear();
      emailIDTxt.clear();
      contactTxt.clear();
    }else{
      Fluttertoast.showToast(msg: "Vendor Created successfully");
    }*/


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
