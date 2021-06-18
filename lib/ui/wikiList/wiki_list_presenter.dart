import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wiki_api_sample/data/local/database_helper.dart';
import 'package:wiki_api_sample/data/model/result_model.dart';
import 'package:wiki_api_sample/data/network/service.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list_view.dart';
import 'package:wiki_api_sample/util/network_util.dart';
import 'package:wiki_api_sample/util/string_util.dart';
import 'package:url_launcher/url_launcher.dart';

class WikiListPresenter {
  WikiListView? _view;
  final dbHelper = DatabaseHelper.instance;

  WikiListPresenter(WikiListView view) {
    this._view = view;
  }

  Future getSearchList(String keyword) async {
    if (_view != null) {

      _view!.showLoading();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        _getDataFromNetwork(keyword);
      } else {
        _getDataFromLocal(keyword);
      }
    }
  }

  _getDataFromNetwork(String keyword) async{
    try{
      var response = await Service().fetchWiki(keyword);
      if (NetworkUtil.isReqSuccess(response)) {
        _parseResponse(response.body, keyword, true);
      }
      else {
        _view!.onFailLoadText(StringUtil.networkError);
      }
    }
    catch(exception)
    {
      _view!.onFailLoadText(StringUtil.offlineMode);
    }
  }

  _getDataFromLocal(String keyword) async{
    dbHelper.queryForSearchResults(keyword.toLowerCase().trim()).
    then((value) => {
      if(value.isNotEmpty){
        _parseResponse(value[0]['search_content'],keyword,false)
      }
      else{
        _getDataFromNetwork(keyword)
      }
    });
  }

  _parseResponse(String value, String keyword, bool isFromNetwork) {

    final body = jsonDecode(value);
    final query = body["query"];

    List<ResultModel> list = [];

    if (query.toString().contains("pages")) {
      List<dynamic> pageList = query["pages"];
      for (int i = 0; i < pageList.length; i++) {
        var pageItem = pageList[i];
        String title = "No title available";
        String imageUrl = "";
        String description = "";
        int pageId=0;

        pageId=pageItem["pageid"];
        title = pageItem["title"];

        if (pageItem.toString().contains("thumbnail"))
          imageUrl = pageItem["thumbnail"]["source"];
        else
          imageUrl =
          "https://static.thenounproject.com/png/1554490-200.png";

        if (pageItem.toString().contains("terms")) {
          var terms = pageItem["terms"];
          List<dynamic> descriptionList = terms["description"];

          for (int j = 0; j < descriptionList.length; j++) {
            description = description + descriptionList[j] + "\n";
          }
        } else
          description = "No description available";

        //print(title+"\n"+imageUrl+"\n"+description);

        ResultModel model = ResultModel(pageId.toString(),title, imageUrl, description);
        list.add(model);
      }
    }

    _view!.hideLoading();

    if (list.length > 0) {
      if(isFromNetwork)
        _insert(keyword.toLowerCase().trim(), value);
      _view!.onShowSearchResult(list);
    }
    else
      _view!.onFailLoadText(StringUtil.noResults);

  }

  _insert(String searchKey, String searchResult) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnTitle: searchKey,
      DatabaseHelper.columnContent: searchResult
    };
    final id = await dbHelper.insert(row);
    // print('inserted row id: $id');

    // if (id != null)
    //   return true;
    // else
    //   return false;
  }

  void getSearchHistoryFromLocal() {

    List<String> list=[];

    dbHelper.queryAllRows()
        .then((value) => {
            if(value.isNotEmpty)
              {
                value.forEach((row) => list.add(row['search_key'])),
                _view?.displaySearchHistory(list)
              }
            else
              {

              }
        })
        .catchError((error) => {
          print(error.toString())
    });

  }

  openLinkInBrowser(String pageId) async {
    try{
      // await launch(dotenv.env['MAIL_TO_URL']);
      await launch('https://en.wikipedia.org/?curid=$pageId');
    }
    catch(e)
    {
      print(e);
    }
  }

}




