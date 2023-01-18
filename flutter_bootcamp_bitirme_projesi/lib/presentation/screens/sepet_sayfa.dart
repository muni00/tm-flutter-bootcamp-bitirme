import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/sepet_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({Key? key}) : super(key: key);

  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

var auth = FirebaseAuth.instance;

class _SepetSayfaState extends State<SepetSayfa> {
  var adet;
  var kullaniciAdi = auth.currentUser?.email;
  @override
  void initState() {
    super.initState();
    context.read<SepetSayfaCubit>().sepettekileriYukle(kullaniciAdi.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SepetSayfaCubit, List<Sepet>>(
        builder: (context, sepettekileriListe) {
          if (sepettekileriListe.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () {
                return Future.delayed(
                  Duration(milliseconds: 50),
                  () {
                    context
                        .read<SepetSayfaCubit>()
                        .sepettekileriYukle(kullaniciAdi.toString());
                  },
                );
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: sepettekileriListe.length, //3
                itemBuilder: (context, indeks) {
                  //0,1,2
                  var sepettekiler = sepettekileriListe[indeks];
                  adet =
                      int.parse(sepettekileriListe[indeks].yemek_siparis_adet);
                  return GestureDetector(
                    onTap: () {
                      print("dokundu");
                    },
                    child: Card(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: Image.network(
                                "http://kasimadalan.pe.hu/yemekler/resimler/${sepettekiler.yemek_resim_adi}"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${sepettekiler.yemek_adi} - ${sepettekiler.yemek_fiyat}"),
                          ),
                          Spacer(),
                          Text(adet.toString()),
                          IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${sepettekiler.yemek_adi} silinsin mi?"),
                                    action: SnackBarAction(
                                      label: "Evet",
                                      onPressed: () {
                                        if (int.parse(sepettekiler
                                                .yemek_siparis_adet) ==
                                            1) {
                                          context.read<SepetSayfaCubit>().sil(
                                              int.parse(
                                                  sepettekiler.sepet_yemek_id),
                                              sepettekiler.kullanici_adi);
                                        } else {
                                          context.read<SepetSayfaCubit>().sil(
                                              int.parse(
                                                  sepettekiler.sepet_yemek_id),
                                              sepettekiler.kullanici_adi);

                                          context
                                              .read<SepetSayfaCubit>()
                                              .sepeteKayedet(
                                                  sepettekiler.yemek_adi,
                                                  sepettekiler.yemek_resim_adi,
                                                  sepettekiler.yemek_fiyat,
                                                  (int.parse(sepettekiler
                                                              .yemek_siparis_adet) -
                                                          1)
                                                      .toString(),
                                                  kullaniciAdi.toString());
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.black54,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
