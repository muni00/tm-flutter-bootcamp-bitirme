import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';

class SepetCevap {
  List<Sepet> sepettekiler;
  int success;

  SepetCevap({required this.sepettekiler, required this.success});

  factory SepetCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["sepet_yemekler"] as List;
    var sepettekiler = jsonArray
        .map((jsonArrayNesnesi) => Sepet.fromJson(jsonArrayNesnesi))
        .toList();

    return SepetCevap(
        sepettekiler: sepettekiler, success: json["success"] as int);
  }
}
