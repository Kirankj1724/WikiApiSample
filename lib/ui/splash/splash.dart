import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wiki_api_sample/ui/splash/splash_presenter.dart';
import 'package:wiki_api_sample/ui/splash/splash_view.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list.dart';
import 'package:wiki_api_sample/util/screen_util.dart';

class SplashPage extends StatefulWidget{
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> implements SplashView {

  SplashPresenter? _presenter;

  @override
  Widget build(BuildContext context) {

    ScreenUtil(context);

    _presenter=SplashPresenter(this);
    _presenter!.doSplashLoading();
    
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Text("WiKi API Sample", style: TextStyle(color: Colors.white, fontSize: ScreenUtil.fontSizeLarge)))
    );
  }

  @override
  void doStartTimerAction() {
    Timer(
        Duration(seconds: 3),
            () =>  {
          navigateToWikiListPage(context)
        });
  }
}

navigateToWikiListPage(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => WikiListPage() ));
}