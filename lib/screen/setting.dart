import 'dart:io';

import 'package:fit_well/screen/help.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../api/http/user_http.dart';
import '../api/log_status.dart';
import '../api/res/user_res.dart';
import '../resource/colors.dart';
import 'authentication/login.dart';
import 'setting/password_setting.dart';
import 'setting/user_setting.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late Future<User> getUser;
  bool progressPublication = false;

  void userData() async {
    getUser = UserHttp().getUser();
    User userData = await getUser;

    setState(() {
      progressPublication = userData.progressPublication!;
    });
  }

  @override
  void initState() {
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.iconHeading,
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: AppColors.iconHeading,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: sWidth * .05,
          bottom: 25,
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
                  SizedBox(
                    height: 15,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserSetting(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Update your personal information",
                      style: TextStyle(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PasswordSetting(),
                        ),
                      );
                    },
                    leading: Icon(
                      FontAwesomeIcons.lock,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    title: Text(
                      "Password",
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Change your password",
                      style: TextStyle(
                        color: AppColors.text,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
                    onTap: () async {
                      final resData = await UserHttp().publicProgress();
                      Fluttertoast.showToast(
                        msg: resData["resM"],
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Colors.green,
                        textColor: AppColors.onPrimary,
                        fontSize: 16.0,
                      );
                      setState(() {
                        progressPublication = !progressPublication;
                      });
                    },
                    leading: Icon(
                      FontAwesomeIcons.earthAsia,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    title: Text(
                      "Share points",
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Share your progress points",
                      style: TextStyle(
                        color: AppColors.text,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 25,
                      child: Switch(
                        activeColor: AppColors.primary,
                        inactiveThumbColor: AppColors.iconHeading,
                        value: progressPublication,
                        onChanged: (value) async {
                          final resData = await UserHttp().publicProgress();
                          Fluttertoast.showToast(
                            msg: resData["resM"],
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green,
                            textColor: AppColors.onPrimary,
                            fontSize: 16.0,
                          );
                          setState(() {
                            progressPublication = value;
                          });
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -2),
                    onTap: () async {
                      LogStatus().removeToken();
                      LogStatus.token = "";

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => Login(),
                        ),
                        (route) => false,
                      );
                    },
                    leading: Icon(
                      Icons.logout_outlined,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    title: Text(
                      "Log out",
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Logged in as " + snapshot.data!.profileName!,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColors.text,
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
                    ),
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
    );
  }
}
