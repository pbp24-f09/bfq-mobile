import 'dart:convert';

List<Discussion> discussionFromJson(String str) => List<Discussion>.from(
  json.decode(str).map((x) => Discussion.fromJson(x))
);

String discussionToJson(List<Discussion> data) => json.encode(
  List<dynamic>.from(data.map((x) => x.toJson()))
);

class DiscussionEntry {
  List<Discussion> discussions;

  DiscussionEntry({required this.discussions});

  factory DiscussionEntry.fromJson(Map<String, dynamic> json) {
    return DiscussionEntry(
      discussions: List<Discussion>.from(
        (json['discussions'] as List).map((x) => Discussion.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discussions': List<dynamic>.from(discussions.map((x) => x.toJson())),
    };
  }
}

class Discussion {
  String model;
  int pk;
  Fields fields;

  Discussion({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Discussion.fromJson(Map<String, dynamic> json) => Discussion(
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
  DateTime date;
  String product;
  String topic;
  String comment;

  Fields({
    required this.user,
    required this.date,
    required this.product,
    required this.topic,
    required this.comment,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
    user: json["user"],
    date: DateTime.parse(json["date"]),
    product: json["product"],
    topic: json["topic"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "product": product,
    "topic": topic,
    "comment": comment,
  };
}