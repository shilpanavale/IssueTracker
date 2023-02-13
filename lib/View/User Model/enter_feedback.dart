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
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';
import 'package:http/http.dart' as http;
import '../../CustomeWidget/custome_dialog.dart';
import '../Admin Model/Model/IssueModel.dart';
import 'api_constant.dart';

class FeedBackPage extends StatefulWidget {
  final IssueModelClass issueModel;
  const FeedBackPage({Key? key, required this.issueModel}) : super(key: key);


  @override
  State<FeedBackPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FeedBackPage> {

  final TextEditingController issueIDTxt=TextEditingController();
  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();
   List<bool> isSelected=[true, false];
   double rating =3;

  File? image;

  bool showAddPhotoUI=false;
  String status="";
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
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: Text("${widget.issueModel.houseComplaintId}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: Text("${widget.issueModel.issue}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: Text("${widget.issueModel.subIssue}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        const SizedBox(height: 10,),
                        if(showAddPhotoUI==true)
                        CommonTextField.commonTextField(null, "Comment", describeComplaintTxt, TextInputType.text)
                       else Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: Text("Description :${widget.issueModel.description}",style: StyleForApp.textStyle15dp,),
                        ),
                        const SizedBox(height: 10,),
                        Visibility(
                          visible: showAddPhotoUI,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
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
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                          child: SizedBox(
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
                                    print("selected==>${isSelected[i]}");
                                    if(isSelected[i]==false){
                                      showAddPhotoUI=false;
                                      status="1";
                                      // updateComplaintStatus(issueModelClass.userComplaintId,"1");

                                    }else{
                                      showAddPhotoUI=true;
                                      status="2";
                                      // updateComplaintStatus(issueModelClass.userComplaintId,"2");

                                    }
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
                                    'Not Resolved',
                                    style: TextStyle(fontSize: 16,color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                        child: RatingBar.builder(
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
                      ),
                        const SizedBox(height: 30,),
                        CommonButtonForAllApp(onPressed: (){
                          if(status=="1"){
                            print("Resolved");
                            updateResolvedStatus(widget.issueModel.houseComplaintId.toString(),"1");
                          }else{
                            print("NOt Resolved");
                            updateNotResolvedStatus(widget.issueModel.houseComplaintId.toString(), "2");

                          }

                       //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyComplaintListPage()));

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


  updateResolvedStatus(String userComalaintId ,String status) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.APIURL}/update-complaint-status/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print("Url-->$url");

    var request= http.MultipartRequest("POST", url);

    request.fields['id'] = userComalaintId;
    request.fields['status'] = status;
    //request.fields['comment'] = describeComplaintTxt.text;
    request.fields['rating'] = rating.toInt().toString();
    print(request.fields);


    request.send().then((response) {
      print(response.statusCode);
      print(response.reasonPhrase);
      if(response.statusCode==200){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Save successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyComplaintListPage()));
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
      /* if(decode["message"].toString().contains("updated")){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Update mark successfully");
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }*/
    });

  }
  updateNotResolvedStatus(String userComalaintId ,String status) async {
    DialogBuilder(context).showLoadingIndicator();
    var url=Uri.parse("${APIConstant.APIURL}/update-complaint-status/?secret=d146d69ec7f6635f3f05f2bf4a51b318");
    print("Url-->$url");

    var request= http.MultipartRequest("POST", url);

    request.fields['id'] = userComalaintId;
    request.fields['status'] = status;
    request.fields['comment'] = describeComplaintTxt.text;
    request.fields['rating'] = rating.toInt().toString();
    print(request.fields);
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
      print(response.statusCode);
      print(response.reasonPhrase);
      if(response.statusCode==200){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Save successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyComplaintListPage()));

      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }
     /* if(decode["message"].toString().contains("updated")){
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Update mark successfully");
      }else{
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(msg: "Something went wrong please try again!");
      }*/
    });

  }
}
