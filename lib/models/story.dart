// these are our model class
//

class Comment {
  String text = "";
  final int commentId;

  Story story;
  Comment({
    this.commentId,
    this.text,
  });

  factory Comment.fromJSON(Map<String, dynamic> json) {
    return Comment(
      commentId: json["id"],
      text: json["text"] as String,
    );
  }
}

class Story {
  final String title;
  final String sourceUrl;
  final String authorName;

  final int points;
  final int date;
  final List<int> kids;
  List<int> commentIds = List<int>();

  Story({
    this.title,
    this.sourceUrl,
    this.commentIds,
    this.authorName,
    this.points,
    this.date,
    this.kids,
  });

  factory Story.fromJSON(Map<String, dynamic> json) {
    return Story(
      title: json["title"],
      sourceUrl: json["url"],
      commentIds: json["kids"] == null ? List<int>() : json["kids"].cast<int>(),
      authorName: json["by"],
      date: json["time"],
      points: json["score"],
      kids: ((json["kids"] ?? []) as Iterable).cast<int>(),
    );
  }
}
