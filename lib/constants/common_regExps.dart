class CommonRegExps {
  static RegExp emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  static RegExp mobileRegExp = RegExp(r'^[0-9]{10}$');

  static RegExp passwordRegExp = RegExp(
    r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)",
  );
}