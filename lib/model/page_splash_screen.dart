import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/NavigatorUtils.dart';
import 'home_page.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      Future.delayed(Duration(seconds: 1)).then((value) => {
        NavigatorUtils.pushReplacement(context, HomePage())
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 1920);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Image.asset('images/icons/logo.png',width: ScreenUtil.screenWidth,),
        ),
      ),
    );
  }
}
