import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/sepet_sayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/sepet.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/giris_sayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/sohbet_sayfa.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../color/color_constant.dart';
import '../pages/anasayfa_drawer_screen.dart';

class SepetSayfa extends StatefulWidget {
  const SepetSayfa({Key? key}) : super(key: key);
  @override
  State<SepetSayfa> createState() => _SepetSayfaState();
}

var auth = FirebaseAuth.instance;

class _SepetSayfaState extends State<SepetSayfa> {
  var flp = FlutterLocalNotificationsPlugin();
  var adet;
  var kullaniciAdi = auth.currentUser?.email;
  var colorConstant = ColorConstants.instance;
  var total = 0;

  @override
  void initState() {
    super.initState();
    kurulum();
    context.read<SepetSayfaCubit>().sepettekileriYukle(kullaniciAdi.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(colorConstant),
      body: BlocBuilder<SepetSayfaCubit, List<Sepet>>(
        builder: (context, sepettekileriListe) {
          if (sepettekileriListe.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () {
                return buildPullUpRefrseh(sepettekileriListe, context);
              },
              child: Stack(
                children: [
                  buildListView(sepettekileriListe),
                  anasayfayaDonButton(context),
                  siparisiTamamlaButton(),
                ],
              ),
            );
          } else {
            return Stack(children: [
              Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset("images/ic_sepet_bos.png")),
              ),
              anasayfayaDonButton(context)
            ]);
          }
        },
      ),
    );
  }

  Future<void> buildPullUpRefrseh(
      List<Sepet> sepettekileriListe, BuildContext context) {
    return Future.delayed(
      Duration(milliseconds: 50),
      () {
        if (sepettekileriListe.isNotEmpty) {
          context
              .read<SepetSayfaCubit>()
              .sepettekileriYukle(kullaniciAdi.toString());
        } else {
          print("boş");
        }
      },
    );
  }

  ListView buildListView(List<Sepet> sepettekileriListe) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: sepettekileriListe.length, //3
      itemBuilder: (context, indeks) {
        //0,1,2
        var sepettekiler = sepettekileriListe[indeks];
        adet = int.parse(sepettekileriListe[indeks].yemek_siparis_adet);
        return GestureDetector(
          onTap: () {
            print("dokundu");
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border:
                      Border.all(color: colorConstant.acikTuruncu, width: 1.0),
                  color: Colors.white),
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                        "http://kasimadalan.pe.hu/yemekler/resimler/${sepettekiler.yemek_resim_adi}"),
                  ),
                  yemekDetayGosterimi(sepettekiler),
                  Spacer(),
                  eklemeSilmeElemanlari(sepettekiler, context)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> kurulum() async {
    var androidAyari = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosAyari = IOSInitializationSettings();
    var kurulumAyari =
        InitializationSettings(android: androidAyari, iOS: iosAyari);
    await flp.initialize(kurulumAyari);
  }

  Future<void> bildirimOlustur() async {
    var androidBildirimDetayi = const AndroidNotificationDetails("id", "name",
        channelDescription: "description",
        priority: Priority.high,
        importance: Importance.max);
    var iosBildirimDetayi = IOSNotificationDetails();
    var bildirimDetayi = NotificationDetails(
        android: androidBildirimDetayi, iOS: iosBildirimDetayi);
    await flp.show(0, "Sayın ${kullaniciAdi}",
        "Siparişiniz alınmıştır\nAfiyet olsun.", bildirimDetayi);
  }

  Padding eklemeSilmeElemanlari(Sepet sepettekiler, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              eksiltButton(sepettekiler, context),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(adet.toString()),
              ),
              ekleButton(context, sepettekiler),
            ],
          ),
          tamamenSilButton(context, sepettekiler),
        ],
      ),
    );
  }

  Padding yemekDetayGosterimi(Sepet sepettekiler) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "${sepettekiler.yemek_adi}",
              textAlign: TextAlign.start,
            ),
          ),
          Text(
            "Sepet fiyati : ${(int.parse(sepettekiler.yemek_fiyat) * int.parse(sepettekiler.yemek_siparis_adet)).toString()} ₺",
            style: TextStyle(),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Container eksiltButton(Sepet sepettekiler, BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Colors.transparent, width: 1.0),
        color: colorConstants.koyuTuruncu,
      ),
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {
          if (int.parse(sepettekiler.yemek_siparis_adet) == 1) {
            context.read<SepetSayfaCubit>().sil(
                int.parse(sepettekiler.sepet_yemek_id),
                sepettekiler.kullanici_adi);
          } else {
            context
                .read<SepetSayfaCubit>()
                .sil(int.parse(sepettekiler.sepet_yemek_id),
                    sepettekiler.kullanici_adi)
                .then((value) {
              context.read<SepetSayfaCubit>().sepeteKayedet(
                  sepettekiler.yemek_adi,
                  sepettekiler.yemek_resim_adi,
                  sepettekiler.yemek_fiyat,
                  (int.parse(sepettekiler.yemek_siparis_adet) - 1).toString(),
                  kullaniciAdi.toString());
            });
          }
        },
        icon: const Icon(
          Icons.remove,
          color: Colors.white,
          size: 8,
        ),
      ),
    );
  }

  Container ekleButton(BuildContext context, Sepet sepettekiler) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Colors.transparent, width: 1.0),
        color: colorConstants.koyuTuruncu,
      ),
      alignment: Alignment.center,
      child: IconButton(
        onPressed: () {
          context
              .read<SepetSayfaCubit>()
              .sil(int.parse(sepettekiler.sepet_yemek_id),
                  sepettekiler.kullanici_adi)
              .then((value) {
            context.read<SepetSayfaCubit>().sepeteKayedet(
                sepettekiler.yemek_adi,
                sepettekiler.yemek_resim_adi,
                sepettekiler.yemek_fiyat,
                (int.parse(sepettekiler.yemek_siparis_adet) + 1).toString(),
                kullaniciAdi.toString());
          });
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 8,
        ),
      ),
    );
  }

  IconButton tamamenSilButton(BuildContext context, Sepet sepettekiler) {
    return IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${sepettekiler.yemek_adi} silinsin mi?"),
              action: SnackBarAction(
                label: "Evet",
                onPressed: () {
                  context.read<SepetSayfaCubit>().sil(
                      int.parse(sepettekiler.sepet_yemek_id),
                      sepettekiler.kullanici_adi);
                },
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.delete_outline,
          color: Colors.black54,
        ));
  }

  Positioned anasayfayaDonButton(BuildContext context) {
    return Positioned(
      left: 30,
      bottom: 50,
      child: CircleAvatar(
        backgroundColor: colorConstant.ortaKoyuTuruncu,
        radius: 30,
        child: CircleAvatar(
          backgroundColor: colorConstant.acikTuruncu,
          radius: 25,
          child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AnasayfaDrawerScreen()));
              },
              icon: Icon(
                Icons.home_outlined,
                color: colorConstant.koyuTuruncu,
                size: 30,
              )),
        ),
      ),
    );
  }

  Positioned siparisiTamamlaButton() {
    return Positioned(
      right: 50,
      bottom: 50,
      child: GestureDetector(
        onTap: () {
          bildirimOlustur();
          context
              .read<SepetSayfaCubit>()
              .tamamenSil(kullaniciAdi!)
              .then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SohbetSayfa()));
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border:
                  Border.all(color: colorConstant.ortaKoyuTuruncu, width: 2.0),
              color: colorConstant.acikTuruncu),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text("Siparişi Tamamla"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(ColorConstants colorConstant) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
            onPressed: () {
              Navigator.pop(context); //ZoomDrawer.of(context)!.toggle();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: colorConstant.koyuTuruncu,
              size: 30,
            )),
      ),
    );
  }
}
