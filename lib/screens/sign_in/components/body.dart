import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Sign In",
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(22)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.07),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                            color: SecondaryColorDark,
                            fontSize: getProportionateScreenWidth(28),
                            fontFamily: 'PantonBoldItalic',
                          ),
                        ),
                        Text(
                          "Sign in with your email and password  \nor continue with social media",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.screenHeight * 0.1),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              buildEmailFormField(),
                              SizedBox(height: SizeConfig.screenHeight * 0.05),
                              buildPasswordFormField(),
                              SizedBox(height: SizeConfig.screenHeight * 0.05),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, ForgotPasswordScreen.routeName),
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: SecondaryColorDark,
                                        fontSize: 13,
                                        fontFamily: 'PantonBold'),
                                  ),
                                ),
                              ),
                              SizedBox(height: SizeConfig.screenHeight * 0.025),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        color: SecondaryColorDark,
                                        fontSize: 15,
                                        fontFamily: 'PantonBold'),
                                  ),
                                  signUpRedirect(),
                                ],
                              ),
                              SizedBox(height: SizeConfig.screenHeight * 0.02),
                              FormError(errors: errors),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
              height: SizeConfig.screenWidth * 0.19,
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
                onPressed: () {
                  setState(() {
                    showSpinner = true;
                  });
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // if all are valid then go to success screen
                    try {
                      final user = context
                          .read<AuthenticationService>()
                          .signIn(email: email, password: password);

                      if (user != null) {
                        KeyboardUtil.hideKeyboard(context);
                        Navigator.pushNamed(context, HomeScreen.routeName);
                        print(user);
                      } else {
                        errors.add(InvalidEmailError);
                        print(user);
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
        if (value.length >= 8 || value.isEmpty) {
          removeError(error: ShortPassError);
        } else if (value.isNotEmpty) {
          removeError(error: PassNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: PassNullError);
          return '';
        } else if (value.length < 8 && value.length != 0) {
          addError(error: ShortPassError);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
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
          return '';
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidEmailError);
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

class signUpRedirect extends StatelessWidget {
  const signUpRedirect({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        "Sign-Up",
        style: TextStyle(
            color: SecondaryColorDark,
            fontSize: 15,
            fontFamily: 'PantonBoldItalic'),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: 30,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: SecondaryColorDark, width: 3.7))),
          backgroundColor: MaterialStateProperty.all<Color>(PrimaryColor),
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return null;
          })),
      onPressed: () {
        Navigator.pushNamed(context, SignUpScreen.routeName);
      },
    );
  }
}
