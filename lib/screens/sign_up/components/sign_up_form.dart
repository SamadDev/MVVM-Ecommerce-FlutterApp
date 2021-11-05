import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String confirm_password;
  String fullName;
  String phoneNumber;
  String selectedGov = 'Cairo';
  String address;
  final List<String> errors = [];
  ButtonState stateTextWithIcon = ButtonState.idle;

  void onPressedIconWithText() async {
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection == true) {
      Future.delayed(Duration(milliseconds: 400), () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            await context.read<AuthenticationService>().signUp(
                email: email,
                password: password,
                fullName: fullName,
                phoneNumber: phoneNumber,
                governorate: selectedGov,
                address: address);

            User user = context.read<AuthenticationService>().CurrentUser();

            if (user != null) {
              KeyboardUtil.hideKeyboard(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
              print("----------${user.email}----------");
            } else {
              setState(() {
                stateTextWithIcon = ButtonState.fail;
              });
              Future.delayed(Duration(milliseconds: 1600), () {
                setState(() {
                  stateTextWithIcon = ButtonState.idle;
                });
              });
            }
          } catch (e) {
            print(e);
            setState(() {
              stateTextWithIcon = ButtonState.fail;
            });
            Future.delayed(Duration(milliseconds: 1600), () {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            });
          }
        } else {
          setState(() {
            stateTextWithIcon = ButtonState.success;
          });
          Future.delayed(Duration(milliseconds: 1600), () {
            setState(() {
              stateTextWithIcon = ButtonState.idle;
            });
          });
        }
      });
    } else {
      setState(() {
        stateTextWithIcon = ButtonState.ExtraState1;
      });
      Future.delayed(Duration(milliseconds: 1600), () {
        if (!mounted) return;
        setState(() {
          stateTextWithIcon = ButtonState.idle;
        });
      });
    }
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        height: getProportionateScreenWidth(58),
        maxWidth: getProportionateScreenWidth(400),
        radius: 20.0,
        textStyle:
            TextStyle(color: Color(0xffeeecec), fontSize: 18, fontFamily: 'PantonBoldItalic'),
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Continue",
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading: IconedButton(text: "Loading", color: PrimaryColor),
          ButtonState.fail: IconedButton(
              text: "email already exists",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: PrimaryColor),
          ButtonState.success: IconedButton(
              text: "Invalid Input",
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor),
          ButtonState.ExtraState1: IconedButton(
              text: "Connection Lost",
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor)
        },
        onPressed: () => onPressedIconWithText(),
        state: stateTextWithIcon);
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  List<DropdownMenuItem> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < governorates.length; i++) {
      String gov = governorates[i];
      var newItem = DropdownMenuItem(
        child: Text(gov),
        value: gov,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(
            color: SecondaryColor,
            fontSize: getProportionateScreenWidth(20),
            fontFamily: 'Panton',
          ),
        ),
        backgroundColor: SecondaryColorDark,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(22)),
                child: Column(
                  children: [
                    SizedBox(height: getProportionateScreenWidth(45)),
                    Text(
                      "Register Account",
                      style: TextStyle(
                        color: SecondaryColorDark,
                        fontSize: getProportionateScreenWidth(25),
                        fontFamily: 'PantonBoldItalic',
                      ),
                    ),
                    SizedBox(height: getProportionateScreenWidth(5)),
                    Text(
                      "Fill all details to create your account",
                      style: TextStyle(fontFamily: 'Panton'),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: getProportionateScreenWidth(45)),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildEmailFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildPasswordFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildConfirmPassFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildFullNameFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildPhoneNumberFormField(),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Governorate:",
                                style: TextStyle(
                                  fontFamily: 'PantonBoldItalic',
                                  color: SecondaryColorDark,
                                  fontSize: SizeConfig.screenWidth * 0.046,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18.0),
                                      border: Border.all(color: SecondaryColorDark, width: 2.8)),
                                  child: buildGovDropdown()),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          buildAddressFormField(),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          FormError(errors: errors),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          buildTextWithIcon(),
                          SizedBox(height: getProportionateScreenHeight(35)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        password = value;
        if (value.length >= 8 || value.isEmpty) {
          removeError(error: ShortPassError);
        } else if (passwordValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidPassError);
        } else if (value.isNotEmpty) {
          removeError(error: PassNullError);
        } else if (password == confirm_password) {
          removeError(error: MatchPassError);
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: PassNullError);
          return "";
        } else if (!passwordValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidPassError);
          return "";
        } else if (value.length < 8 && value.length != 0) {
          addError(error: ShortPassError);
          return "";
        } else if (password != value) {
          addError(error: MatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "Password",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.lock_outline_rounded,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      obscureText: true,
      onSaved: (newValue) => confirm_password = newValue,
      onChanged: (value) {
        confirm_password = value;

        if (password == confirm_password) {
          removeError(error: MatchPassError);
        }
      },
      validator: (value) {
        if (password != value) {
          addError(error: MatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "CONFIRM Password",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.lock_outline_rounded,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isEmpty || emailValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidEmailError);
        } else if (value.isNotEmpty) {
          removeError(error: EmailNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: EmailNullError);
          return "";
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "E-mail",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.email_outlined,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: AddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: AddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "Address",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.location_on_outlined,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isEmpty || phoneNumValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidPhoneNumError);
        } else if (value.isNotEmpty) {
          removeError(error: PhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: PhoneNumberNullError);
          return "";
        } else if (!phoneNumValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidPhoneNumError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "Phone Number",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.phone_android_outlined,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildFullNameFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      onSaved: (newValue) => fullName = newValue,
      onChanged: (value) {
        if (value.isEmpty || nameValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidNameError);
        } else if (value.isNotEmpty) {
          removeError(error: NameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: NameNullError);
          return "";
        } else if (!nameValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidNameError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(
            fontFamily: 'PantonBold',
            color: SecondaryColorDark.withOpacity(0.5),
            fontWeight: FontWeight.w100),
        labelText: "Full Name",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20), horizontal: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(26)),
          child: Icon(
            Icons.person_outline_rounded,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  DropdownButton buildGovDropdown() {
    return DropdownButton<String>(
        value: selectedGov,
        items: getDropdownItems(),
        onChanged: (value) {
          setState(() {
            selectedGov = value;
          });
        },
        dropdownColor: PrimaryLightColor,
        style: TextStyle(
          color: SecondaryColorDark,
          fontFamily: 'PantonBoldItalic',
        ));
  }
}
