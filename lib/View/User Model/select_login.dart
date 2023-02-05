import 'package:flutter/material.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/user_admin_dashboard.dart';
import 'package:untitled/View/Admin%20Model/admin_login_page.dart';
import 'package:untitled/View/User%20Model/register_user.dart';
import 'package:untitled/View/User%20Model/user_login_page.dart';


class SelectLoginTypePage extends StatefulWidget {
  const SelectLoginTypePage({Key? key}) : super(key: key);


  @override
  State<SelectLoginTypePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SelectLoginTypePage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController passwordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50,),
            Text("Select Login Type",style: StyleForApp.headline,),
            const SizedBox(height: 45,),
            Padding(
              padding: const EdgeInsets.only(left: 25.0,right: 25.0,top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UserLoginPage()));
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color:ColorsForApp.appButtonColor ,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: ColorsForApp.appButtonColor.withOpacity(
                                    0.3),
                                //offset: const Offset(1.1, 1.1),
                                blurRadius: 3.0),
                          ],
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text("Login",style: TextStyle(
                            // fontFamily: fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.27,
                            color: ColorsForApp.whiteColor,
                          ),),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterUser()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        //width: double.infinity,
                        decoration: BoxDecoration(
                           color:ColorsForApp.appButtonColor ,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: ColorsForApp.appButtonColor.withOpacity(
                                      0.2),
                                  //offset: const Offset(1.1, 1.1),
                                  blurRadius: 3.0),
                            ],
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child:Center(child: Text("Register",style:   TextStyle(
                            // fontFamily: fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.27,
                            color: ColorsForApp.whiteColor,
                          ),
                          ))
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            


          ],
        ),
      ),
    );
  }
}