import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';

import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/complaints_list.dart';
import 'package:untitled/View/GC%20Model/gc_admin_complaints_list.dart';
import 'package:untitled/View/JCO%20Model/jco_admin_complaints_list.dart';

import '../Admin Model/Model/IssueModel.dart';
import '../User Model/api_constant.dart';


class DetailsScreen extends StatefulWidget {
  final String statusFlag;
  final IssueModelClass issueModel;
  const DetailsScreen({Key? key, required this.issueModel, required this.statusFlag}) : super(key: key);


  @override
  State<DetailsScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DetailsScreen> {
  ScreenshotController fullPageScreenshot = ScreenshotController();
  dynamic userType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  getData() async {
    final prefs = await SharedPreferences.getInstance();
    userType= prefs.getString(UT.appType);

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackLeadingButton(onPressed: () {
          if(userType=="1"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> JCOAdminComplaintListPage(statusFlag: widget.statusFlag,)));

          }else if(userType=="2"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GCAdminComplaintListPage(statusFlag: widget.statusFlag,)));

          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminComplaintList(statusFlag: widget.statusFlag,)));
          }
        },),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            userType=="1"?
            Text("JCO/OR Admin Dashboard",style: StyleForApp.appBarTextStyle,)
            :userType=="2"?
             Text("GC Admin Dashboard",style: StyleForApp.appBarTextStyle,)
            :Text("Officer Admin Dashboard",style: StyleForApp.appBarTextStyle,),
          ],
        ),
      ),
      body: Screenshot(
        controller: fullPageScreenshot,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("complaint Details",style: StyleForApp.subHeadline,),
                  const SizedBox(height: 30,),
                  Container(
                    width: double.infinity,
                   // height: 40,
                    decoration: BoxDecoration(
                        color: HexColor("#4A50C9").withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          Text("${widget.issueModel.houseComplaintId}",style: StyleForApp.textStyle15dp,),
                          const SizedBox(height: 10,),
                          userType=="1"||userType=="2"?Container():
                          Text("${widget.issueModel.issue}",style: StyleForApp.textStyle15dp,),
                          const SizedBox(height: 10,),
                          userType=="1"||userType=="2"?Container():
                          Text("${widget.issueModel.subIssue}",style: StyleForApp.textStyle15dp,),
                          const SizedBox(height: 10,),
                          Text(widget.issueModel.mobileNo ?? "",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),

                          widget.issueModel.comment==null||widget.issueModel.comment==""?
                          Container(): Row(
                            children: [
                              Text("User Comment : ", textAlign:TextAlign.start,style: StyleForApp.textStyle15dpBold,),
                              Text(widget.issueModel.comment!=null?widget.issueModel.comment.toString(): "", textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
                            ],
                          ),

                          widget.issueModel.rating==null||widget.issueModel.rating==""?
                          Container():Padding(
                            padding: const EdgeInsets.only(top: 3, bottom: 10, right: 0, left: 0),
                            child: RatingBar.builder(
                              initialRating: double.parse(widget.issueModel.rating),
                              minRating: 1,
                              tapOnlyMode: false,
                              itemSize: 20,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,size: 10,
                              ),
                              onRatingUpdate: (rating1) {

                              },
                            ),
                          ),
                          const SizedBox(height: 10,),

                              widget.issueModel.imageUrl2==null||widget.issueModel.imageUrl2==""?
                          const Text("No image available after feedback!") :Container(
                            //  height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorsForApp.whiteColor,
                                  border: Border.all(color: ColorsForApp.grayLabelColor)
                              ),
                              child: Image.network("https://creshsolutions.com/images/samadhan/complaint_images/${widget.issueModel.imageUrl2.toString()}"
                                  ,
                               // height: 300,
                                frameBuilder: (_, image, loadingBuilder, __) {

                                  if (loadingBuilder == null) {

                                    return const SizedBox(
                                      //height: 300,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return image;
                                },
                                loadingBuilder: (BuildContext context, Widget child,
                                  ImageChunkEvent? loadingProgress) {

                              if (loadingProgress == null) return child;
                              return Center(
                              child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                                  : null,
                              ),
                              );
                              },)
                          ),
                          widget.issueModel.status.toString().toLowerCase()=="Assigned".toLowerCase()
                              ?widget.issueModel.imageUrl==null||widget.issueModel.imageUrl==""?
                          const Text("No image available during registration!") :Container(
                             // height: 300,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: ColorsForApp.whiteColor,
                                  border: Border.all(color: ColorsForApp.grayLabelColor)
                              ),
                              child:Image.network("https://creshsolutions.com/images/samadhan/complaint_images/${widget.issueModel.imageUrl.toString()}"
                                ,
                               // height: 300,
                                frameBuilder: (_, image, loadingBuilder, __) {
                                //  print(loadingBuilder);
                                  if (loadingBuilder == null) {

                                    return const SizedBox(
                                      //height: 300,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return image;
                                },
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                //  print('loading bu00$loadingProgress');
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },)

                              //Image.network("https://creshsolutions.com/images/samadhan/complaint_images/${widget.issueModel.imageUrl.toString()}")
                          ):Container(),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.issueModel.issueCreatedOn!=null?widget.issueModel.issueCreatedOn!:"",textAlign:TextAlign.start,style: StyleForApp.textStyle15dp,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {

                                        //screenshotController=ScreenshotController();
                                        await fullPageScreenshot.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? imageFile) async {
                                          if (imageFile != null) {
                                            final directory = await getApplicationDocumentsDirectory();
                                            final imagePath = await File('${directory.path}/image.png').create();
                                            await imagePath.writeAsBytes(imageFile);


                                            /// Share Plugin
                                            await Share.shareXFiles([XFile(imagePath.path)], text: '');
                                          }
                                        });


                                      },
                                      child: SizedBox(
                                        width: 100,
                                        child: Row(
                                          children: [
                                            const SizedBox(width: 8,),
                                            Container(
                                              height: 25,width: 25,
                                              decoration:  const BoxDecoration(
                                                color: Colors.transparent,
                                                image:  DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                    AssetFiles.share,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Text("Share",style: StyleForApp.extraSmaller12dp,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 10,),

                        ],
                      ),
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

}



