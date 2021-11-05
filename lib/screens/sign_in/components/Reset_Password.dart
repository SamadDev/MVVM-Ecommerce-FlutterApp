import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/size_config.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ResetPassBottomSheet extends StatefulWidget {
  @override
  _ResetPassBottomSheetState createState() => _ResetPassBottomSheetState();
}

class _ResetPassBottomSheetState extends State<ResetPassBottomSheet> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String email;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 30,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (newValue) => email = newValue,
                  onChanged: (value) {
                    if (value.isNotEmpty && errors.contains(EmailNullError)) {
                      errors.remove(EmailNullError);
                    } else if (value.isEmpty && errors.contains(InvalidEmailError) ||
                        emailValidatorRegExp.hasMatch(value) &&
                            errors.contains(InvalidEmailError)) {
                      errors.remove(InvalidEmailError);
                    }
                    return null;
                  },
                  validator: (value) {
                    if (value.isEmpty && !errors.contains(EmailNullError)) {
                      errors.add(EmailNullError);
                      return "";
                    } else if (!emailValidatorRegExp.hasMatch(value) &&
                        !errors.contains(InvalidEmailError)) {
                      errors.add(InvalidEmailError);
                      return "";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    contentPadding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenWidth(19),
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
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                FormError(errors: errors),
                SizedBox(height: getProportionateScreenHeight(15)),
                buildTextWithIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
            await _auth.sendPasswordResetEmail(email: email);
            setState(() {
              stateTextWithIcon = ButtonState.success;
            });
            Future.delayed(Duration(milliseconds: 1300), () {
              setState(() {
                Navigator.pop(context);
              });
            });
          } catch (e) {
            print(e);
            setState(() {
              stateTextWithIcon = ButtonState.ExtraState1;
            });
            Future.delayed(Duration(milliseconds: 1600), () {
              setState(() {
                stateTextWithIcon = ButtonState.idle;
              });
            });
          }
        } else {
          setState(() {
            stateTextWithIcon = ButtonState.ExtraState1;
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
        stateTextWithIcon = ButtonState.fail;
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
        textStyle: TextStyle(color: Colors.white, fontSize: 17, fontFamily: 'PantonBoldItalic'),
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Reset Password",
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading: IconedButton(text: "Loading", color: PrimaryColor),
          ButtonState.fail: IconedButton(
              text: "Connection Lost",
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor),
          ButtonState.success: IconedButton(
              text: "Emial Sent",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400),
          ButtonState.ExtraState1: IconedButton(
              text: "Invalid Input",
              icon: Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              color: PrimaryColor),
        },
        onPressed: () => onPressedIconWithText(),
        state: stateTextWithIcon);
  }
}
