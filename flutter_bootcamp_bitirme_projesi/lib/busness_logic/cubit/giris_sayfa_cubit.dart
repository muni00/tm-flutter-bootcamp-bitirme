import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/repo/logindao_repository.dart';

class GirisCubit extends Cubit {
  GirisCubit() : super(0);
  var krepo = LoginDaoRepository();

  Future<void> kisiGiris(String kisi_ad, String kisi_tel) async {
    await krepo.signIn(kisi_ad, kisi_tel);
  }
}
