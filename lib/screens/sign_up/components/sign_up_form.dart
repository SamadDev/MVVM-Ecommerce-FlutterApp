import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/Services/Users_db.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/screens/sign_in/sign_in_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool showSpinner = false;
  final List<String> errors = [];

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
    return SafeArea(
      bottom: false,
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
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(22)),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                        Text("Register Account", style: headingStyle),
                        Text(
                          "Complete your details or continue \nwith social media",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.07),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildPasswordFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildConfirmPassFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildFullNameFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildPhoneNumberFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: SecondaryColorDark,
                                        width: 4,
                                      )),
                                      child: buildGovDropdown()),
                                ],
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              buildAddressFormField(),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(
                                        color: SecondaryColorDark,
                                        fontSize: 13,
                                        fontFamily: 'PantonBold'),
                                  ),
                                  ElevatedButton(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          color: SecondaryColorDark,
                                          fontSize: 15,
                                          fontFamily: 'PantonBoldItalic'),
                                    ),
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          EdgeInsets.symmetric(
                                            horizontal: 30,
                                          ),
                                        ),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.zero,
                                                side: BorderSide(
                                                    color: SecondaryColorDark,
                                                    width: 3.7))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                PrimaryColor),
                                        overlayColor: MaterialStateProperty
                                            .resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                          return null;
                                        })),
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, SignInScreen.routeName);
                                    },
                                  ),
                                ],
                              ),
                              FormError(errors: errors),
                              SizedBox(
                                  height: getProportionateScreenHeight(30)),
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
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: getProportionateScreenHeight(8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: SecondaryColorDark,
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.screenWidth * 0.18,
              child: ElevatedButton(
                child: Text(
                  "Continue",
                  style: TextStyle(
                      color: SecondaryColorDark,
                      fontSize: 20,
                      fontFamily: 'PantonBoldItalic'),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(PrimaryColor),
                    overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF98d668);
                      return null;
                    })),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    try {
                      final newUser = context
                          .read<AuthenticationService>()
                          .signUp(
                              email: email,
                              password: password,
                              fullName: fullName,
                              phoneNumber: phoneNumber,
                              governorate: selectedGov,
                              address: address);

                      if (newUser != null) {
                        Navigator.pushNamed(context, HomeScreen.routeName);
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    } catch (e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  } else {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
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
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
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
        labelText: "Confirm Password",
        hintText: "Re-enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
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
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
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
        labelText: "Address",
        hintText: "Enter your address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
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
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then label text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildFullNameFormField() {
    return TextFormField(
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
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Enter your full name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
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
