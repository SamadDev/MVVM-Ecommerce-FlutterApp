import 'package:flutter/material.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/components/no_account_text.dart';
import 'package:shop_app/size_config.dart';
import 'package:flutter/cupertino.dart';
import '../../../size_config.dart';
import 'package:shop_app/helper/keyboard.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../constants.dart';

class Body extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<Body> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Reset Password",
            style: TextStyle(
              color: SecondaryColor,
              fontSize: getProportionateScreenWidth(18),
              fontFamily: 'Panton',
            ),
          ),
          backgroundColor: SecondaryColorDark,
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(28),
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Please enter your email and we will send \nyou a link to reset your password",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.1),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (newValue) => email = newValue,
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  errors.contains(EmailNullError)) {
                                setState(() {
                                  errors.remove(EmailNullError);
                                });
                              } else if (value.isEmpty &&
                                      errors.contains(InvalidEmailError) ||
                                  emailValidatorRegExp.hasMatch(value) &&
                                      errors.contains(InvalidEmailError)) {
                                setState(() {
                                  errors.remove(InvalidEmailError);
                                });
                              }
                              return null;
                            },
                            validator: (value) {
                              if (value.isEmpty &&
                                  !errors.contains(EmailNullError)) {
                                setState(() {
                                  showSpinner = false;
                                  errors.add(EmailNullError);
                                });
                              } else if (!emailValidatorRegExp
                                      .hasMatch(value) &&
                                  !errors.contains(InvalidEmailError)) {
                                setState(() {
                                  showSpinner = false;
                                  errors.add(InvalidEmailError);
                                });
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Enter your email",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                  svgIcon: "assets/icons/Mail.svg"),
                            ),
                          ),
                          SizedBox(height: getProportionateScreenHeight(30)),
                          FormError(errors: errors),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    // if all are valid then go to success screen
                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      Navigator.of(context).pop();
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
}
