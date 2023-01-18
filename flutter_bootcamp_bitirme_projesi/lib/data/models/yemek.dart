class Yemek {
  String yemek_id;
  String yemek_ad;
  String yemek_resim_ad;
  String yemek_fiyat;

  Yemek(
      {required this.yemek_id,
      required this.yemek_ad,
      required this.yemek_resim_ad,
      required this.yemek_fiyat});

  factory Yemek.fromJson(Map<dynamic, dynamic> json) {
    return Yemek(
        yemek_id: json["yemek_id"] as String,
        yemek_ad: json["yemek_adi"] as String,
        yemek_resim_ad: json["yemek_resim_adi"] as String,
        yemek_fiyat: json["yemek_fiyat"] as String);
  }
}
