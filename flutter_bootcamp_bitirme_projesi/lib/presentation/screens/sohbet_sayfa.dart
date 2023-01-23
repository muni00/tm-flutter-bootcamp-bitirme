import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../color/color_constant.dart';
import '../pages/anasayfa_drawer_screen.dart';
import '../widgets/mesaj_balonu.dart';

class SohbetSayfa extends StatefulWidget {
  const SohbetSayfa({Key? key}) : super(key: key);

  @override
  State<SohbetSayfa> createState() => _SohbetSayfaState();
}

var auth = FirebaseAuth.instance;

class _SohbetSayfaState extends State<SohbetSayfa> {
  var kullaniciAdi = auth.currentUser?.email;
  var t1 = TextEditingController();
  var mesajList = <MesajBalonu>[];
  var colorConstant = ColorConstants.instance;

  listeyeEkle(String kullaniciAdi, String mesaj) {
    setState(() {
      var mesajNesnesi = MesajBalonu(isim: kullaniciAdi, mesaj: mesaj);
      var mesajBenNesnesi =
          MesajBalonu(isim: "Admin", mesaj: "isteğiniz işleme alınmıştır");
      mesajList.insert(0, mesajNesnesi);
      mesajList.insert(0, mesajBenNesnesi);
      t1.clear();
    });
  }

  Widget metinGirisAlani() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Flexible(
                child: buildTextFieldContainer(
                    t1, "mesajınızı giriniz", Icon(Icons.send_outlined))),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    mesajList.clear(); // kullanıcı değiştiğinde sil yapılmalı
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(colorConstant),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 10, right: 10),
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: mesajList.length,
                    itemBuilder: (_, indexNumarasi) =>
                        mesajList[indexNumarasi]),
              ),
              metinGirisAlani(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFieldContainer(
      TextEditingController controller, String hintText, Icon icon) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: ColorConstants.instance.koyuTuruncu, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: buildCustomTextField(controller, hintText, icon),
          ),
        ),
      ),
    );
  }

  TextField buildCustomTextField(
      TextEditingController controller, String hintText, Icon icon) {
    return TextField(
        style: TextStyle(
          color: ColorConstants.instance.koyuYazi,
        ),
        cursorColor: ColorConstants.instance.koyuTuruncu,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              listeyeEkle(kullaniciAdi!, t1.text);
            },
            icon: icon,
            color: ColorConstants.instance.koyuTuruncu,
          ),
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
        ));
  }

  AppBar buildAppBar(ColorConstants colorConstant) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AnasayfaDrawerScreen()));
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
