import '../../../../utils/constants.dart';
import '../../../../view_models/globalVariables_viewModel.dart';
import '../../../../utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/utils/keyboard.dart';
import 'package:ecommerce_app/view_models/user_info_viewModel.dart';
import '../../../../view_models/auth_viewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_app/utils/form_error.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UserInfoScreen extends StatefulWidget {
  static String routeName = "/userInfo";
  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  User _u;
  String _email;
  String _fullName;
  String _phoneNumber;
  String _selectedGov;
  String _address;
  final List<String> _errors = [];
  ButtonState _stateTextWithIcon = ButtonState.idle;
  Future _futureUserInfo;

  @override
  void initState() {
    _u = Provider.of<auth_viewModel>(context, listen: false).CurrentUser();
    _futureUserInfo =
        Provider.of<globalVars>(context, listen: false).getUserInfo(_u);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: PrimaryLightColor,
        appBar: AppBar(
          elevation: 5,
          shadowColor: SecondaryColorDark.withOpacity(0.2),
          iconTheme: IconThemeData(color: SecondaryColorDark),
          title: Text(
            "My Details",
            style: TextStyle(
              color: SecondaryColorDark,
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.w900,
              fontFamily: 'Panton',
            ),
          ),
          backgroundColor: CardBackgroundColor,
        ),
        body: Consumer<globalVars>(builder: (_, gv, __) {
          return FutureBuilder(
            future: _futureUserInfo,
            builder: (context, snapshot) {
              _email = _u.email;
              _fullName = gv.UserInfo['Full Name'];
              _phoneNumber = gv.UserInfo['Phone Number'];
              _address = gv.UserInfo['Address'];
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateScreenWidth(20)),
                          child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      getProportionateScreenHeight(33)), // 4%
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    buildEmailFormField(_email),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    buildFullNameFormField(_fullName),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    buildPhoneNumberFormField(_phoneNumber),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Governorate:",
                                          style: TextStyle(
                                            fontFamily: 'PantonBoldItalic',
                                            color: SecondaryColorDark,
                                            fontSize:
                                                SizeConfig.screenWidth * 0.046,
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                border: Border.all(
                                                    color: SecondaryColorDark,
                                                    width: 2.8)),
                                            child: buildGovDropdown(
                                                gv.UserInfo['Governorate'])),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(30)),
                                    buildAddressFormField(_address),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    FormError(errors: _errors),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(20)),
                                    buildTextWithIcon(),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(35)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                      height: getProportionateScreenWidth(40),
                      width: getProportionateScreenWidth(40),
                      child: CircularProgressIndicator(
                        color: SecondaryColorDark,
                      )),
                );
              }
              return Container();
            },
          );
        }),
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
            KeyboardUtil.hideKeyboard(context);
            await user_info_viewModel(uid: _u.uid)
                .addUserData(_fullName, _phoneNumber, _selectedGov, _address);
            setState(() {
              _stateTextWithIcon = ButtonState.success;
            });
            Future.delayed(Duration(milliseconds: 1300), () {
              setState(() {
                _stateTextWithIcon = ButtonState.idle;
              });
            });
          } catch (e) {
            print(e);
            setState(() {
              _stateTextWithIcon = ButtonState.ExtraState1;
            });
            Future.delayed(Duration(milliseconds: 1600), () {
              setState(() {});
            });
          }
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
        height: getProportionateScreenWidth(60),
        maxWidth: getProportionateScreenWidth(400),
        radius: 20.0,
        textStyle: TextStyle(
            color: Color(0xffeeecec),
            fontSize: getProportionateScreenWidth(20),
            fontFamily: 'PantonBoldItalic'),
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Apply",
              icon: Icon(
                Icons.add_rounded,
                size: 0.01,
                color: PrimaryColor,
              ),
              color: PrimaryColor),
          ButtonState.loading:
              IconedButton(text: "Loading", color: PrimaryColor),
          ButtonState.fail: IconedButton(
              text: "Invalid Input",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: PrimaryColor),
          ButtonState.success: IconedButton(
              text: "applied successfully",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400),
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

  TextFormField buildEmailFormField(String LabelText) {
    return TextFormField(
      enableInteractiveSelection: false,
      style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: getProportionateScreenWidth(16),
          color: Color(0xff5c5e5e)),
      initialValue: LabelText,
      readOnly: true,
      decoration: InputDecoration(
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

  TextFormField buildAddressFormField(String LabelText) {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      onSaved: (newValue) => newValue.isEmpty ? _address : _address = newValue,
      decoration: InputDecoration(
        labelText: LabelText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xff5c5e5e),
            fontSize: getProportionateScreenWidth(14)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.only(
            top: getProportionateScreenWidth(20),
            bottom: getProportionateScreenWidth(20),
            left: getProportionateScreenWidth(30)),
        suffixIcon: Padding(
          padding: EdgeInsets.only(right: getProportionateScreenWidth(24)),
          child: Icon(
            Icons.location_on_outlined,
            size: getProportionateScreenWidth(28),
            color: PrimaryColor,
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(String LabelText) {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      keyboardType: TextInputType.phone,
      onSaved: (newValue) =>
          newValue.isEmpty ? _phoneNumber : _phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && phoneNumValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidPhoneNumError);
        }
        return null;
      },
      validator: (value) {
        if (value.isNotEmpty && !phoneNumValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidPhoneNumError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LabelText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xff5c5e5e),
            fontSize: getProportionateScreenWidth(16)),
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

  TextFormField buildFullNameFormField(String LabelText) {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.w800),
      onSaved: (newValue) =>
          newValue.isEmpty ? _fullName : _fullName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && nameValidatorRegExp.hasMatch(value)) {
          removeError(error: InvalidNameError);
        }
        return null;
      },
      validator: (value) {
        if (value.isNotEmpty && !nameValidatorRegExp.hasMatch(value)) {
          addError(error: InvalidNameError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: LabelText,
        labelStyle: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xff5c5e5e),
            fontSize: getProportionateScreenWidth(16)),
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

  DropdownButton buildGovDropdown(String userGov) {
    return DropdownButton<String>(
        value: (_selectedGov == null || _selectedGov.isEmpty)
            ? _selectedGov = userGov
            : _selectedGov,
        items: getDropdownItems(),
        onChanged: (value) {
          setState(() {
            _selectedGov = value;
          });
        },
        dropdownColor: PrimaryLightColor,
        style: TextStyle(
          color: Color(0xff5c5e5e),
          fontFamily: 'PantonBoldItalic',
        ));
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
}
