import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list.dart';
import 'package:wiki_api_sample/util/screen_util.dart';

class SplashPage extends StatefulWidget{
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  Widget build(BuildContext context) {

    ScreenUtil(context);
    
    doStartTimerAction(context);
    
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Text("WiKi API Sample", style: TextStyle(color: Colors.white, fontSize: ScreenUtil.fontSizeLarge)))
    );
  }
}

void doStartTimerAction(BuildContext context) {

  Timer(
      Duration(seconds: 3),
          () =>  {
            navigateToWikiListPage(context)
      });
}

navigateToWikiListPage(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WikiListPage() ));
}