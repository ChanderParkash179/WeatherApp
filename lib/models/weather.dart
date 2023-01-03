// To parse this JSON data, do
//
//     final weather = weatherFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

String weatherToJson(Weather data) => json.encode(data.toJson());

class Weather {
  Weather({
    required this.main,
    required this.name,
  });

  Main main;
  String name;

  factory Weather.fromJson(Map<dynamic, dynamic> json) => Weather(
        main: Main.fromJson(json["main"]),
        name: json["name"],
      );

  Map<dynamic, dynamic> toJson() => {
        "main": main.toJson(),
        "name": name,
      };
}

class Main {
  Main({
    required this.temp,
  });

  double temp;

  factory Main.fromJson(Map<dynamic, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
      );

  Map<dynamic, dynamic> toJson() => {
        "temp": temp,
      };
}
