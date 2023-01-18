import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/detay_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/sepet_sayfa.dart';

class DetaySayfa extends StatefulWidget {
  Yemek yemek;

  DetaySayfa({required this.yemek});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

var auth = FirebaseAuth.instance;

class _DetaySayfaState extends State<DetaySayfa> {
  int adet = 1;
  var sepettekilerKontrol;
  var sepettekiAdet;
  var sepettekiYemekId;

  var kullaniciAdi = auth.currentUser?.email;

  @override
  void initState() {
    super.initState();
    context.read<DetaySayfaCubit>().sepettekileriYukle(kullaniciAdi.toString());
  }

  @override
  Widget build(BuildContext context) {
    var yemek = widget.yemek;
    return Scaffold(
      body: BlocBuilder<DetaySayfaCubit, List<Sepet>>(
          builder: (context, sepettekiler) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                      "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_ad}"),
                ),
                Text(yemek.yemek_ad),
                Text("${yemek.yemek_fiyat} ₺"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            adet -= 1;
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text(adet.toString()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            adet += 1;
                          });
                        },
                        icon: Icon(Icons.add)),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      sepettekiler.forEach((element) {
                        if (yemek.yemek_ad == element.yemek_adi) {
                          setState(() {
                            sepettekilerKontrol = element.yemek_adi;
                            sepettekiAdet =
                                int.parse(element.yemek_siparis_adet) +
                                    adet; //sepettekinin adet kadar fazlası
                            sepettekiYemekId = element.sepet_yemek_id;
                          });
                        }
                      }); //foreach bitti
                      if (sepettekilerKontrol == null) {
                        context.read<DetaySayfaCubit>().sepeteKayedet(
                            yemek.yemek_ad,
                            yemek.yemek_resim_ad,
                            yemek.yemek_fiyat,
                            adet.toString(),
                            kullaniciAdi.toString());
                      } else {
                        context.read<DetaySayfaCubit>().sil(
                            int.parse(sepettekiYemekId),
                            kullaniciAdi.toString());

                        context.read<DetaySayfaCubit>().sepeteKayedet(
                            yemek.yemek_ad,
                            yemek.yemek_resim_ad,
                            yemek.yemek_fiyat,
                            sepettekiAdet.toString(),
                            kullaniciAdi.toString());
                      }
                      print(sepettekilerKontrol);
                      print(sepettekiAdet);
                      print(sepettekiYemekId);
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SepetSayfa()))
                          .then((value) {
                        initState();
                        sepettekiler.forEach((element) {
                          if (yemek.yemek_ad == element.yemek_adi) {
                            setState(() {
                              sepettekilerKontrol = element.yemek_adi;
                              sepettekiAdet =
                                  int.parse(element.yemek_siparis_adet) +
                                      adet; //sepettekinin adet kadar fazlası
                              sepettekiYemekId = element.sepet_yemek_id;
                            });
                          }
                        }); //sayfa dönüşü değerleri tekrar buluyorum
                        // context
                        //     .read<DetaySayfaCubit>()
                        //     .sepettekileriYukle("muniba");
                      });
                    },
                    child: const Text("Sepete Ekle")),
              ],
            ),
          ),
        );
      }),
    );
  }
}
