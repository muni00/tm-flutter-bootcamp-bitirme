import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/giris_sayfa_cubit.dart';

import '../color/color_constant.dart';
import 'anasayfa.dart';

class GirisSayfa extends StatefulWidget {
  const GirisSayfa({Key? key}) : super(key: key);

  @override
  State<GirisSayfa> createState() => _GirisSayfaState();
}

var auth = FirebaseAuth.instance;
var colorConstants = ColorConstants.instance;

class _GirisSayfaState extends State<GirisSayfa> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var auth = FirebaseAuth.instance;
  var colorConstants = ColorConstants.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTextFieldContainer(
                  _emailController, "Email", Icons.email_outlined),
              buildTextFieldContainer(
                  _passwordController, "Sifre", Icons.vpn_key_outlined),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorConstants.koyuTuruncu,
                ),
                onPressed: () {
                  context
                      .read<GirisCubit>()
                      .kisiGiris(
                          _emailController.text, _passwordController.text)
                      .then((value) {
                    if (auth.currentUser?.email == _emailController.text) {
                      print(auth.currentUser?.email);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Anasayfa()));
                    } else {
                      print("giriş başarısız");
                    }
                  });
                },
                child: const Text("GİRİŞ YAP"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTextFieldContainer(
      TextEditingController controller, String hintText, IconData icon) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(color: ColorConstants.instance.koyuTuruncu, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: buildCustomTextField(controller, hintText, icon),
        ),
      ),
    );
  }

  TextField buildCustomTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextField(
        style: TextStyle(
          color: ColorConstants.instance.koyuYazi,
        ),
        cursorColor: ColorConstants.instance.koyuTuruncu,
        controller: controller,
        obscureText: hintText == "Sifre" ? true : false,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
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
}
