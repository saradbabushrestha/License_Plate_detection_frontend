import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.network("https://i.ibb.co/tKbyMNd/wp-high-resolution-logo-transparent.png",width: 100,),
        "We-Park ".text.xl2.make(),
        "Find you perfect parking spot".text.light.white.wider.lg.make(),
      ],
    );
  }
}