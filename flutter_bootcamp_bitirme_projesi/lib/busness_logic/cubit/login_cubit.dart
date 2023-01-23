import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repo/logindao_repository.dart';

class LoginCubit extends Cubit<void> {
  LoginCubit() : super(0);
  var lrepo = LoginDaoRepository();

  Future<void> signOut() async {
    await lrepo.signOut();
  }
}
