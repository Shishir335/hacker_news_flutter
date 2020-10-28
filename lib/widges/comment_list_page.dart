import 'package:flutter/material.dart';

import 'package:hacker_news_app_flutter/widges/story.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommentListPage extends StatefulWidget {
  final List<Comment> comments;
  final Story item;

  CommentListPage({this.item, this.comments, String url});

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  final List<Story> stories = List<Story>();

  final primaryColor = Colors.orange[200];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.item.title),
          backgroundColor: Colors.orange,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.comment),
                text: 'Comments',
              ),
              Tab(
                icon: Icon(Icons.pages),
                text: 'Article',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: this.widget.comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    alignment: Alignment.center,
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      "${1 + index}",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                  ),
                  title: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.comments[index].text,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ]),
                  ),
                  // subtitle: ListView.builder(
                  //     itemCount: this.stories[index].kids.length,
                  //     itemBuilder: (ctx, index) {
                  //       return Card(
                  //         child: Text("${stories[index].kids}"),
                  //       );
                  //     }),
                );
              },
            ),
            WebView(
              initialUrl: widget.item.sourceUrl,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ],
        ),
      ),
    );
  }
}
