import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/token_http.dart';
import '../../resource/colors.dart';
import 'login.dart';

class VerifyToken extends StatefulWidget {
  final String? userId;
  const VerifyToken({Key? key, @required this.userId}) : super(key: key);

  @override
  State<VerifyToken> createState() => _VerifyTokenState();
}

class _VerifyTokenState extends State<VerifyToken> {
  final _formKey = GlobalKey<FormState>();
  String token = "";
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
          "Verify Token",
          style: TextStyle(
            color: AppColors.iconHeading,
            fontSize: 18,
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: Key("Token"),
                  onSaved: (value) {
                    token = value!;
                  },
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    MultiValidator([
                      RequiredValidator(errorText: "Token is required!"),
                    ]);
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: AppColors.button,
                    hintText: "Enter the token.....",
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

                        final resData = await TokenHttp()
                            .verifyToken(token, widget.userId!);

                        if (resData["statusCode"] == 200) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => Login(),
                            ),
                            (route) => false,
                          );
                          Fluttertoast.showToast(
                            msg: resData["body"]["resM"],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 5,
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
                      "Reset Password",
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
