import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/giris_sayfa.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/kaydol_sayfa.dart';

import '../animation/background_painter.dart';
import '../color/color_constant.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var kontrol = false;
  var colorConstants = ColorConstants.instance;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    kontrol = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ekran bilgisi
    var ekranBilgisi = MediaQuery.of(context);
    final double ekranYuksekligi = ekranBilgisi.size.height;
    final double ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller.view,
              ),
            ),
          ),
          kontrol
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: ekranGenisligi,
                          height: ekranYuksekligi / 2,
                          child: KaydolSayfa(),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: ekranGenisligi,
                          height: ekranYuksekligi / 2,
                          child: GirisSayfa(),
                        ),
                      ],
                    ),
                  ],
                ),
          Positioned(
              right: 30,
              bottom: 200,
              child: FloatingActionButton(
                  backgroundColor: colorConstants.acikTuruncu,
                  onPressed: () {
                    setState(() {
                      if (kontrol == true) {
                        _controller.reverse();
                        kontrol = false;
                      } else {
                        _controller.forward();
                        kontrol = true;
                      }
                    });
                  },
                  child: kontrol
                      ? Icon(
                          Icons.arrow_back,
                          color: colorConstants.koyuYazi,
                        )
                      : Icon(
                          Icons.arrow_forward,
                          color: colorConstants.koyuYazi,
                        )))
        ],
      ),
    );
  }
}
