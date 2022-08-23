import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/authentication/sign_up_http.dart';
import '../../api/model/user_model.dart';
import '../../resource/colors.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String email = "", password = "", confirmPassword = "", profileName = "";
  String? gender = "";

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
    final _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Expense Tracker',
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
            left: _screenWidth * 0.05,
            right: _screenWidth * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    image: AssetImage("image/logo.png"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                TextFormField(
                  key: ValueKey("profileName"),
                  onSaved: (value) {
                    profileName = value!;
                  },
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Profile name is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.button,
                    hintText: "Enter your profile name.....",
                    hintStyle: TextStyle(
                      color: AppColors.text,
                    ),
                    helperText:
                        "Most have 3 to 20 characters. Special characters and numbers are not accepted.",
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
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  key: ValueKey("password"),
                  onSaved: (value) {
                    password = value!;
                  },
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Password is required!"),
                    ]);
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.button,
                    hintText: "Enter a password.....",
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
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  key: ValueKey("confirmPassword"),
                  onSaved: (value) {
                    confirmPassword = value!;
                  },
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(
                          errorText: "Password confirmation is required!"),
                    ]);
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.button,
                    hintText: "Enter the password again.....",
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
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        final resData = await SignUpHttp().signUp(
                          UploadUser(
                            email: email,
                            profileName: profileName,
                            password: password,
                            confirmPassword: confirmPassword,
                          ),
                        );
                        if (resData["statusCode"] == 201) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: AppColors.primary,
                            msg: resData["body"]["resM"],
                          );
                        } else {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: AppColors.primary,
                            msg: resData["body"]["resM"],
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,
                          textColor: AppColors.primary,
                          msg: "Please fill the required form",
                        );
                      }
                    },
                    child: Text(
                      "Register",
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
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
