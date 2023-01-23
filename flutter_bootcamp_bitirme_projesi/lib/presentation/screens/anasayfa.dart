import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/anasayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/detay_sayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/giris_sayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/sepet_sayfa.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaButtonKontrol = false;
  final _aramaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle();
  }

  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var colorConstant = ColorConstants.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: buildAppBar(colorConstant),
      body: BlocBuilder<AnasayfaCubit, List<Yemek>>(
        builder: (context, yemeklerListesi) {
          if (yemeklerListesi.isNotEmpty) {
            return Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                buildSearchBar(colorConstant),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                  child: Row(
                    children: [
                      buildAzalanSiraButton(context, colorConstant),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.read<AnasayfaCubit>().yemekleriYukle();
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(
                                    color: colorConstant.ortaAcikTuruncu,
                                    width: 3.0),
                                color: colorConstant.acikTuruncu),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.filter_alt_off_rounded,
                                  color: colorConstant.koyuYazi,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      buildArtanSiraButton(context, colorConstant),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: SizedBox(
                      height: 470, child: buildListView(yemeklerListesi)),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          } else {
            context.read<AnasayfaCubit>().yemekleriYukle();
            _aramaController.clear();
            aramaButtonKontrol = false;
            return Stack(children: const [
              Center(),
            ]);
          }
        },
      ),
    );
  }

  GestureDetector buildArtanSiraButton(
      BuildContext context, ColorConstants colorConstant) {
    return GestureDetector(
      onTap: () {
        context.read<AnasayfaCubit>().artanSira();
      },
      child: Container(
        child: Row(
          children: [
            Text(
              "Artan sıra",
              style: TextStyle(color: colorConstant.koyuYazi),
            ),
            Icon(
              Icons.arrow_upward,
              color: colorConstant.koyuYazi,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAzalanSiraButton(
      BuildContext context, ColorConstants colorConstant) {
    return GestureDetector(
      onTap: () {
        context.read<AnasayfaCubit>().azalanSira();
      },
      child: Container(
        child: Row(
          children: [
            Icon(
              Icons.arrow_downward,
              color: colorConstant.koyuYazi,
            ),
            Text(
              "Azalan sıra",
              style: TextStyle(color: colorConstant.koyuYazi),
            ),
          ],
        ),
      ),
    );
  }

  IconButton buildSepeteGit(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SepetSayfa()))
              .then((value) {
            context.read<AnasayfaCubit>().yemekleriYukle();
            _aramaController.clear();
            setState(() {
              aramaButtonKontrol = false;
            });
          });
        },
        icon: Icon(
          Icons.shopping_bag_outlined,
          color: colorConstants.koyuTuruncu,
        ));
  }

  Widget buildListView(List<Yemek> yemeklerListesi) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: yemeklerListesi.length,
            itemBuilder: (context, indeks) {
              var yemek = yemeklerListesi[indeks];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetaySayfa(yemek: yemek)))
                      .then((value) {
                    context.read<AnasayfaCubit>().yemekleriYukle();
                  });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 30.0, right: 20.0),
                      child: Container(
                        width: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.0),
                          border:
                              Border.all(color: Colors.transparent, width: 1.0),
                          color: colorConstants.acikTuruncu,
                        ),
                      ),
                    ),
                    Positioned(
                        right: 50,
                        top: 100,
                        child: Text(
                          "${yemek.yemek_fiyat.toString()} ₺",
                          style: TextStyle(
                              fontSize: 20,
                              color: colorConstants.koyuTuruncu,
                              fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        left: 70,
                        bottom: 170,
                        child: Text(
                          "${yemek.yemek_ad.toString()}",
                          style: TextStyle(
                              fontSize: 20,
                              color: colorConstants.koyuTuruncu,
                              fontWeight: FontWeight.bold),
                        )),
                    Positioned(
                        left: 70,
                        bottom: 130,
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            "Yemek ayrıntılarına erişebilmek için tıklayınız!",
                            style: TextStyle(
                                fontSize: 15,
                                color: colorConstants.ortaKoyuTuruncu,
                                fontWeight: FontWeight.normal),
                          ),
                        )),
                    Positioned(
                      right: 120,
                      bottom: 250,
                      child: CircleAvatar(
                        backgroundColor: colorConstants.ortaAcikTuruncu,
                        radius: 90,
                      ),
                    ),
                    Positioned(
                      right: 140,
                      bottom: 270,
                      child: CircleAvatar(
                        backgroundColor: colorConstants.turuncu,
                        radius: 80,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 80,
                          child: SizedBox(
                            width: 138,
                            height: 138,
                            child: Image.network(
                                "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_ad}"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        //buildSepeteGitButton(),
      ],
    );
  }

  Positioned buildSepeteGitButton() {
    return Positioned(
      right: 40,
      bottom: 50,
      child: CircleAvatar(
        backgroundColor: colorConstants.ortaKoyuTuruncu,
        radius: 30,
        child: CircleAvatar(
          backgroundColor: colorConstants.acikTuruncu,
          radius: 25,
          child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SepetSayfa()));
              },
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: colorConstants.koyuTuruncu,
              )),
        ),
      ),
    );
  }

  Widget buildSearchBar(ColorConstants colorConstant) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border:
                Border.all(color: colorConstant.ortaAcikTuruncu, width: 1.0),
            color: Colors.white),
        child: Row(
          children: [
            aramaButtonKontrol
                ? Expanded(
                    child: buildCustomTextField(_aramaController, "Arama yap"))
                : SizedBox(
                    width: 10,
                    height: 10,
                  ),
            Spacer(),
            aramaButtonKontrol
                ? IconButton(
                    icon: Icon(
                      Icons.close_sharp,
                      color: colorConstant.koyuTuruncu,
                    ),
                    onPressed: () {
                      print("your menu action here");

                      setState(() {
                        aramaButtonKontrol = false;
                        _aramaController.text = "";
                      });
                      context.read<AnasayfaCubit>().yemekleriYukle();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.search,
                      color: colorConstant.koyuTuruncu,
                    ),
                    onPressed: () {
                      print("your menu action here");
                      setState(() {
                        aramaButtonKontrol = true;
                      });
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildCustomTextField(
      TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: TextField(
          onChanged: (aramaSonucu) {
            var encoded = utf8.encode(aramaSonucu);
            var decoded = utf8.decode(encoded);
            context.read<AnasayfaCubit>().ara(decoded);
          },
          style: TextStyle(
            color: ColorConstants.instance.koyuYazi,
          ),
          cursorColor: ColorConstants.instance.koyuTuruncu,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: ColorConstants.instance.koyuTuruncu),
            focusColor: ColorConstants.instance.koyuTuruncu,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.transparent,
            )),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.transparent,
            )),
          )),
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
              ZoomDrawer.of(context)!.toggle();
            },
            icon: Icon(
              Icons.short_text_rounded,
              color: colorConstant.koyuTuruncu,
              size: 40,
            )),
      ),
    );
  }
}
