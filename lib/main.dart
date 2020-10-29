import 'package:flutter/material.dart';

import './screens/top25_article_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Hacker News",
      home:
          TopArticleList(), //defining the first page. I could do it by the page routing here globally but as the
      //app has only 2 scrrens it is not necessary.
    );
  }
}
