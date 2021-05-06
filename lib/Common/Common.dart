import 'dart:math';

List<double> generateRandomDecimals() {
  // Random rnd = new Random();
  // double min = -0.8, max = 0.9;
  // double r = min + rnd.nextInt(max - min);
  // print("$r is in the range of $min and $max"); // e.g. 31
  // // used as a function nextInter:
  // print("${nextInter(min, max)}");

  Random rng = new Random();
  List<double> randArray = [];
  for (var i = 0; i < 10; i++) {
    randArray.add(rng.nextInt(1700) / 100.0 - 0.8);
  }
  return randArray;
}
