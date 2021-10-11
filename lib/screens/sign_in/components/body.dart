import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/screens/sign_up/sign_up_screen.dart';
import '../../../size_config.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:shop_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import '../../../constants.dart';
import '../../../Services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignIn extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final List<String> errors = [];
  ButtonState stateTextWithIcon = ButtonState.idle;

  void onPressedIconWithText() async {
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    bool connection = await InternetConnectionChecker().hasConnection;
    if (connection == true) {
      Future.delayed(Duration(milliseconds: 600), () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            await context
                .read<AuthenticationService>()
                .signIn(email: email, password: password);

            User user = context.read<AuthenticationService>().CurrentUser();

            if (user != null) {
              KeyboardUtil.hideKeyboard(context);
              Navigator.pushNamed(context, HomeScreen.routeName);
              print("----------${user.email}----------");
            } else {
              setState(() {
                stateTextWithIcon = ButtonState.fail;
              });
              Future.delayed(Duration(milliseconds: 2000), () {
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
            Future.delayed(Duration(milliseconds: 2000), () {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            });
          }
        } else {
          setState(() {
            stateTextWithIcon = ButtonState.success;
          });
          Future.delayed(Duration(milliseconds: 2000), () {
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
        textStyle: TextStyle(
            color: Color(0xffeeecec),
            fontSize: 17,
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
              text: "Wrong email or password",
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
        body: SingleChildScrollView(
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
                                      fontSize: 12,
                                      fontFamily: 'PantonBold'),
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                      color: SecondaryColorDark,
                                      fontSize: 14,
                                      fontFamily: 'PantonBold'),
                                ),
                                signUpRedirect(),
                              ],
                            ),
                            SizedBox(height: SizeConfig.screenHeight * 0.02),
                            FormError(errors: errors),
                            SizedBox(height: SizeConfig.screenHeight * 0.02),
                            buildTextWithIcon(),
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
            color: Color(0xffeeecec),
            fontSize: 13,
            fontFamily: 'PantonBoldItalic'),
      ),
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: 25,
            ),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
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
