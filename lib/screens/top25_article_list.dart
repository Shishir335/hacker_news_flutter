import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/story.dart';
import '../widges/Webservice.dart';
import '../animation/fade_animation.dart';
import '../screens/comment_list_page.dart';

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
    //sending the top stories after decoding form API by the help of getTopStories method
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
    //this is the method used to navigate to comment page
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
          //navigating to comment page
          item: story, //passing the values
          comments: comments,
          url: url,
        ),
      ),
    );
  }

  String dateFormet(int timestamp) {
    //the date was in Unix formet, had to transfer it to day ago formet by this method
    //this method is taking the intiger Unix form and converting it to day or days ago.
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
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO'; //
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  final primaryColor =
      Colors.orange; //primary color for the app to give it a theme texture
  final secondaryColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
        backgroundColor: primaryColor,
      ),
      drawer: Drawer(),
      body: Container(
        child: ListView.builder(
          //making a list view to display the stories
          itemCount: _stories.length,
          itemBuilder: (_, index) {
            return FadeAnimation(
              1,
              ListTile(
                onTap: () {
                  _navigateToShowCommentsPage(context,
                      index); //here is the ontap method used to navigate to the comment page
                }, //also passing the values through _navigateToShowCommentPage method and index is here to track the stories
                leading: Container(
                  //look details in the mentioned method
                  child: Column(
                    children: [
                      Text(
                        (index + 1)
                            .toString(), //showing the number tag of each news
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_stories[index].points}", //showing the score of the news
                        style: TextStyle(color: primaryColor.shade700),
                      )
                    ],
                  ),
                ),
                title: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_stories[index].title}", //showing the title of the story by title portion of ListTile
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                subtitle: Container(
                  //i used the subtitle to show the website url, and name of the author
                  child: Column(
                    children: [
                      Text(
                        "${_stories[index].sourceUrl}", //showing the website url
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            dateFormet(_stories[index].date),
                            style: TextStyle(color: primaryColor.shade700),
                          ),
                          Text(
                            "   -${_stories[index].authorName}", //showing the author name who had posted it
                            style: TextStyle(color: secondaryColor.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                trailing: Container(
                  //showing the message count
                  child: Column(
                    children: [
                      Icon(
                        Icons.comment,
                        color: secondaryColor,
                      ),
                      Text(
                        //by this
                        "${_stories[index].commentIds.length}",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
