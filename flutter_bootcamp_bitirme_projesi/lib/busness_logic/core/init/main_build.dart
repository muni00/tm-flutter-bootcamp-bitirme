import 'package:flutter/material.dart';
import 'package:flutter_bootcamp_bitirme_projesi/use_case/no_network_widgets.dart';

class MainBuild {
  MainBuild._();
  static Widget build(BuildContext context, Widget? child) {
    return Column(
      children: [
        Expanded(
          child: child ?? const SizedBox(),
        ),
        const NoNetworkWidget()
      ],
    );
  }
}
