
import 'package:flutter/material.dart';

import '../models/CategoryModel.dart';
import '../widgets/Data.dart';
import '../widgets/Drawer.dart';
import '../widgets/News.dart';
import '../widgets/WidgetList.dart';
import '../widgets/screens/CategoryNews.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var loading;
  var newslist;

  List<CategoryModel> categories = <CategoryModel>[];

  Future getNews() async {
    News news = News();
    await news.getNews();
    newslist = news.news;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading = true;
    categories = getCategories();
    getNews();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
          child: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
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
                      ],
                    ),
                  ),
                )),
      drawer: DrawerWidget(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String imageAssetUrl, categoryName;

  CategoryCard({required this.imageAssetUrl, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryNews(
                      newsCategory: categoryName.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 14),
        child: Stack(
          children: <Widget>[
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(5),
            //   child: CachedNetworkImage(
            //     imageUrl: imageAssetUrl,
            //     height: 60,
            //     width: 120,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black26),
              child: Text(
                categoryName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
