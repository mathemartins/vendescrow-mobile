String k_m_b_generator(num, userFiat) {
  num = userFiat * num;
  if (num > 999 && num < 99999) {
    return "${(num / 1000).toStringAsFixed(2)} K";
  } else if (num > 99 && num < 999) {
    return "${(num).toStringAsFixed(2)}";
  } else if (num > 9 && num < 99) {
    return "${(num).toStringAsFixed(2)}";
  } else if (num > 2 && num < 5) {
    return "${(num).toStringAsFixed(2)}";
  } else if (num > 99999 && num < 999999) {
    return "${(num / 1000).toStringAsFixed(2)} K";
  } else if (num > 999999 && num < 999999999) {
    return "${(num / 1000000).toStringAsFixed(2)} M";
  } else if (num > 999999999) {
    return "${(num / 1000000000).toStringAsFixed(2)} B";
  } else {
    return num.toString();
  }
}
