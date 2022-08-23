import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/token_http.dart';
import '../../resource/colors.dart';
import 'enter_token.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "";

  bool p = true;
  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.button,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: AppColors.iconHeading,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: sWidth * 0.05,
            right: sWidth * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  key: ValueKey("email"),
                  onSaved: (value) {
                    email = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Email is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.button,
                    hintText: "Enter your email.....",
                    hintStyle: TextStyle(
                      color: AppColors.text,
                    ),
                    enabledBorder: formBorder,
                    focusedBorder: formBorder,
                    errorBorder: formBorder,
                    focusedErrorBorder: formBorder,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    TextFormField(
                      key: ValueKey("password"),
                      onChanged: (value) {
                        password = value;
                      },
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: "New password is required!"),
                      ]),
                      obscureText: p,
                      style: TextStyle(
                        color: AppColors.iconHeading,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.button,
                        hintText: "Enter a new password.....",
                        hintStyle: TextStyle(
                          color: AppColors.text,
                        ),
                        helperText:
                            "Most contain at least one upper case, lower case, number, special character, and 5 to 15 characters.",
                        helperMaxLines: 2,
                        helperStyle: TextStyle(
                          color: AppColors.primary,
                        ),
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          p = !p;
                        });
                      },
                      icon: Icon(
                        p
                            ? FontAwesomeIcons.solidEyeSlash
                            : FontAwesomeIcons.solidEye,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final resData =
                            await TokenHttp().generateToken(email, password);

                        if (resData["statusCode"] == 201) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => VerifyToken(
                                userId: resData["body"]["userId"],
                              ),
                            ),
                          );
                          Fluttertoast.showToast(
                            msg: "Token generated. Check your email.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: AppColors.onPrimary,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: resData["body"]["resM"],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: AppColors.onPrimary,
                            fontSize: 16.0,
                          );
                        }
                      }
                    },
                    child: Text(
                      "Get Token",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
