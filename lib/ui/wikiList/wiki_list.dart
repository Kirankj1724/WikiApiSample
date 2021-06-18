import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wiki_api_sample/data/model/result_model.dart';
import 'package:wiki_api_sample/data/model/wiki_model.dart';
import 'package:wiki_api_sample/data/network/service.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list_presenter.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list_view.dart';
import 'package:wiki_api_sample/util/screen_util.dart';

class WikiListPage extends StatefulWidget {
  @override
  _WikiListPageState createState() => _WikiListPageState();
}

class _WikiListPageState extends State<WikiListPage> implements WikiListView {


  TextEditingController _wikiSearchKeyController = new TextEditingController();
  List<ResultModel> _wikiSearchList = [];
  bool noData = true, hasLocalData=false;
  String searchMessage = "Let's go!";
  WikiListPresenter? _presenter;
  List<String> _historyList = [];

  @override
  Widget build(BuildContext context) {
    ScreenUtil(context);

    _presenter=WikiListPresenter(this);
    _presenter?.getSearchHistoryFromLocal();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("Wiki Search")),
        body: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                      textAlign: TextAlign.center,
                      controller: _wikiSearchKeyController,
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          _presenter?.getSearchList(value);
                        }
                      },
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil.fontSizeSmall),
                          decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type here to search ...",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ScreenUtil.fontSizeSmall)))),
              if(hasLocalData) Container(
                height: 50,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: _historyList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      alignment: Alignment.center,
                      //color: Colors.blue[(index % 9) * 100],
                      child: Row(mainAxisSize: MainAxisSize.min,children: [Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            _wikiSearchKeyController.text=_historyList[index];
                            _presenter!.getSearchList(_historyList[index]);
                            },
                          child: Container(decoration: BoxDecoration(border: Border.all(color: Colors.grey))
                              ,child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(_historyList[index], style: TextStyle(color: Colors.grey,fontSize: ScreenUtil.fontSizeExtraSmall)),
                              )),
                        ),
                      )]),
                    );
                  },
                ),
              ),
              if (!noData)
                Expanded(
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        itemCount: _wikiSearchList.length,
                        itemBuilder: (BuildContext context, int index) => Card(
                                child: InkWell(
                              child: Column(children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl: _wikiSearchList[index].imageUrl,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _wikiSearchList[index].title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil.fontSizeSmall),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          _wikiSearchList[index].description,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize:
                                                  ScreenUtil.fontSizeSmall))),
                                )
                              ]),
                              onTap: () => {
                                _presenter!.openLinkInBrowser(_wikiSearchList[index].pageId.toString())
                              },
                            )),
                        staggeredTileBuilder: (int index) =>
                            new StaggeredTile.fit(1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0)

                    // ============= ListView ==============

                    // child: ListView.builder(
                    //   itemCount: _wikiSearchList.length,
                    //   itemBuilder: (context, index) {
                    //
                    //     final movie = _wikiSearchList.length;
                    //
                    //     return ListTile(
                    //       contentPadding: EdgeInsets.all(10),
                    //       leading: Container(
                    //         decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //                 fit: BoxFit.cover,
                    //                 image: NetworkImage(_wikiSearchList[index].imageUrl)
                    //             ),
                    //             borderRadius: BorderRadius.circular(6)
                    //         ),
                    //         width: 50,
                    //         height: 100,
                    //       ),
                    //       title: Text(_wikiSearchList[index].title),
                    //     );
                    //   },
                    // ),

                    ),
              if (noData)
                Expanded(
                    child: Center(
                        child: Text(
                  searchMessage,
                  style: TextStyle(
                      fontSize: ScreenUtil.fontSizeMedium, color: Colors.black),
                )))
            ])));
  }

  _updateList(List<ResultModel> value) {
    setState(() {
      searchMessage = "Let's go!";
      noData = false;
      _wikiSearchList = value;
    });
  }

  @override
  onFailLoadText(String msg) {
    setState(() {
      searchMessage = msg;
      noData = true;
    });
  }

  @override
  onShowSearchResult(List<ResultModel> value) {
    setState(() {
      searchMessage = "Let's go!";
      noData = false;
      _wikiSearchList = value;
    });
  }

  @override
  hideLoading() {
    setState(() {
      noData = false;
    });
  }

  @override
  showLoading() {
    setState(() {
      searchMessage = "Searching ....";
      noData = true;
    });
  }

  @override
  displaySearchHistory(List<String> list) {
    setState(() {
      _historyList=list;
      hasLocalData=true;
    });
  }
}