// To parse this JSON data, do
//
//     final gameModel = gameModelFromJson(jsonString);

import 'dart:convert';

GameModel gameModelFromJson(String str) => GameModel.fromJson(json.decode(str));

String gameModelToJson(GameModel data) => json.encode(data.toJson());

class GameModel {
  bool? success;
  int? code;
  String? message;
  List<GameDatum>? data;

  GameModel({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    success: json["success"],
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<GameDatum>.from(json["data"]!.map((x) => GameDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "code": code,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GameDatum {
  String? name;
  String? code;
  String? displayName;

  GameDatum({
    this.name,
    this.code,
    this.displayName,
  });

  factory GameDatum.fromJson(Map<String, dynamic> json) => GameDatum(
    name: json["name"],
    code: json["code"],
    displayName: json["displayName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "displayName": displayName,
  };
}
