import 'dart:convert';

import 'package:wiki_api_sample/data/model/result_model.dart';
import 'package:wiki_api_sample/data/network/service.dart';
import 'package:wiki_api_sample/ui/wikiList/wiki_list_view.dart';
import 'package:wiki_api_sample/util/network_util.dart';
import 'package:wiki_api_sample/util/string_util.dart';

class WikiListPresenter {
  WikiListView? _view;

  WikiListPresenter(WikiListView view) {
    this._view = view;
  }

  Future getSearchList(String keyword) async {
    if (_view != null) {
      _view!.showLoading();

      try{
        var response = await Service().fetchWiki(keyword);
        if (NetworkUtil.isReqSuccess(response)) {
          final body = jsonDecode(response.body);
          final query = body["query"];

          List<ResultModel> list = [];

          if (query.toString().contains("pages")) {
            List<dynamic> pageList = query["pages"];
            for (int i = 0; i < pageList.length; i++) {
              var pageItem = pageList[i];
              String title = "No title available";
              String imageUrl = "";
              String description = "";

              title = pageItem["title"];

              if (pageItem.toString().contains("thumbnail"))
                imageUrl = pageItem["thumbnail"]["source"];
              else
                imageUrl = "https://static.thenounproject.com/png/1554490-200.png";

              if (pageItem.toString().contains("terms")) {
                var terms = pageItem["terms"];
                List<dynamic> descriptionList = terms["description"];

                for (int j = 0; j < descriptionList.length; j++) {
                  description = description + descriptionList[j] + "\n";
                }
              } else
                description = "No description available";

              //print(title+"\n"+imageUrl+"\n"+description);

              ResultModel model = ResultModel(title, imageUrl, description);
              list.add(model);
            }
          }

          _view!.hideLoading();

          if(list.length>0)
            _view!.onShowSearchResult(list);
          else
            _view!.onFailLoadText(StringUtil.noResults);


        }
        else {
          _view!.onFailLoadText(StringUtil.networkError);
        }
      }
      catch(error){
        _view!.onFailLoadText(StringUtil.networkError);
      }
    }
  }
}
