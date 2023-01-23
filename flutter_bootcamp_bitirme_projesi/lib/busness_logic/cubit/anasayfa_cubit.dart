import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/repo/yemeklerdao_repository.dart';

class AnasayfaCubit extends Cubit<List<Yemek>> {
  AnasayfaCubit() : super(<Yemek>[]);

  var krepo = YemeklerDaoRepository();

  Future<void> yemekleriYukle() async {
    var liste = await krepo.yemekleriYukle();
    emit(liste);
  }

  Future<void> ara(String aramaKelimesi) async {
    var liste = await krepo.ara(aramaKelimesi);
    emit(liste);
  }

  Future<void> azalanSira() async {
    var liste = await krepo.azalanSira();
    emit(liste);
  }

  Future<void> artanSira() async {
    var liste = await krepo.artanSira();
    emit(liste);
  }
}
