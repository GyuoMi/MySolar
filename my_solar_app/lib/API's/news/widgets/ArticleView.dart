import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'WidgetList.dart';

class ArticleView extends StatefulWidget {
  final String postUrl;
  ArticleView({required this.postUrl});

  @override
  _ArticleViewState createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // child: WebView(
        //   initialUrl: widget.postUrl,
        //   onWebViewCreated: (WebViewController webViewController) {
        //     _controller.complete(webViewController);
        //   },
        //),
      ),
    );
  }
}
