import 'package:flutter/material.dart';

import '../widgets/News.dart';
import '../widgets/WidgetList.dart';


class CategoryNews extends StatefulWidget {
  final String newsCategory;

  CategoryNews({required this.newsCategory});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  var newslist;
  bool _loading = true;

  @override
  void initState() {
    getNews();
    super.initState();
  }

  void getNews() async {
    NewsForCategory news = NewsForCategory();
    await news.getNewsForCategory(widget.newsCategory);
    newslist = news.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("News",
                style: TextStyle(
                    color: Color.fromRGBO(1, 204, 255, 1),
                    fontWeight: FontWeight.w600)),
            Text("24",
                style: TextStyle(
                    color: Color.fromRGBO(254, 93, 255, 1),
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic)),
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.share,
                )),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Container(
                  margin: EdgeInsets.only(top: 16),
                  child: ListView.builder(
                      itemCount: newslist.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NewsCard(
                          newslist[index].urlToImage ?? "",
                          newslist[index].title ?? "",
                          newslist[index].desc ?? "",
                          newslist[index].content ?? "",
                          newslist[index].articleUrl ?? "",
                        );
                      }),
                ),
              ),
            ),
    );
  }
}
