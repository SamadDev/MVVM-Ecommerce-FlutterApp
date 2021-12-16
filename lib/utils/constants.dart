import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/size_config.dart';

const PrimaryColor = Color(0xffea4b4b);
const PrimaryLightColor = Color(0xffebeded);
const CardBackgroundColor = Color(0xfff3f4f4);
const PrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const SecondaryColor = Color(0xFF979797);
const SecondaryColorDark = Color(0xff292929);

const AnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: SecondaryColorDark,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp passwordValidatorRegExp = RegExp(r"^(?=.*?[a-zA-Z])(?=.*?[0-9])");
final RegExp phoneNumValidatorRegExp = RegExp(r"^[0-9]{11}$");
final RegExp nameValidatorRegExp = RegExp(r"^[a-zA-Z\s]*$");

const String EmailNullError = "Please Enter your email";
const String InvalidEmailError = "Please Enter a valid email";
const String InvalidPassError =
    "Password must contain both letters and numbers";
const String InvalidPhoneNumError = "Phone number must contain 11 numbers";
const String InvalidNameError = "Name must contain letters only";
const String PassNullError = "Please Enter your password";
const String ShortPassError = "Password must contain at least 8 characters";
const String MatchPassError = "Passwords don't match";
const String NameNullError = "Please Enter your name";
const String PhoneNumberNullError = "Please Enter your phone number";
const String AddressNullError = "Please Enter your address";
const String WrongEorP = "Wrong email or password";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(2)),
    borderSide: BorderSide(color: SecondaryColorDark),
  );
}

const List<String> governorates = [
  'Al-Minya',
  'Alexandria',
  'Aswan',
  'Asyut',
  'Beheira',
  'Beni Suef',
  'Cairo',
  'Dakahlia',
  'Damietta',
  'Faiyum',
  'Gharbia',
  'Giza',
  'Ismailia',
  'Kafr El-Sheikh',
  'Luxor',
  'Matrouh',
  'Monufia',
  'New Valley',
  'North Sinai',
  'Port Said',
  'Qalyubia',
  'Qena',
  'Red Sea',
  'Sharqia',
  'Sohag',
  'South Sinai',
  'Suez',
];
