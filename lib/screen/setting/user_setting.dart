import 'package:fitwell_frontend/api/log_status.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../api/http/user_http.dart';
import '../../api/res/user_res.dart';
import '../../resource/colors.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  TextEditingController profileNameController = TextEditingController(),
      emailController = TextEditingController();
  String profileName = "", email = "";
  String? gender;

  bool editEmail = true;

  final _formKey = GlobalKey<FormState>();

  late Future<User> getUser;

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.button,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.all(5),
    minimumSize: Size.zero,
    primary: AppColors.primary,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  void loadData() async {
    getUser = UserHttp().getUser();
    getUser.then((value) {
      profileNameController.text = value.profileName!;
      emailController.text = value.email!;
      profileName = value.profileName!;
      email = value.email!;
      gender = value.gender!;
    });

    bool googleSignIn = await LogStatus().googleSignIn();
    if (googleSignIn) {
      editEmail = false;
    }
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personal Information",
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
            color: AppColors.iconHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            right: sWidth * .05,
            left: sWidth * .05,
          ),
          child: FutureBuilder<User>(
            future: getUser,
            builder: (context, snapshot) {
              List<Widget> children = [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                children = <Widget>[
                  Container(
                    width: sWidth * 0.97,
                    height: sHeight,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: AppColors.primary,
                      backgroundColor: AppColors.button,
                    ),
                  )
                ];
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  children = <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0, right: 0, bottom: 10),
                            minLeadingWidth: 0,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Profile Name:",
                                  style: TextStyle(
                                    color: AppColors.iconHeading,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: profileNameController,
                                  onChanged: (value) {
                                    profileName = value.trim();
                                  },
                                  validator: MultiValidator([
                                    RequiredValidator(
                                        errorText:
                                            "New profile ame is required"),
                                  ]),
                                  style: TextStyle(
                                    color: AppColors.iconHeading,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: AppColors.button,
                                    hintText: "Enter new Profile Name",
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
                                )
                              ],
                            ),
                          ),
                          editEmail
                              ? ListTile(
                                  contentPadding: EdgeInsets.only(
                                      left: 0, right: 0, bottom: 10),
                                  minLeadingWidth: 0,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Email:",
                                        style: TextStyle(
                                          color: AppColors.iconHeading,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        controller: emailController,
                                        onSaved: (value) {
                                          email = value!.trim();
                                        },
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText:
                                                  "New email is required"),
                                        ]),
                                        style: TextStyle(
                                          color: AppColors.iconHeading,
                                        ),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          filled: true,
                                          fillColor: AppColors.button,
                                          hintText: "Enter new Email",
                                          hintStyle: TextStyle(
                                            color: AppColors.text,
                                          ),
                                          enabledBorder: formBorder,
                                          focusedBorder: formBorder,
                                          errorBorder: formBorder,
                                          focusedErrorBorder: formBorder,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(left: 0, right: 0, bottom: 10),
                      minLeadingWidth: 0,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gender:",
                            style: TextStyle(
                              color: AppColors.iconHeading,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => AppColors.primary),
                                value: "Male",
                                groupValue: gender,
                                onChanged: (String? value) => setState(() {
                                  gender = value;
                                }),
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                  color: AppColors.iconHeading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => AppColors.primary),
                                value: "Female",
                                groupValue: gender,
                                onChanged: (String? value) => setState(() {
                                  gender = value;
                                }),
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: AppColors.iconHeading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Radio(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => AppColors.primary),
                                value: "Other",
                                groupValue: gender,
                                onChanged: (String? value) => setState(() {
                                  gender = value;
                                }),
                              ),
                              Text(
                                "Other",
                                style: TextStyle(
                                  color: AppColors.iconHeading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          )
                        ],
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

                            final resData = await UserHttp()
                                .changeProfileInfo(email, profileName, gender!);

                            if (resData["statusCode"] == 200) {
                              Navigator.pop(context);
                              Fluttertoast.showToast(
                                msg: resData["body"]["resM"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: resData["body"]["resM"],
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        },
                        child: Text(
                          "Update",
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
                  ];
                } else if (snapshot.hasError) {
                  if ("${snapshot.error}".split("Exception: ")[0] == "Socket") {
                    children = <Widget>[
                      Container(
                        width: sWidth,
                        height: sHeight,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.warning_rounded,
                              size: 25,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Connection Problem",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ];
                  } else {
                    children = <Widget>[
                      Container(
                        width: sWidth,
                        height: sHeight,
                        alignment: Alignment.center,
                        child: Text(
                          "${snapshot.error}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )
                    ];
                  }
                }
              }
              return Column(
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
