import 'package:meta/meta.dart';

class Comment {
  String text = "";
  final int commentId;
  // final List<dynamic> kids;
  Story story;
  Comment({
    this.commentId,
    this.text,
    // this.kids,
  });

  factory Comment.fromJSON(Map<String, dynamic> json) {
    // var kids = json["kids"] = !null ? json["kids"] : List();
    return Comment(
      commentId: json["id"],
      text: json["text"] as String,
      // kids: kids,
    );
  }
}

class Story {
  final String title;
  final String sourceUrl;
  final String authorName;
  final int no;
  final int points;
  final int date;
  final List<int> kids;
  List<int> commentIds = List<int>();

  Story({
    this.title,
    this.sourceUrl,
    this.commentIds,
    this.authorName,
    this.no,
    this.points,
    this.date,
    this.kids,
  });

  factory Story.fromJSON(Map<String, dynamic> json) {
    return Story(
        title: json["title"],
        sourceUrl: json["url"],
        commentIds:
            json["kids"] == null ? List<int>() : json["kids"].cast<int>(),
        authorName: json["by"],
        date: json["time"],
        points: json["score"],
        kids: ((json["kids"] ?? []) as Iterable).cast<int>()
        // kids: json["kids"],
        );
  }

  @override
  String toString() {
    return 'Story{ kids: $kids, title: $title,}';
  }
}
