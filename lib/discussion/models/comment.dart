import 'dart:convert';

List<Comment> CommentFromJson(String str) => List<Comment>.from(
    json.decode(str).map((x) => Comment.fromJson(x)));

String CommentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
  String model;
  int pk;
  Fields fields;

  Comment({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String user;
  int response_to;
  DateTime date;
  String response;

  Fields({
    required this.user,
    required this.response_to,
    required this.date,
    required this.response,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        response_to: json["response_to"],
        date: DateTime.parse(json["date"]),
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "response_to": response_to,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "response": response,
      };
}