import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/anasayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/sepet_sayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/sohbet_sayfa.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../color/color_constant.dart';
import '../screens/menu_page.dart';

class AnasayfaDrawerScreen extends StatefulWidget {
  const AnasayfaDrawerScreen({Key? key}) : super(key: key);
  @override
  State<AnasayfaDrawerScreen> createState() => _AnasayfaDrawerScreenState();
}

class _AnasayfaDrawerScreenState extends State<AnasayfaDrawerScreen> {
  var colorConstant = ColorConstants.instance;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      borderRadius: 30,
      showShadow: true,
      angle: 0.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuScreen: MenuPage(
        setIndex: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      mainScreen: currentScreen(),
      menuBackgroundColor: colorConstant.koyuTuruncu,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return Anasayfa();
      case 1:
        return SepetSayfa();
      case 2:
        return SohbetSayfa();
      case 3:
        return Container(
          color: Colors.indigo,
        );
      default:
        return Anasayfa();
    }
  }
}
