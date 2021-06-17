import 'package:wiki_api_sample/data/model/result_model.dart';

abstract class WikiListView{

  onFailLoadText(String msg) {}

  onShowSearchResult(List<ResultModel> movie);

  showLoading();

  hideLoading();
}