import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/detay_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';
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
  var colorComstant = ColorConstants.instance;

  @override
  void initState() {
    super.initState();
    context.read<DetaySayfaCubit>().sepettekileriYukle(kullaniciAdi.toString());
  }

  @override
  Widget build(BuildContext context) {
    var yemek = widget.yemek;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<DetaySayfaCubit, List<Sepet>>(
          builder: (context, sepettekiler) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildYemekResim(yemek),
                buildYemekDetayGoster(yemek),
                buildAdetSayac(),
                SizedBox(
                  height: 60,
                ),
                buildSepetElementleri(sepettekiler, yemek, context),
              ],
            ),
          ),
        );
      }),
    );
  }

  CircleAvatar buildYemekResim(Yemek yemek) {
    return CircleAvatar(
      backgroundColor: colorComstant.acikTuruncu,
      radius: 150,
      child: CircleAvatar(
        backgroundColor: colorComstant.ortaKoyuTuruncu,
        radius: 130,
        child: SizedBox(
          width: 220,
          height: 220,
          child: Image.network(
              "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_ad}"),
        ),
      ),
    );
  }

  Container buildSepetElementleri(
      List<Sepet> sepettekiler, Yemek yemek, BuildContext context) {
    return Container(
      width: 300,
      child: Row(
        children: [
          buildSepeteGitButton(context),
          Spacer(),
          buildSepeteEkleButton(sepettekiler, yemek, context),
        ],
      ),
    );
  }

  Stack buildSepeteGitButton(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: colorComstant.acikTuruncu,
          radius: 35,
          child: CircleAvatar(
            backgroundColor: colorComstant.ortaKoyuTuruncu,
            radius: 27,
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SepetSayfa()));
              },
              icon: Icon(
                Icons.local_mall_outlined,
                color: colorComstant.koyuTuruncu,
                size: 30,
              ),
            ),
          ),
        ),
        Positioned(
          right: 12,
          bottom: 11,
          child: CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: sepettekiAdet == null
                  ? Text(
                      adet.toString(),
                      style: TextStyle(color: colorComstant.koyuTuruncu),
                    )
                  : Text(
                      sepettekiAdet.toString(),
                      style: TextStyle(color: colorComstant.koyuTuruncu),
                    )),
        )
      ],
    );
  }

  GestureDetector buildSepeteEkleButton(
      List<Sepet> sepettekiler, Yemek yemek, BuildContext context) {
    return GestureDetector(
      onTap: () {
        sepettekiler.forEach((element) {
          if (yemek.yemek_ad == element.yemek_adi) {
            setState(() {
              sepettekilerKontrol = element.yemek_adi;
              sepettekiAdet = int.parse(element.yemek_siparis_adet) +
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
          context
              .read<DetaySayfaCubit>()
              .sil(int.parse(sepettekiYemekId), kullaniciAdi.toString())
              .then((value) {
            context.read<DetaySayfaCubit>().sepeteKayedet(
                yemek.yemek_ad,
                yemek.yemek_resim_ad,
                yemek.yemek_fiyat,
                sepettekiAdet.toString(),
                kullaniciAdi.toString());
          });
        }
        print(sepettekilerKontrol);
        print(sepettekiAdet);
        print(sepettekiYemekId);
        Navigator.push(
                context, MaterialPageRoute(builder: (context) => SepetSayfa()))
            .then((value) {
          initState();
          sepettekiler.forEach((element) {
            if (yemek.yemek_ad == element.yemek_adi) {
              setState(() {
                sepettekilerKontrol = element.yemek_adi;
                sepettekiAdet = int.parse(element.yemek_siparis_adet) +
                    adet; //sepettekinin adet kadar fazlası
                sepettekiYemekId = element.sepet_yemek_id;
              });
            }
          });
        });
      },
      child: Container(
        width: 200,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.transparent, width: 1.0),
          color: colorComstant.acikTuruncu,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Sepete Ekle",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: colorComstant.koyuYazi),
            ),
            Icon(
              Icons.arrow_forward,
              color: colorComstant.koyuYazi,
            )
          ],
        ),
      ),
    );
  }

  Container buildAdetSayac() {
    return Container(
      width: 130,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.transparent, width: 1.0),
        color: colorComstant.acikTuruncu,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  adet -= 1;
                });
              },
              icon: Icon(
                Icons.remove,
                color: colorComstant.turuncu,
              )),
          Text(
            adet.toString(),
            style: TextStyle(color: colorComstant.koyuYazi),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  adet += 1;
                });
              },
              icon: Icon(
                Icons.add,
                color: colorComstant.turuncu,
              )),
        ],
      ),
    );
  }

  Container buildYemekDetayGoster(Yemek yemek) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.transparent, width: 1.0),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${yemek.yemek_ad} · ${yemek.yemek_fiyat} ₺",
            style: TextStyle(
                color: colorComstant.koyuTuruncu,
                fontSize: 25.0,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
