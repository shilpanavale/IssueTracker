import 'package:flutter/material.dart';
import 'package:untitled/App%20Theme/app_theme.dart';

class CommonButtonForAllApp extends StatelessWidget {
  const CommonButtonForAllApp({Key? key, required this.onPressed,required this.title,}) : super(key: key);
  final GestureTapCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 30, left: 30),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                 color: ColorsForApp.appButtonColor,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: ColorsForApp.appButtonColor.withOpacity(
                            0.6),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 3.0),
                  ],
                  gradient: LinearGradient(colors: [
                    ColorsForApp.appButtonColor,
                    ColorsForApp.appButtonColor,
                  ]),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: TextButton(
                onPressed: onPressed,
                child:  Text(
                  title,
                  style:  TextStyle(fontSize:20,fontWeight:FontWeight.w700,color: ColorsForApp.whiteColor),
                ),
              ),
            ),
          ],
        )
    );
  }

}


