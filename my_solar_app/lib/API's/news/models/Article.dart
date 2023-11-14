class Article {
  String title;
  String author;
  String desc;
  String urlToImage;
  DateTime publishedAt;
  String content;
  String articleUrl;

  Article(
      {required this.title,
      required this.author,
      required this.desc,
      required this.urlToImage,
      required this.publishedAt,
      required this.content,
      required this.articleUrl});
}
