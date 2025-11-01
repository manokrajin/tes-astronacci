// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  List<UserElement> users;
  int total;
  int page;
  int limit;
  int totalPages;

  User({
    required this.users,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    users: List<UserElement>.from(
      json["users"].map((x) => UserElement.fromJson(x)),
    ),
    total: json["total"],
    page: json["page"],
    limit: json["limit"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "total": total,
    "page": page,
    "limit": limit,
    "totalPages": totalPages,
  };
}

class UserElement {
  int id;
  String name;
  // imageBase64 can be either a base64-encoded string or a list of bytes (List<int>).
  dynamic imageBase64;

  UserElement({
    required this.id,
    required this.name,
    required this.imageBase64,
  });

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
    id: json["id"],
    name: json["name"],
    imageBase64: json["imageBase64"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    // If imageBase64 is Uint8List, encode to base64 string for JSON.
    "imageBase64": imageBase64 is Uint8List
        ? base64Encode(imageBase64 as Uint8List)
        : imageBase64,
  };
}
