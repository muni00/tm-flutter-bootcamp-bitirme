import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';

class YemekCevap {
  List<Yemek> yemekler;
  int success;

  YemekCevap({required this.yemekler, required this.success});

  factory YemekCevap.fromJson(Map<String, dynamic> json) {
    var jsonArray = json["yemekler"] as List;
    var yemekler = jsonArray
        .map((jsonArrayNesnesi) => Yemek.fromJson(jsonArrayNesnesi))
        .toList();

    return YemekCevap(yemekler: yemekler, success: json["success"] as int);
  }
}
