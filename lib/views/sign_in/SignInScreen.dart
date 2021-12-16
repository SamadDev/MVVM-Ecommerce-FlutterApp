import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/views/sign_up/SignUpScreen.dart';
import '../../utils/size_config.dart';
import 'package:ecommerce_app/utils/form_error.dart';
import 'package:ecommerce_app/utils/keyboard.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import '../../utils/constants.dart';
import 'Reset_Password.dart';
import 'package:ecommerce_app/models/social_card.dart';
import '../../view_models/auth_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = "/sign_in";
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  final List<String> _errors = [];
  ButtonState _stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
        body: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(22)),
            child: ListView(
              children: [
                SizedBox(height: getProportionateScreenWidth(60)),
                Text(
                  "Welcome Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: SecondaryColorDark,
                    fontSize: getProportionateScreenWidth(28),
                    fontFamily: 'PantonBoldItalic',
                  ),
                ),
                SizedBox(height: getProportionateScreenWidth(5)),
                Text(
                  "Sign in with your email and password \nor sign in with social media",
                  style: TextStyle(
                      fontFamily: 'Panton', color: SecondaryColorDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: getProportionateScreenWidth(60)),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildEmailFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      buildPasswordFormField(),
                      SizedBox(height: SizeConfig.screenHeight * 0.045),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (BuildContext bc) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: ResetPassBottomSheet(),
                                );
                              }),
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
                      SizedBox(height: SizeConfig.screenHeight * 0.015),
                      FormError(errors: _errors),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      buildTextWithIcon(),
                      // SizedBox(height: SizeConfig.screenHeight * 0.03),
                      // Divider(
                      //   thickness: 2,
                      //   endIndent: getProportionateScreenWidth(40),
                      //   indent: getProportionateScreenWidth(40),
                      //   color: SecondaryColor.withOpacity(0.25),
                      // ),
                      // SizedBox(height: SizeConfig.screenHeight * 0.03),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SocialCard(
                      //       icon: "assets/icons/google-icon.svg",
                      //       press: () {},
                      //     ),
                      //     SocialCard(
                      //       icon: "assets/icons/apple-logo.svg",
                      //       press: () {},
                      //     ),
                      //     SocialCard(
                      //       icon: "assets/icons/facebook-2.svg",
                      //       press: () {},
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
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
      Future.delayed(Duration(milliseconds: 600), () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          try {
            await context.read<auth_viewModel>().signOut();
            await context
                .read<auth_viewModel>()
                .signIn(email: _email, password: _password);

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
              Future.delayed(Duration(milliseconds: 2000), () {
                setState(() {
                  _stateTextWithIcon = ButtonState.idle;
                });
              });
            }
          } catch (e) {
            print(e);
            if (this.mounted) {
              setState(() {
                _stateTextWithIcon = ButtonState.fail;
              });
            }
            Future.delayed(Duration(milliseconds: 2000), () {
              if (this.mounted) {
                setState(() {
                  _stateTextWithIcon = ButtonState.idle;
                });
              }
            });
          }
        } else {
          setState(() {
            _stateTextWithIcon = ButtonState.success;
          });
          Future.delayed(Duration(milliseconds: 2000), () {
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      obscureText: true,
      onSaved: (newValue) => _password = newValue,
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
          return '';
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidEmailError);
          return '';
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
