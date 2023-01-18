import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/core/init/main_build.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/anasayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/detay_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/giris_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/kaydol_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/sepet_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/pages/auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SepetSayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => KaydolCubit()),
        BlocProvider(create: (context) => GirisCubit())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        builder: MainBuild.build,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthPage(),
      ),
    );
  }
}
