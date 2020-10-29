import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../animation/fade_animation.dart';
import '../models/story.dart';

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
      //defining the TabController widget to make the TabBar
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(this.widget.item.title),
          backgroundColor: Colors.orange,
          bottom: TabBar(
            // cofiguring the tabbar
            tabs: [
              Tab(
                icon: Icon(Icons.comment), //naming the tabs
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
          //this is TabView widget, though we cam make the screen divide into two to show both the comments and the article webpage.
          children: [
            FadeAnimation(
              1,
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: this
                    .widget
                    .comments
                    .length, //how many times the list tile will create
                itemBuilder: (context, index) {
                  return ListTile(
                    //displaying the comments by listtile widget
                    leading: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      child: Text(
                        //leveling the numbers of comments
                        "${1 + index}",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "${widget.comments[index].text}", //here is the comments pf perticular stories
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            //this is the webview of the perticular URL done by WebView widget
            WebView(
              initialUrl: widget.item.sourceUrl, //the url from class
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ],
        ),
      ),
    );
  }
}
