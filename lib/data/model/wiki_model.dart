import 'dart:convert';

class WikiModel{

  final bool batchcomplete;
  final List<Pages> pages;

  WikiModel(this.batchcomplete, this.pages);


  // WikiModel({this.title, this.poster});
  //
  // factory WikiModel.fromJson(Map<String, dynamic> json) {
  //   return WikiModel(
  //       batchcomplete: json["batchcomplete"],
  //       pagesItem: json["pages"]
  //   );
  // }

}

class Pages {
  String title;
  Thumbnail? thumbnail;
  //Terms terms;

  Pages({required this.title, this.thumbnail});

  factory Pages.fromJson(Map<String, dynamic> json) {

    // var thumbnail = json['thumbnail'];

    return Pages(
        title: json['title'],
        thumbnail: Thumbnail.fromJson(json['thumbnail'] == null ? jsonEncode(Thumbnail(source: "").toString()) : json['thumbnail']),
        //terms: Terms.fromJson(json['terms'])
    );
  }
}

class Thumbnail {
  String? source;

  Thumbnail({this.source});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {

    return Thumbnail(
        source: json['source'] == null ? " " : json['source']
    );
  }

  // factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
  //   source: json["source"]
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   "source": source,
  // };
}

class Terms {
  final String description;

  Terms({required this.description});

  factory Terms.fromJson(Map<String, dynamic> json) {

    return Terms(
        description: json['description']
    );
  }
}

