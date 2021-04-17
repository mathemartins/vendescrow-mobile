import 'package:flutter/material.dart';

class deposit extends StatefulWidget {
  final Widget child;

  deposit({Key key, this.child}) : super(key: key);

  _depositState createState() => _depositState();
}

class _depositState extends State<deposit> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 140.0,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Value (USDT)",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "Popins",
                            fontSize: 15.5),
                      ),
                      Text(
                        "0.00",
                        style: TextStyle(fontFamily: "Popins"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Available (BCH)",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "Popins",
                            fontSize: 15.5),
                      ),
                      Text(
                        "0",
                        style: TextStyle(fontFamily: "Popins"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "In Order (BCH)",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "Popins",
                            fontSize: 15.5),
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                          fontFamily: "Popins",
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 125.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "123jkb21k421435bhj325jk43536bj5",
                  style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7),
                    fontFamily: "Popins",
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 40.0,
                  width: 150.0,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "COPY ADDRESS",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Image.asset(
                "assets/image/qrCode.png",
                height: 210.0,
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 40.0,
                width: 150.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    "SAVE IMAGE",
                    style:
                        TextStyle(color: Theme.of(context).textSelectionColor),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}
