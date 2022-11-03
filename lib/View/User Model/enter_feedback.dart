import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/User%20Model/my_complaints.dart';

class FeedBackPage extends StatefulWidget {
  const FeedBackPage({Key? key}) : super(key: key);


  @override
  State<FeedBackPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FeedBackPage> {
  final TextEditingController stationTxt=TextEditingController();
  final TextEditingController colonyTxt=TextEditingController();
  final TextEditingController houseNameTxt=TextEditingController();
  final TextEditingController complaintTypeTxt=TextEditingController();
  final TextEditingController describeComplaintTxt=TextEditingController();
  final TextEditingController addPhotosTxt=TextEditingController();
   List<bool> isSelected=[true, false];

  File? image;
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
                      children: [
                        const SizedBox(height: 20,),
                        CommonTextField.commonTextField(null, "Issue ID", stationTxt, TextInputType.text),
                        const SizedBox(height: 10,),
                        CommonTextField.commonTextField(null, "Details", stationTxt, TextInputType.text),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0,right: 30.0),
                          child: Row(
                            children: [
                             // CommonTextField.commonTextField(null, "Add Photos", stationTxt, TextInputType.text),
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
                        const SizedBox(height: 10,),
                        SizedBox(
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
                        ),
                        const SizedBox(height: 20,),
                      const Text('Rate Us'),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                        const SizedBox(height: 30,),
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
