import 'package:flutter/material.dart';

class gridHome {
  String name, image, valueMarket, valuePercent;
  Color chartColor;
  List<Color> chartColorGradient;
  var data;
  gridHome(
      {this.image,
      this.name,
      this.data,
      this.chartColor,
      this.valueMarket,
      this.valuePercent,
      this.chartColorGradient});
}

List<gridHome> listGridHome = [
  gridHome(
      name: "BTC/USDT",
      image: "Test",
      chartColor: Colors.greenAccent,
      valueMarket: "3873.98",
      valuePercent: "0.14%",
      chartColorGradient: [
        Colors.greenAccent.withOpacity(0.2),
        Colors.greenAccent.withOpacity(0.01)
      ],
      data: [
        0.0,
        -0.3,
        -0.5,
        -0.1,
        0.0,
        0.0,
        -0.5,
        -1.0,
        -0.5,
        0.0,
        0.0,
      ]),
  gridHome(
      name: "ETH/USDT",
      image: "Test",
      valueMarket: "132.20",
      valuePercent: "0.34%",
      chartColor: Colors.redAccent,
      chartColorGradient: [
        Colors.redAccent.withOpacity(0.2),
        Colors.redAccent.withOpacity(0.01)
      ],
      data: [
        0.0,
        1.0,
        1.5,
        2.0,
        0.0,
        0.0,
        -0.5,
        -1.0,
        -0.5,
        0.0,
        0.0
      ]),
];
