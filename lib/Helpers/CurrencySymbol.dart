getUserCurrency(String country) {
  var command = country;
  switch (command) {
    case 'Nigeria':
      return 'NGN';
      break;
    case 'Ghana':
      return '\u{20B5}';
      break;
    case 'Kenya':
      return 'KSH';
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
