getUserCurrency(String country) {
  var command = country;
  switch (command) {
    case 'Nigeria':
      return '\u{20A6}';
      break;
    case 'Ghana':
      return '\u{20B5}';
      break;
    case 'Kenya':
      return 'KSh';
      break;
    default:
      return '\u{0024}';
  }
}

getUserCurrencyName(String country) {
  var command = country;
  switch (command) {
    case 'Nigeria':
      return 'Naira';
      break;
    case 'Ghana':
      return 'Cedis';
      break;
    case 'Kenya':
      return 'K.Shillings';
      break;
    case 'United States Of America':
      return 'Dollars';
      break;
    default:
      return 'Dollars';
  }
}
