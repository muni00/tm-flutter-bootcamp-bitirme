import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/login_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/giris_sayfa.dart';

import '../pages/auth_page.dart';

class MenuPage extends StatefulWidget {
  final ValueSetter setIndex;

  MenuPage({required this.setIndex});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

var auth = FirebaseAuth.instance;

class _MenuPageState extends State<MenuPage> {
  var kullaniciEmail = auth.currentUser?.email.toString();
  @override
  Widget build(BuildContext context) {
    var colorConstant = ColorConstants.instance;
    return Scaffold(
      backgroundColor: colorConstant.koyuTuruncu,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildProfileImage(colorConstant),
          SizedBox(
            height: 120,
          ),
          Column(
            children: [
              drawerList(Icons.home_outlined, "Anasayfa", 0),
              drawerList(Icons.shopping_bag_outlined, "Sepet Sayfası", 1),
              drawerList(Icons.message, "Sipariş Ayrıntıları", 2),
              drawerList(Icons.settings, "Hesap", 3),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          buildCikisYapButton(colorConstant),
        ],
      ),
    );
  }

  Padding buildCikisYapButton(ColorConstants colorConstant) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, top: 10.0),
      child: GestureDetector(
        onTap: () {
          context.read<LoginCubit>().signOut();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => AuthPage()));
        },
        child: Container(
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border:
                  Border.all(color: colorConstant.ortaKoyuTuruncu, width: 3.0),
              color: colorConstant.koyuTuruncu),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Çıkış Yap",
                  style: TextStyle(color: colorConstant.acikTuruncu),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileImage(ColorConstants colorConstant) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, bottom: 40),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: colorConstant.ortaKoyuTuruncu,
            radius: 30,
            child: CircleAvatar(
              backgroundColor: colorConstant.acikTuruncu,
              radius: 25,
              child: Icon(
                Icons.person,
                color: colorConstant.koyuTuruncu,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              kullaniciEmail.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colorConstant.acikTuruncu, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.setIndex(index);
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, bottom: 20),
        child: Row(
          children: [
            Icon(icon, color: colorConstants.acikTuruncu //Colors.white,
                ),
            SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(color: colorConstants.acikTuruncu),
            ),
          ],
        ),
      ),
    );
  }
}
