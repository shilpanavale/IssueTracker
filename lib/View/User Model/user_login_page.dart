import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/CustomeWidget/custome_widget.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';
import 'package:untitled/View/User%20Model/otp_page.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);


  @override
  State<UserLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UserLoginPage> {
  TextEditingController phoneController = TextEditingController();

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
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 60,),
            //Text("Welcome User",style: StyleForApp.headline,),
            //const SizedBox(height: 35,),
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
            const SizedBox(height: 40,),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        constraints: const BoxConstraints(
                            maxWidth: 500
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: <TextSpan>[
                            TextSpan(text: 'We will send you an ', style: TextStyle(color: ColorsForApp.blackColor)),
                            TextSpan(
                                text: 'One Time Password ', style: TextStyle(color: ColorsForApp.blackColor, fontWeight: FontWeight.bold)),
                            TextSpan(text: 'on this mobile number', style: TextStyle(color: ColorsForApp.blackColor)),
                          ]),
                        )),
                    const SizedBox(height: 10,),
                    Container(
                      height: 40,
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: ColorsForApp.grayColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        controller: phoneController,
                        maxLength: 10,
                        clearButtonMode: OverlayVisibilityMode.editing,
                        keyboardType: TextInputType.phone,
                        maxLines: 1,
                        placeholder: '+91...',
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      constraints: const BoxConstraints(
                          maxWidth: 500
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: ColorsForApp.appButtonColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(14))
                          ),
                        ),
                         child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  color: ColorsForApp.whiteColor,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                  size: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}