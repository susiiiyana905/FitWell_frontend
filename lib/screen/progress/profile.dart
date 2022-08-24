import 'package:fit_well/api/http/progress_http.dart';
import 'package:fit_well/screen/progress/rank.dart';
import 'package:fit_well/screen/setting.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/http/user_http.dart';
import '../../api/log_status.dart';
import '../../api/res/progress_res.dart';
import '../../api/res/user_res.dart';
import '../../resource/colors.dart';
import '../../widget/navigator.dart';
import '../authentication/login.dart';
import '../setting/password_setting.dart';
import '../setting/user_setting.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User getUser;
  late Future<ProgressData> userProgress;
  bool progressPublication = false;

  void userData() async {
    getUser = await UserHttp().getUser();

    setState(() {
      progressPublication = getUser.progressPublication!;
    });
  }

  void loadProgress() {
    userProgress = ProgressHttp().getUserProgress();
  }

  @override
  void initState() {
    super.initState();
    loadProgress();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            right: sWidth * 0.03,
            bottom: 40,
            left: sWidth * 0.03,
          ),
          child: FutureBuilder<ProgressData>(
            future: userProgress,
            builder: ((context, snapshot) {
              List<Widget> children = [];
              if (snapshot.connectionState == ConnectionState.waiting) {
                children = <Widget>[
                  Container(
                    width: sWidth,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                snapshot.data!.progress!.user!.profilePicture!,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Your Profile",
                              style: TextStyle(
                                color: AppColors.iconHeading,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => RankingSystem(),
                                  ),
                                );
                              },
                              icon: Icon(
                                FontAwesomeIcons.rankingStar,
                                size: 18,
                                color: AppColors.iconHeading,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: sWidth * .28,
                              height: sWidth * .28,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius:
                                    BorderRadius.circular(sWidth * .14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              width: sWidth * .25,
                              height: sWidth * .25,
                              decoration: BoxDecoration(
                                color: AppColors.onPrimary,
                                borderRadius:
                                    BorderRadius.circular(sWidth * .125),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: snapshot.data!.progress!.progress
                                      .toString(),
                                  style: TextStyle(
                                    color: AppColors.iconHeading,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Progress Points",
                            style: TextStyle(
                              color: AppColors.iconHeading,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      minVerticalPadding: 0,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -2),
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -2),
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -2),
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
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -2),
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
                        "Logged in as " + getUser.profileName!,
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
            }),
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 2),
    );
  }
}
