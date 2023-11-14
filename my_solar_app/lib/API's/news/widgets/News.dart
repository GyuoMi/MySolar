import 'dart:convert';

import '../models/Article.dart';
//import '../news/widgets/models/Article.dart';
//import 'package:news24/Api.dart';
import 'package:http/http.dart' as http;

class News {
  String apikey = "f4a3694086644316819752155b38cebf";
  List<Article> news = [];

  Future<void> getNews() async {
    var url = Uri.parse(
        "http://newsapi.org/v2/top-headlines?country=in&excludeDomains=stackoverflow.com&sortBy=publishedAt&language=en&apiKey=$apikey");

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);
    if (jsonData['status'] == "ok") {
      jsonData['articles'].forEach((element) {
        if (element['title'] != null &&
            element['author'] != null &&
            element['publishedAt'] != null &&
            element['content'] != null &&
            element['url'] != null &&
            element['urlToImage'] != null &&
            element['description'] != null) {
          /*
          print(element['title']);
          print(element['author']);
          print(element['description']);
          print(element['urlToImage']);
          print(element['publishedAt']);
          print(element['content']);
          print(element['url']);
          */
          Article article = Article(
              title: element['title'],
              author: element['author'],
              desc: element['description'],
              urlToImage: element['urlToImage'],
              publishedAt: DateTime.parse(element['publishedAt']),
              content: element['content'],
              articleUrl: element['url']);

          news.add(article); //adding article to news list
        }
      });
    }
  }
}

class NewsForCategory {
  String apikey = "f4a3694086644316819752155b38cebf";
  List<Article> news = <Article>[];


  Future<void> getNewsForCategory(String category) async {
    var url = Uri.parse(
        "http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=$apikey");

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData['articles'].forEach((element) {
        if (element['title'] != null &&
            element['author'] != null &&
            element['publishedAt'] != null &&
            element['content'] != null &&
            element['url'] != null &&
            element['urlToImage'] != null &&
            element['description'] != null) {
          /*
          print(element['title']);
          print(element['author']);
          print(element['description']);
          print(element['urlToImage']);
          print(element['publishedAt']);
          print(element['content']);
          print(element['url']);
          */
          Article article = Article(
              title: element['title'],
              author: element['author'],
              desc: element['description'],
              urlToImage: element['urlToImage'],
              publishedAt: DateTime.parse(element['publishedAt']),
              content: element['content'],
              articleUrl: element['url']);

          news.add(article); //adding article to news list
        }
      });
    }
  }
}
