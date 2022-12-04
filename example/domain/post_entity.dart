// To parse this JSON data, do
//
//     final postEntity = postEntityFromJson(jsonString);

import 'dart:convert';

List<PostEntity> postEntityFromJson(List<dynamic> data) =>
    List<PostEntity>.from(data.map((x) => PostEntity.fromJson(x)));

String postEntityToJson(List<PostEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostEntity {
  PostEntity({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  final int userId;
  final int id;
  final String title;
  final String body;

  factory PostEntity.fromJson(Map<String, dynamic> json) => PostEntity(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
