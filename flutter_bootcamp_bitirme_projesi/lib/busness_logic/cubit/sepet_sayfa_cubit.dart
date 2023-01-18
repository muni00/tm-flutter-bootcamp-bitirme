import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/repo/yemeklerdao_repository.dart';

class SepetSayfaCubit extends Cubit<List<Sepet>> {
  SepetSayfaCubit() : super(<Sepet>[]);

  var yrepo = YemeklerDaoRepository();

  Future<void> sepettekileriYukle(String kullanici_adi) async {
    var liste = await yrepo.sepettekileriYukle(kullanici_adi);
    emit(liste);
  }

  Future<void> sepeteKayedet(
      String yemek_adi,
      String yemek_resim_adi,
      String yemek_fiyat,
      String yemek_siparis_adet,
      String kullanici_adi) async {
    await yrepo.sepeteKaydet(yemek_adi, yemek_resim_adi, yemek_fiyat,
        yemek_siparis_adet, kullanici_adi);
    await sepettekileriYukle(kullanici_adi);
  }

  Future<void> sil(int yemek_id, String kullanici_adi) async {
    await yrepo.sil(yemek_id, kullanici_adi);
    await sepettekileriYukle(kullanici_adi);
  }
}
