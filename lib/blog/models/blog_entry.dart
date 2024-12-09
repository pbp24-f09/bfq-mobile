// To parse this JSON data, do
//
//     final blogEntry = blogEntryFromJson(jsonString);

import 'dart:convert';

BlogEntry blogEntryFromJson(String str) => BlogEntry.fromJson(json.decode(str));

String blogEntryToJson(BlogEntry data) => json.encode(data.toJson());

class BlogEntry {
    List<Article> articles;

    BlogEntry({
        required this.articles,
    });

    factory BlogEntry.fromJson(Map<String, dynamic> json) => BlogEntry(
        articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    };
}

class Article {
    int id;
    String title;
    String content;
    String author;
    bool isAuthor;
    DateTime time;
    String topic;

    Article({
        required this.id,
        required this.title,
        required this.content,
        required this.author,
        required this.isAuthor,
        required this.time,
        required this.topic,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        author: json["author"],
        isAuthor: json["is_author"],
        time: DateTime.parse(json["time"]),
        topic: json["topic"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "author": author,
        "is_author": isAuthor,
        "time": time.toIso8601String(),
        "topic": topic,
    };
}
