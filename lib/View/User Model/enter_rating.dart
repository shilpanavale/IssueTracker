import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;
import '../../CustomeWidget/custome_dialog.dart';
import '../Admin Model/Model/IssueModel.dart';
import 'api_constant.dart';

class GiveRating extends StatefulWidget {
  IssueModelClass issueModel;
   GiveRating({Key? key, required this.issueModel}) : super(key: key);


  @override
  State<GiveRating> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GiveRating> {

  final TextEditingController issueIDTxt=TextEditingController();
  final TextEditingController issueTxt=TextEditingController();
  final TextEditingController subIssueTxt=TextEditingController();
  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();
   List<bool> isSelected=[true, false];
   double rating =3;

  File? image;
  @override
  void initState() {
    // TODO: implement initState
    issueIDTxt.text=widget.issueModel.houseComplaintId.toString();
    issueTxt.text=widget.issueModel.issue.toString();
    subIssueTxt.text=widget.issueModel.subIssue.toString();
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
                  Text("Give Feedback",style: StyleForApp.subHeadline,),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text("${widget.issueModel.houseComplaintId}",style: StyleForApp.textStyle15dp,),
                       ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.issueModel.issue}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${widget.issueModel.subIssue}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Description :${widget.issueModel.subIssue}",style: StyleForApp.textStyle15dp,),
                        ),
                        //CommonTextField.disableTextField(null, "Comment", describeComplaintTxt, TextInputType.text),
                        const SizedBox(height: 10,),
                      /*  Padding(
                          padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                          child: Row(
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
                              ):
                              Container(
                                height: 47,
                                width: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorsForApp.whiteColor,
                                  // border: Border.all()
                                ),
                                child: TextFormField(
                                  controller: addPhotosTxt,
                                  textInputAction: TextInputAction.done,
                                  autofocus: false,
                                  style: const TextStyle(fontSize: 13),
                                  //keyboardType: type,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8.0),
                                    // prefixIcon: Icon(icon, color: SavangadiAppTheme.grey,),
                                    counterText: "",
                                    // iconColor: ColorsForApp.lightGrayColor,
                                    isDense: true,
                                    fillColor: Colors.black,
                                    //border: OutlineInputBorder(),
                                    labelText: "Add Photos",
                                    labelStyle:  TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0, color: ColorsForApp.grayLabelColor),

                                    border: InputBorder.none,

                                  ),
                                  minLines: 1,
                                  maxLines: 2,
                                ),
                              ),
                              Expanded(child: IconButton(onPressed: (){
                                pickImage();
                              }, icon: const Icon(Icons.add_box)))
                            ],
                          ),
                        ),*/
                        const SizedBox(height: 10,),
                       /* SizedBox(
                          height: 40,
                          child: ToggleButtons(
                            disabledBorderColor: ColorsForApp.grayColor,
                            disabledColor: ColorsForApp.grayColor,
                            //color: Colors.black,
                            //borderColor: Colors.black,
                            fillColor: ColorsForApp.appButtonColor,
                            borderWidth: 2,
                            selectedBorderColor: ColorsForApp.appButtonColor,
                            selectedColor: ColorsForApp.appButtonColor,
                            borderRadius: BorderRadius.circular(0),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  isSelected[i] = i == index;
                                }
                              });
                            },
                            isSelected: isSelected,
                            children: const <Widget>[
                              Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text(
                                  'Resolved',
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text(
                                  'Pending',
                                  style: TextStyle(fontSize: 16,color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        const SizedBox(height: 20,),
                     // const Text('Rate Us'),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating1) {

                          rating=rating1;
                          print(rating);
                        },
                      ),
                        const SizedBox(height: 30,),
                        CommonButtonForAllApp(onPressed: (){
                        updateComplaintStatus(widget.issueModel.houseComplaintId!, "1");
                       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));

                        }, title: "Mark Resolved"),
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

  updateComplaintStatus(String userCompaintId ,String status) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.APIURL}/update-complaint-status/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print("Url-->$url");
    Map<String,dynamic> obj={
      "id": userCompaintId,
      "status": status,
      "rating": rating.toInt().toString(),
    };
    var response= await http.post(url,body: jsonEncode(obj));
    print("complaint update status res-->${response.body}");
    var decode=json.decode(response.body);
    //{"message":"Issue status with id 18 updated"}
    if(decode["message"].toString().contains("updated")){
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Update mark successfully");
    }else{
      DialogBuilder(context).hideOpenDialog();
      Fluttertoast.showToast(msg: "Something went wrong please try again!");
    }
  }
}
