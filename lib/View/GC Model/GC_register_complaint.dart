import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_dialog.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/User%20Model/Model/LocationModelPage.dart';
import 'package:http/http.dart' as http;
import '../User Model/api_constant.dart';
import 'GC_complaints_list.dart';
import 'Model/CabinModel.dart';


class GCRegisterComplaint extends StatefulWidget {
  const GCRegisterComplaint({Key? key}) : super(key: key);


  @override
  State<GCRegisterComplaint> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GCRegisterComplaint> {

  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();

  dynamic selectIssueType;
  dynamic selectSubIssueType;
  dynamic selectedArea;
  dynamic selectedHouseType;
  dynamic selectCompany;
  dynamic selectedBatallion;
  dynamic selectHouseNo;
  dynamic selectCabin;
  List<HouseNumberModel> companyList=[];
  List<CabinModel> cabinList=[];
  List<dynamic> selectedCabinList=[];
  List<dynamic> sendCabinListToAPI=[];
  List<LocationModelClass> locationList=[];
  List<AccommodationModel> batallionList=[];
  List<TextEditingController> _controllers = [];
  final List<FocusNode>  focusNode = [];
   Map<String, dynamic> cabinMap = {};
  File? image1;
  File? image2;
  File? image3;
      List<MultiSelectItem<CabinModel?>> _items=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   //  _items=List<MultiSelectItem<CabinModel>>;
    getLocationList();


  }
  selectedList(List<String> a){

  }

  Future<bool> willPopScopeBack() async{
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const GCComplaintList()));
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const GCComplaintList()));
          },),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("GC Dashboard",style: StyleForApp.appBarTextStyle,),
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
                                  hint:  const Text("Select Area",
                                      style: TextStyle(fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: Colors.black38)
                                  ),
                                  value: selectedArea,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 20,color: Colors.grey,
                                  ),
                                  isExpanded: true,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedBatallion=null;
                                      selectCompany=null;
                                      selectCabin=null;
                                      selectedArea=newValue;
                                      print('selectedLocation--->$selectedArea');
                                      getAccommodationList(selectedArea);
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
                                  hint:  const Text("Select Batallion",
                                      style:  TextStyle(fontWeight: FontWeight.w400,
                                          fontSize: 15.0, color: Colors.black38)
                                  ),

                                  value: selectedBatallion,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 20,color: Colors.grey,
                                  ),
                                  isExpanded: true,
                                  isDense: true,
                                  onChanged: (newValue) {
                                    if(selectedArea!=null){
                                      setState(() {
                                        selectCompany=null;
                                        selectCabin=null;
                                        selectedBatallion=newValue;
                                        getHouseList(selectedBatallion);

                                      });
                                    }else{
                                      Fluttertoast.showToast(msg: "Please first area");
                                    }
                                  },
                                  items: batallionList.map((value) {
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
                                  hint: const Text("Select Company",style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.w400,
                                      color: Colors.black38)),
                                  value: selectCompany,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 20,color: Colors.grey,
                                  ),
                                  isDense: true,
                                  onChanged: (newValue) {

                                    setState(() {
                                      selectCabin=null;
                                      selectCompany=newValue;
                                      print('selectHouseNo-->$selectCompany');
                                    });
                                    getCabinList(selectedArea,selectedBatallion,selectCompany);
                                  },
                                  items: companyList.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.houseNo.toString(),
                                      child: Text(value.houseNo.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,), Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                            child: _items.isNotEmpty?
                            MultiSelectDialogField(
                                items: _items,
                                title: const Text("Select"),
                                selectedColor: Colors.blue,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.whiteColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                 /* border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),*/
                                ),
                                buttonIcon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  size: 20,color: Colors.grey,
                                ),
                                buttonText: const Text(
                                  "Select Cabin",
                                  style:  TextStyle(
                                    fontSize: 15.0, fontWeight: FontWeight.w400,
                                    color: Colors.black38)
                                ),
                                onConfirm: (results) {
                                  selectedCabinList=results;
                                  if(selectedCabinList.isEmpty){
                                    selectedCabinList.clear();
                                    _controllers.clear();
                                    sendCabinListToAPI.clear();
                                  }

                                  setState(() {

                                  });
                                  print("confirm-->$selectedCabinList");
                                }
                            ):
                            Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(" Select Cabin",style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.w400,
                                      color: Colors.black38)),
                                  Icon(
                                    Icons.arrow_drop_down_circle,
                                    size: 20,color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          selectedCabinList.isNotEmpty
                          ?Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                            child: ListView.builder(
                              itemCount: selectedCabinList.length,
                                shrinkWrap: true,
                                itemBuilder: (context,index){
                                  _controllers.add(new TextEditingController());
                                  focusNode.add(FocusNode());
                                 return Padding(
                                   padding: const EdgeInsets.only(bottom: 8.0),
                                   child:
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text(selectedCabinList[index].cabinNo),
                                       const SizedBox(height: 8,),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Expanded(
                                             child:/* FocusScope(
                                               onFocusChange: (value) {
                                                 if (!value) {
                                                   //here checkAndUpdate();
                                                   var cabinMap={
                                                     "house_id":selectedCabinList[index].houseId,
                                                     "description":_controllers[index].text,
                                                   };
                                                   sendCabinListToAPI.add(cabinMap);

                                                   print("sendCabinListToAPI-->$sendCabinListToAPI");
                                                 }
                                               },*/
                                                Container(
                                                // height: 40,
                                                 decoration: BoxDecoration(
                                                   borderRadius: BorderRadius.circular(10.0),
                                                   color: ColorsForApp.whiteColor,
                                                   // border: Border.all()
                                                 ),
                                                 child: TextFormField(
                                                   controller: _controllers[index],
                                                   textInputAction:TextInputAction.done,
                                                   focusNode: focusNode[index],
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
                                                   onFieldSubmitted: (value){
                                                     focusNode[index].unfocus();
                                                     focusNode[index].nextFocus();

                                                   },
                                                 ),
                                               ),
                                            // ),
                                           ),
                                           const SizedBox(width: 8,),
                                           ElevatedButton(
                                               style: ElevatedButton.styleFrom(
                                                 backgroundColor: ColorsForApp.appButtonColor,
                                               ),
                                               onPressed: (){
                                                 print(selectedCabinList[index].houseId);
                                                 print('Is the value "Maria" in the map:${cabinMap.containsValue(selectedCabinList[index].houseId)}');
                                                 if (cabinMap.containsValue(selectedCabinList[index].houseId)==true) {
                                                   print('inside update');
                                                   print(selectedCabinList[index].houseId);
                                                   // item exists: update it
                                                   //cabinMap.update('house_id', (value) => selectedCabinList[index].houseId);
                                                   //cabinMap.update('description', (value) => _controllers[index].text);
                                                   cabinMap.update('house_id', (value) => selectedCabinList[index].houseId,
                                                       ifAbsent: () => selectedCabinList[index].houseId);
                                                   cabinMap.update('description', (value) => _controllers[index].text,
                                                       ifAbsent: () => _controllers[index].text);
                                                  // sendCabinListToAPI.add(cabinMap);
                                                   print("update-->$sendCabinListToAPI");
                                                   Fluttertoast.showToast(msg: "Update successfully");

                                                   print("sendCabinListToAPI-->$sendCabinListToAPI");
                                                 } else {
                                                   print('inside add');
                                                   // item does not exist: set it
                                                   cabinMap={};
                                                   cabinMap['house_id'] = selectedCabinList[index].houseId;
                                                   cabinMap['description'] = _controllers[index].text;
                                                   sendCabinListToAPI.add(cabinMap);
                                                   Fluttertoast.showToast(msg: "Save successfully");
                                                   print("sendCabinListToAPI-->$sendCabinListToAPI");
                                                 }

                                                 },

                                               child: const Text('Save'))
                                         ],
                                       ),
                                     ],
                                   ),
                                 );
                            }),
                          ):Container(),
                          /*Padding(
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
                          ),*/
                          const SizedBox(height: 10,),

                          const SizedBox(height: 40,),
                          CommonButtonForAllApp(
                              onPressed: (){
                                if(selectedArea.toString().isEmpty || selectedArea==null||selectedArea==""){
                                  Fluttertoast.showToast(msg: "Please select area");
                                }else if(selectedBatallion.toString().isEmpty || selectedBatallion==null||selectedBatallion==""){
                                  Fluttertoast.showToast(msg: "Please select battalion");
                                }else if(selectCompany.toString().isEmpty || selectCompany==null||selectCompany==""){
                                  Fluttertoast.showToast(msg: "Please select company");
                                } else{
                                  DialogBuilder(context).showLoadingIndicator();
                                  postGCComplaint();
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));
                                }
                              }, title: "Submit"),
                          const SizedBox(height: 10,),
                          CommonButtonForAllApp(
                              onPressed: (){
                                selectedArea=null;
                                selectedBatallion=null;
                                selectCompany=null;
                                selectedCabinList.clear();
                                sendCabinListToAPI.clear();
                                _controllers.clear();
                                focusNode.clear();
                                setState(() {

                                });

                              }, title: "Reset"),
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
    var response= await http.get(Uri.parse("${APIConstant.locationList}/?secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=2"));
    var decodeRes=json.decode(response.body) as List;
    if (response.statusCode == 200) {
      print("decodeRes-->$decodeRes");
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

    var url=Uri.parse("${APIConstant.accommodation}/?location=$selectedLocation&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=2");
    var response= await http.get(url);
    print("Accomadation-->$url");
    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      print("accommodationList-->$decodeRes");
      batallionList = decodeRes.map((tagJson) => AccommodationModel.fromJson(tagJson)).toList();
      setState(() {});
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load Accomadation list');
    }
  }
  getHouseList(String selectedAccom ) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.houseNo}/?accomType=$selectedAccom&location=$selectedArea&secret=d146d69ec7f6635f3f05f2bf4a51b318&user_type=2");
    print("House URL-->$url");
    var response= await http.get(url);

    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      print("House No-->$decodeRes");

      companyList = decodeRes.map((tagJson) => HouseNumberModel.fromJson(tagJson)).toSet().toList();

      print("House No-->$companyList");
      setState(() {

      });

      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load house list');
    }

  }

  getCabinList(String location,String battalion,String company ) async {
    DialogBuilder(context).showLoadingIndicator();
    //https://samadhantest.creshsolutions.com/gc-cabin/?secret=d146d69ec7f6635f3f05f2bf4a51b318
    // &location=IMA%20Campus&user_type=2&battalion=Thimayaa%20Bn&company=Sangro

    https://samadhantest.creshsolutions.com/gc-cabin/?secret=d146d69ec7f6635f3f05f2bf4a51b318&location=IMA%20Campus
    // &user_type=2&battalion=Thimayaa%20Bn&company=Sangro
    var url=Uri.parse("${APIConstant.APIURL}/gc-cabin/?secret=d146d69ec7f6635f3f05f2bf4a51b318"
        "&location=$location&user_type=2&battalion=$battalion&company=$company");
    print("cabin List $url");
    var response= await http.get(url);

    if (response.statusCode == 200) {
      var decodeRes=json.decode(response.body) as List;
      print("House No-->$decodeRes");
      cabinList = decodeRes.map((tagJson) => CabinModel.fromJson(tagJson)).toList();
       _items = cabinList
          .map((cabinRes) => MultiSelectItem<CabinModel>(cabinRes, cabinRes.cabinNo.toString()))
          .toList();
      print("_items-->$_items");
      setState(() {

      });
      DialogBuilder(context).hideOpenDialog();
    } else {
      DialogBuilder(context).hideOpenDialog();
      throw Exception('Failed to load house list');
    }

  }


  postGCComplaint() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId=preferences.getInt(UT.userId);
    Map<String,dynamic> obj={
      "user_id": userId,
      "user_type": '2',
      "cabinMap": sendCabinListToAPI
    };

    var url=Uri.parse("${APIConstant.APIURL}/register-complaint-1/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var response= await http.post(url, body: jsonEncode(obj));

    var decodeRes=json.decode(response.body);
    print("RES-->$decodeRes");
    print(response.statusCode);
    if(response.statusCode==200||response.statusCode==201){
      print("RES-->${decodeRes['message']}");
      if(decodeRes['message']=='Complaint Registered'){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Complaint Registered successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const GCComplaintList()));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Something went wrong please try again!");
    }
  }
/*
/// multipart request
postGCComplaint() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? userId=preferences.getInt(UT.userId);


    var url=Uri.parse("${APIConstant.APIURL}/register-complaint/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    var request = http.MultipartRequest("POST", url);
    request.fields['user_id'] = userId.toString();
    request.fields['user_type'] = "2";
    request.fields['cabinMap'] = sendCabinListToAPI.toString();

   // request.fields['description'] =describeComplaintTxt.text.isNotEmpty? describeComplaintTxt.text:"";
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
      print(response);

      print(response.statusCode);
      print(response.reasonPhrase);
      if (response.statusCode == 201){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Complaint Registered successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const GCComplaintList()));

      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
    });
  }*/

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
class Cabin{
  String name;
  Cabin(this.name);
}

class CustomMultiselectDropDown extends StatefulWidget {
  final Function(List<String>) selectedList;
  final List<CabinModel> listOFStrings;

  const CustomMultiselectDropDown(
      {super.key, required this.selectedList, required this.listOFStrings});

  @override
  createState() {
    return _CustomMultiselectDropDownState();
  }
}

class _CustomMultiselectDropDownState extends State<CustomMultiselectDropDown> {
  List<String> listOFSelectedItem = [];
  String selectedText = "";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration:
      BoxDecoration(border: Border.all(color: Colors.grey)),
      child: ExpansionTile(
        iconColor: Colors.grey,
        title: Text(
          listOFSelectedItem.isEmpty ? "Select" : listOFSelectedItem[0],
        ),
        children: <Widget>[
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.listOFStrings.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: _ViewItem(
                    item: widget.listOFStrings[index],
                    selected: (val) {
                      selectedText = val;
                      if (listOFSelectedItem.contains(val)) {
                        listOFSelectedItem.remove(val);
                      } else {
                        listOFSelectedItem.add(val);
                      }
                      widget.selectedList(listOFSelectedItem);
                      setState(() {});
                    },
                    itemSelected: listOFSelectedItem
                        .contains(widget.listOFStrings[index])),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
 final CabinModel item;
 final bool itemSelected;
  final Function(String) selected;

  _ViewItem(
      {required this.item, required this.itemSelected, required this.selected});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
      EdgeInsets.only(left: size.width * .032, right: size.width * .098),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: Checkbox(
              value: itemSelected,
              onChanged: (val) {
                selected(item.houseId.toString());
              },
              activeColor: Colors.blue,
            ),
          ),
          SizedBox(
            width: size.width * .025,
          ),
          Text(
            item.cabinNo.toString(),

          ),
        ],
      ),
    );
  }
}
