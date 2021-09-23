import 'package:flutter/material.dart';

class cardDataModel {
  String title,  value,  name,  id,date,numberCard;
  Color gradient1,gradient2;
  cardDataModel({this.id,this.name,this.title,this.value,this.date,this.gradient1,this.gradient2,this.numberCard});
}

List<cardDataModel> listCard = [
  cardDataModel(
    id: "1",
    title: "VENDESCROW VIRTUAL CARD",
    name: "Frillya Azahra",
    value: "3975",
    date: "07/21",
    numberCard:"2345  8765  1234",
    gradient1: Color(0xFF6496F4),
    gradient2: Color(0xFF736AE6)
  ),
];