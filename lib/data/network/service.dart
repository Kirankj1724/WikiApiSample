
import 'package:http/http.dart' as http;

class Service{

  Future fetchWiki(String keyword) async {
    final url = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=150&pilimit=10&wbptterms=description&gpssearch=$keyword&gpslimit=10";
    // print(url);
    final response = await http.get(Uri.parse(url));
    return response;
  }
}