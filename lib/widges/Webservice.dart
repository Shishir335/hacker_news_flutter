import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/story.dart';
import '../widges/url_helper.dart';

//from this portion we are fetching the data from hacker news API

class Webservice {
  Future<Response> _getStory(int storyId) {
    return http.get(UrlHelper.urlForStory(storyId));
  }

  Future<List<Response>> getCommentsByStory(Story story) async {
    //I am getting the comments by its story
    return Future.wait(
      story.commentIds.map(
        (commentId) {
          return http.get(UrlHelper.urlForCommentById(
              commentId)); //from the defined API URL
        },
      ),
    );
  }

  Future<List<Response>> getTopStories() async {
    // by this method we are getting a list of top 25 stories
    final response =
        await http.get(UrlHelper.urlForTopStories()); // by the top stories url
    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);
      return Future.wait(
        storyIds.take(25).map(
          (storyId) {
            return _getStory(storyId);
          },
        ),
      );
    } else {
      throw Exception("Unable to fetch data!"); //error exception
    }
  }
}
