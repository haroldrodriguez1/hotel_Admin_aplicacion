// To parse this JSON data, do
//
//     final reportarProblemaModel = reportarProblemaModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

ReportarProblemaModel reportarProblemaModelFromJson(String str) => ReportarProblemaModel.fromJson(json.decode(str));

String reportarProblemaModelToJson(ReportarProblemaModel data) => json.encode(data.toJson());

class ReportarProblemaModel {
    String username;
    String problema;
    ObjectId id;
    String asunto;

    ReportarProblemaModel({
        required this.username,
        required this.problema,
        required this.id,
        required this.asunto,
    });

    factory ReportarProblemaModel.fromJson(Map<String, dynamic> json) => ReportarProblemaModel(
        username: json["username"],
        problema: json["problema"],
        id: json["_id"],
        asunto: json["asunto"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "problema": problema,
        "_id": id,
        "asunto": asunto,
    };
}
