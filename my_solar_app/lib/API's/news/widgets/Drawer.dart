import 'package:flutter/material.dart';


import '../models/CategoryModel.dart';
import '../screens/CategoryNews.dart';
import 'Data.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidget createState() => _DrawerWidget();
}

class _DrawerWidget extends State<DrawerWidget> {
  List<CategoryModel> categories = <CategoryModel>[];

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    print(categories);
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
            child: ListView(
      padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
      children: [
        Center(
          child: Text(
            'Category',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 500,
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              print(categories[index].categoryName);
              return CategoryCard(
                categoryName: categories[index].categoryName,
              );
            },
          ),
        ),
      ],
    )));
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;

  CategoryCard({required this.categoryName});

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
        child: ListTile(
          title: Text(categoryName),
        ),
      ),
    );
  }
}
