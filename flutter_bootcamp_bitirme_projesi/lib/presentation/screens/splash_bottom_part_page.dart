import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/pages/anasayfa_drawer_screen.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/pages/auth_page.dart';

class SplashBottomPartPage extends StatefulWidget {
  const SplashBottomPartPage({Key? key}) : super(key: key);

  @override
  State<SplashBottomPartPage> createState() => _SplashBottomPartPageState();
}

var auth = FirebaseAuth.instance;
var colorConstants = ColorConstants.instance;

class _SplashBottomPartPageState extends State<SplashBottomPartPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Yemek Seçmenin En Kolay Yolu !",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: colorConstants.acikTuruncu),
            ),
            const SizedBox(height: 30.0),
            Text(
              "Seni selamlamak için biraz bekletiyoruz. Aradığın yemeği kolayca bulabilmek için butona tıklayarak devam edebilirsin...",
              style: TextStyle(
                fontSize: 15.0,
                color: colorConstants.acikTuruncu,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  var guncelKullanici = auth.currentUser;
                  if (guncelKullanici != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AnasayfaDrawerScreen()));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthPage()));
                  }
                },
                child: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: colorConstants.acikTuruncu, width: 2.0),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 50.0,
                    color: colorConstants.acikTuruncu,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
