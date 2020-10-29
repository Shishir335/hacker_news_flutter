//these are the hacker news API Url

class UrlHelper {
  static String urlForStory(int storyId) {
    return "https://hacker-news.firebaseio.com/v0/item/$storyId.json?print=pretty"; //selecting the id by storyId to use it later
  }

  static String urlForTopStories() {
    return "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty";
  }

  static String urlForCommentById(int commentId) {
    return "https://hacker-news.firebaseio.com/v0/item/$commentId.json?print=pretty"; //selecting the id by commentId to use it later
  }
}
