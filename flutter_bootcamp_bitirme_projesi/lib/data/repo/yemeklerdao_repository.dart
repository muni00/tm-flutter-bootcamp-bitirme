import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet_cevap.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek_cevap.dart';

class YemeklerDaoRepository {
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
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var veri = {
      "yemek_adi": yemek_adi,
      "yemek_resim_adi": yemek_resim_adi,
      "yemek_fiyat": yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("sepete eklendi : ${cevap.data.toString()}");
  }

/*
  Future<void> guncelle(int kisi_id, String kisi_ad, String kisi_tel) async {
    var url = "http://kasimadalan.pe.hu/kisiler/update_kisiler.php";
    var veri = {"kisi_id": kisi_id, "kisi_ad": kisi_ad, "kisi_tel": kisi_tel};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("Kişi güncelleme : ${cevap.data.toString()}");
  }
*/
  Future<List<Yemek>> yemekleriYukle() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);
    return parseYemeklerCevap(cevap.data.toString());
  }

  Future<List<Sepet>> sepettekileriYukle(String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi": kullanici_adi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    return parseSepettekilerCevap(cevap.data.toString());
  }
/*
  Future<List<Yemek>> ara(String aramaKelimesi) async {
    var url = "http://kasimadalan.pe.hu/kisiler/tum_kisiler_arama.php";
    var veri = {"kisi_ad": aramaKelimesi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    return parseYemeklerCevap(cevap.data.toString());
  }
*/

  Future<void> sil(int yemek_id, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var veri = {"sepet_yemek_id": yemek_id, "kullanici_adi": kullanici_adi};
    var cevap = await Dio().post(url, data: FormData.fromMap(veri));
    print("yemek silme : ${cevap.data.toString()}");
  }
}
