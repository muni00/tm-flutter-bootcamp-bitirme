import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bootcamp_bitirme_projesi/busness_logic/cubit/anasayfa_cubit.dart';
import 'package:flutter_bootcamp_bitirme_projesi/data/models/yemek.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/screens/detay_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().yemekleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AnasayfaCubit, List<Yemek>>(
        builder: (context, yemeklerListesi) {
          if (yemeklerListesi.isNotEmpty) {
            return ListView.builder(
              itemCount: yemeklerListesi.length, //3
              itemBuilder: (context, indeks) {
                //0,1,2
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
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: Image.network(
                              "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_ad}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "${yemek.yemek_ad.toString()} - ${yemek.yemek_fiyat.toString()}"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
      ),
    );
  }
}
