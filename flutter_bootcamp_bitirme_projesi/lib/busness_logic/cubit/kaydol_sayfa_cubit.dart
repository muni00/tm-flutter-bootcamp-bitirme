import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/repo/logindao_repository.dart';

class KaydolCubit extends Cubit<void> {
  KaydolCubit() : super(0);
  var krepo = LoginDaoRepository();

  Future<void> kisiKaydet(String kisi_ad, String kisi_tel) async {
    await krepo.signUp(kisi_ad, kisi_tel);
  }
}
