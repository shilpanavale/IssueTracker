import 'package:flutter/material.dart';
import 'package:untitled/App%20Theme/app_theme.dart';

class BackLeadingButton extends StatelessWidget {
  const BackLeadingButton({Key? key, required this.onPressed}) : super(key: key);
  final GestureTapCallback onPressed;


  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          color: ColorsForApp.appButtonColor.withAlpha(20),
        ),
        child: Icon(Icons.arrow_back_ios, color: ColorsForApp.blackColor, size: 16,),
      ),
      onPressed: onPressed,
    );
  }

}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({Key? key, required this.title, required this.mobile,}) : super(key: key);
  final String title;
  final String mobile;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title,style: StyleForApp.appBarTextStyle,),
          ],
        ),Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(mobile,style: StyleForApp.textStyle15dp,),
          ],
        ),
      ],
    );
  }

}