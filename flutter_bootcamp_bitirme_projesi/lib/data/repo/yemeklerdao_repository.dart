import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet_cevap.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek_cevap.dart';

enum EndPoint {
  yemekler("yemekler"),
  tumYemekleriGetir("tumYemekleriGetir.php");

  final String path;
  const EndPoint(this.path);
}

class YemeklerDaoRepository {
  final baseUrl = "http://kasimadalan.pe.hu";
  final sepeteEkleUrl = "/${EndPoint.yemekler}/sepeteYemekEkle.php";

  final sepettenYemekSil = "/${EndPoint.yemekler}/sepettenYemekSil.php";

  final sepettekiYemekleriGetir =
      "/${EndPoint.yemekler.path}/sepettekiYemekleriGetir.php";
  final Dio dio = Dio();

  YemeklerDaoRepository() {
    dio.options.baseUrl = baseUrl;
  }

  List<Yemek> parseYemeklerCevap(String cevap) {
    return YemekCevap.fromJson(json.decode(cevap)).yemekler;
  }

  List<Sepet> parseSepettekilerCevap(String cevap) {
    return SepetCevap.fromJson(json.decode(cevap)).sepettekiler;
  }

  Future<void> sepeteKaydet(
      String yemek_adi,
      String yemek_resim_adi,
      String yemek_fiyat,
      String yemek_siparis_adet,
      String kullanici_adi) async {
    var veri = {
      "yemek_adi": yemek_adi,
      "yemek_resim_adi": yemek_resim_adi,
      "yemek_fiyat": yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };
    var url = "/yemekler/sepeteYemekEkle.php";
    var cevap = await dio.post(url, data: FormData.fromMap(veri));
    print("sepete eklendi : ${cevap.data.toString()}");
  }

  Future<List<Yemek>> yemekleriYukle() async {
    var url = "/${EndPoint.yemekler.path}/${EndPoint.tumYemekleriGetir.path}";
    var cevap = await dio.get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

  Future<List<Sepet>> sepettekileriYukle(String kullanici_adi) async {
    var veri = {"kullanici_adi": kullanici_adi};
    var url = "/yemekler/sepettekiYemekleriGetir.php";
    final cevap = await dio.post(url, data: FormData.fromMap(veri));

    if (cevap.data.toString() == "\n" "\n" "\n" "\n" "\n") {
      return <Sepet>[];
    } else {
      return parseSepettekilerCevap(cevap.data.toString());
    }
  }

  Future<List<Yemek>> ara(String aramaKelimesi) async {
    var url = "/${EndPoint.yemekler.path}/${EndPoint.tumYemekleriGetir.path}";
    var cevap = await dio.get(url);
    var yemekList = parseYemeklerCevap(cevap.data.toString());
    var donusList = <Yemek>[];
    yemekList.forEach((element) {
      if (element.yemek_ad
          .toLowerCase()
          .contains(aramaKelimesi.toLowerCase())) {
        donusList.add(element);
      }
    });
    return donusList;
  }

  Future<List<Yemek>> artanSira() async {
    var url = "/${EndPoint.yemekler.path}/${EndPoint.tumYemekleriGetir.path}";
    var cevap = await dio.get(url);
    var yemekList = parseYemeklerCevap(cevap.data.toString());
    yemekList.sort(
        (a, b) => int.parse(a.yemek_fiyat).compareTo(int.parse(b.yemek_fiyat)));
    return yemekList;
  }

  Future<List<Yemek>> azalanSira() async {
    var url = "/${EndPoint.yemekler.path}/${EndPoint.tumYemekleriGetir.path}";
    var cevap = await dio.get(url);
    var yemekList = parseYemeklerCevap(cevap.data.toString());
    yemekList.sort(
        (a, b) => int.parse(b.yemek_fiyat).compareTo(int.parse(a.yemek_fiyat)));
    return yemekList;
  }

  Future<List<Sepet>> tamamenSil(String kullanici_adi) async {
    var veri = {"kullanici_adi": kullanici_adi};
    var url = "/yemekler/sepettekiYemekleriGetir.php";
    final cevap = await dio.post(url, data: FormData.fromMap(veri));

    if (cevap.data.toString() == "\n" "\n" "\n" "\n" "\n") {
      return <Sepet>[];
    } else {
      var yemekList = parseSepettekilerCevap(cevap.data.toString());
      yemekList.forEach((element) {
        sil(int.parse(element.sepet_yemek_id), kullanici_adi);
      });
      return yemekList;
    }
  }

  Future<void> sil(int yemek_id, String kullanici_adi) async {
    var url = "/yemekler/sepettenYemekSil.php";
    var veri = {"sepet_yemek_id": yemek_id, "kullanici_adi": kullanici_adi};
    var cevap = await dio.post(url, data: FormData.fromMap(veri));
    print("yemek silme : ${cevap.data.toString()}");
  }
}
