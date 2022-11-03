import 'package:flutter/material.dart';
import 'package:untitled/App%20Theme/app_theme.dart';
import 'package:untitled/App%20Theme/asset_files.dart';
import 'package:untitled/App%20Theme/text_fileds.dart';
import 'package:untitled/CustomeWidget/common_button.dart';
import 'package:untitled/View/Admin%20Model/admin_dashboard.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);


  @override
  State<AdminLoginPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AdminLoginPage> {
  final TextEditingController userNameTxt=TextEditingController();
  final TextEditingController passwordTxt=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const SizedBox(height: 40,),
            Text("Welcome Admin",style: StyleForApp.headline,),
            const SizedBox(height: 35,),
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
          const SizedBox(height: 70,),
           CommonTextField.userNameTextField(null, "Username", userNameTxt, TextInputType.name),
            const SizedBox(height: 10,),
           CommonTextField.userNameTextField(null, "Password", userNameTxt, TextInputType.name),
            const SizedBox(height: 20,),
            CommonButtonForAllApp(title: 'Login',onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDashboardPage()));
            },),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(right: 30.0,top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot Password?",style: StyleForApp.textStyle14dp,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}