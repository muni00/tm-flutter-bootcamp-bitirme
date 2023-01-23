import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';

class MesajBalonu extends StatefulWidget {
  String isim;
  String mesaj;

  MesajBalonu({required this.isim, required this.mesaj});

  @override
  State<MesajBalonu> createState() => _MesajBalonuState();
}

class _MesajBalonuState extends State<MesajBalonu> {
  var colorConstant = ColorConstants.instance;
  var now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 5.0),
      child: Container(
        child: widget.isim != "Admin"
            ? Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colorConstant.acikTuruncu,
                    radius: 27,
                    child: CircleAvatar(
                      backgroundColor: colorConstant.ortaKoyuTuruncu,
                      radius: 23,
                      child: Icon(
                        Icons.face_outlined,
                        color: colorConstant.koyuTuruncu,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isim,
                          style:
                              TextStyle(color: colorConstant.ortaAcikTuruncu),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(widget.mesaj),
                      ],
                    ),
                  ),
                  // Spacer(),
                  // Text(DateTime(now.hour).toString())
                ],
              )
            : Row(
                children: [
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.isim,
                          style:
                              TextStyle(color: colorConstant.ortaAcikTuruncu),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(widget.mesaj),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: colorConstant.ortaKoyuTuruncu,
                    radius: 27,
                    child: CircleAvatar(
                      backgroundColor: colorConstant.acikTuruncu,
                      radius: 23,
                      child: Icon(
                        Icons.admin_panel_settings,
                        color: colorConstant.koyuTuruncu,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
