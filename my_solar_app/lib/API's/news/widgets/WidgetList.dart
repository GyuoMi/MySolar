import 'package:flutter/material.dart';

import 'ArticleView.dart';
//import 'package:news24/';

PreferredSizeWidget myAppBar() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("News24",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.italic)),
      ],
    ),
    backgroundColor: Colors.white,
    elevation: 2.0,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: Colors.black,
          ),
        );
      },
    ),
    actions: <Widget>[
      IconButton(
        onPressed: null,
        icon: Icon(Icons.notifications, color: Colors.black),
        tooltip: 'Notification',
      ),
    ],
  );
}

class NewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;

  NewsCard(this.imgUrl, this.title, this.desc, this.content, this.posturl);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleView(postUrl: posturl),
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          margin: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset.zero,
                  blurRadius: 10.0,
                  spreadRadius: 0.0)
            ],
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(6),
                bottomLeft: Radius.circular(6),
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(5, 5),
                        blurRadius: 10.0,
                        spreadRadius: 0.0)
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imgUrl,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                child: Column(
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      desc,
                      maxLines: 2,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
 