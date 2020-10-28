import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hacker_news_app_flutter/widges/Webservice.dart';
import 'package:hacker_news_app_flutter/widges/comment_list_page.dart';
import 'package:hacker_news_app_flutter/widges/story.dart';
import 'package:intl/intl.dart';

class TopArticleList extends StatefulWidget {
  @override
  _TopArticleListState createState() => _TopArticleListState();
}

class _TopArticleListState extends State<TopArticleList> {
  List<Story> _stories = List<Story>();

  @override
  void initState() {
    super.initState();
    _populateTopStories();
  }

  void _populateTopStories() async {
    final responses = await Webservice().getTopStories();
    final stories = responses.map((response) {
      final json = jsonDecode(response.body);
      return Story.fromJSON(json);
    }).toList();

    setState(() {
      _stories = stories;
    });
  }

  void _navigateToShowCommentsPage(BuildContext context, int index) async {
    final story = this._stories[index];
    final url = this._stories[index].sourceUrl;
    final responses = await Webservice().getCommentsByStory(story);
    final comments = responses.map((response) {
      final json = jsonDecode(response.body);
      return Comment.fromJSON(json);
    }).toList();

    // debugPrint("$comments");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentListPage(
          item: story,
          comments: comments,
          url: url,
        ),
      ),
    );
  }

  String dateFormet(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  final primaryColor = Colors.orange;
  final secondaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(),
      body: ListView.builder(
        itemCount: _stories.length,
        itemBuilder: (_, index) {
          return ListTile(
            onTap: () {
              _navigateToShowCommentsPage(context, index);
            },
            leading: Container(
              child: Column(
                children: [
                  Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${_stories[index].points}",
                    style: TextStyle(color: primaryColor),
                  )
                ],
              ),
            ),
            title: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stories[index].title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            subtitle: Container(
              child: Column(
                children: [
                  Text(
                    "${_stories[index].sourceUrl}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        dateFormet(_stories[index].date),
                        style: TextStyle(color: primaryColor),
                      ),
                      Text(
                        "   -${_stories[index].authorName}",
                        style: TextStyle(color: secondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            trailing: Container(
              child: Column(
                children: [
                  Icon(
                    Icons.comment,
                    color: secondaryColor,
                  ),
                  Text(
                    "${_stories[index].commentIds.length}",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
