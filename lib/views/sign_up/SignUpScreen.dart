import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/utils/form_error.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../../view_models/auth_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/utils/keyboard.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = "/sign_up";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _confirmPassword;
  String _fullName;
  String _phoneNumber;
  String _selectedGov = 'Cairo';
  String _address;
  final List<String> _errors = [];
  ButtonState _stateTextWithIcon = ButtonState.idle;

  @override
  void initState() async {
    await auth_viewModel(FirebaseAuth.instance).AnonymousOrCurrent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(22)),
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
                                    border: Border.all(
                                        color: SecondaryColorDark, width: 2.8)),
                                child: buildGovDropdown()),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildAddressFormField(),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        FormError(errors: _errors),
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
        ),
      ),
    );
  }

  void onPressedIconWithText() async {
    setState(() {
      _stateTextWithIcon = ButtonState.loading;
    });
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection == true) {
      Future.delayed(Duration(milliseconds: 400), () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            //await context.read<auth_viewModel>().signOut();
            await context.read<auth_viewModel>().signUp(
                email: _email,
                password: _password,
                fullName: _fullName,
                phoneNumber: _phoneNumber,
                governorate: _selectedGov,
                address: _address);

            User user = context.read<auth_viewModel>().CurrentUser();

            if (user != null) {
              KeyboardUtil.hideKeyboard(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              );
              print("----------${user.email}----------");
            } else {
              setState(() {
                _stateTextWithIcon = ButtonState.fail;
              });
              Future.delayed(Duration(milliseconds: 1600), () {
                setState(() {
                  _stateTextWithIcon = ButtonState.idle;
                });
              });
            }
          } catch (e) {
            print(e);
            setState(() {
              _stateTextWithIcon = ButtonState.fail;
            });
            Future.delayed(Duration(milliseconds: 1600), () {
              setState(() {
                _stateTextWithIcon = ButtonState.idle;
              });
            });
          }
        } else {
          setState(() {
            _stateTextWithIcon = ButtonState.success;
          });
          Future.delayed(Duration(milliseconds: 1600), () {
            setState(() {
              _stateTextWithIcon = ButtonState.idle;
            });
          });
        }
      });
    } else {
      setState(() {
        _stateTextWithIcon = ButtonState.ExtraState1;
      });
      Future.delayed(Duration(milliseconds: 1600), () {
        if (!mounted) return;
        setState(() {
          _stateTextWithIcon = ButtonState.idle;
        });
      });
    }
  }

  Widget buildTextWithIcon() {
    return ProgressButton.icon(
        height: getProportionateScreenWidth(58),
        maxWidth: getProportionateScreenWidth(400),
        radius: 20.0,
        textStyle: TextStyle(
            color: Color(0xffeeecec),
            fontSize: 18,
            fontFamily: 'PantonBoldItalic'),
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Continue",
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading:
              IconedButton(text: "Loading", color: PrimaryColor),
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
        state: _stateTextWithIcon);
  }

  void addError({String error}) {
    if (!_errors.contains(error))
      setState(() {
        _errors.add(error);
      });
  }

  void removeError({String error}) {
    if (_errors.contains(error))
      setState(() {
        _errors.remove(error);
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      obscureText: true,
      onSaved: (newValue) => _password = newValue,
      onChanged: (value) {
        _password = value;
        if (value.length >= 8 || value.isEmpty) {
          removeError(error: ShortPassError);
        } else if (passwordValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidPassError);
        } else if (value.isNotEmpty) {
          removeError(error: PassNullError);
        } else if (_password == _confirmPassword) {
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
        } else if (_password != value) {
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
      onSaved: (newValue) => _confirmPassword = newValue,
      onChanged: (value) {
        _confirmPassword = value;

        if (_password == _confirmPassword) {
          removeError(error: MatchPassError);
        }
      },
      validator: (value) {
        if (_password != value) {
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
      onSaved: (newValue) => _email = newValue,
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
      onSaved: (newValue) => _address = newValue,
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
      onSaved: (newValue) => _phoneNumber = newValue,
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
      onSaved: (newValue) => _fullName = newValue,
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
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(30)),
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
        value: _selectedGov,
        items: getDropdownItems(),
        onChanged: (value) {
          setState(() {
            _selectedGov = value;
          });
        },
        dropdownColor: PrimaryLightColor,
        style: TextStyle(
          color: SecondaryColorDark,
          fontFamily: 'PantonBoldItalic',
        ));
  }
}
