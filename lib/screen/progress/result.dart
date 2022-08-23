import 'package:fitwell_frontend/api/http/progress_http.dart';
import 'package:fitwell_frontend/screen/progress/achievements.dart';
import 'package:fitwell_frontend/screen/progress/rank.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../api/res/progress_res.dart';
import '../../resource/colors.dart';
import '../../widget/navigator.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<ProgressData> userProgress;

  void loadProgress() {
    userProgress = ProgressHttp().getUserProgress();
  }

  @override
  void initState() {
    super.initState();
    loadProgress();
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
                              "Your Progress",
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
                                color: AppColors.iconHeading,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    progressPoints(
                      context,
                      snapshot.data!.progress!.progress!,
                      snapshot.data!.progress!.pmp!,
                      snapshot.data!.progress!.tmp!,
                    ),
                    thisMonthAchievements(
                      context,
                      snapshot.data!.progress!.newAchievement!,
                    ),
                    previousMonthAchievements(
                      context,
                      snapshot.data!.progress!.oldAchievement!,
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
      floatingActionButton: SizedBox(
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => AllAchievements(),
              ),
            );
          },
          backgroundColor: AppColors.primary,
          child: Icon(
            FontAwesomeIcons.medal,
            size: 20,
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 3),
    );
  }

  Widget progressPoints(
      BuildContext context, int progress1, int pmp1, int tmp1) {
    final sWidth = MediaQuery.of(context).size.width;

    String progress = progress1 > 1000
        ? (progress1 / 1000).toStringAsFixed(1) + " K"
        : progress1.toString();

    String pmp =
        pmp1 > 1000 ? (pmp1 / 1000).toStringAsFixed(1) + " K" : pmp1.toString();

    String tmp =
        tmp1 > 1000 ? (tmp1 / 1000).toStringAsFixed(1) + " K" : tmp1.toString();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: sWidth * .28,
                  height: sWidth * .28,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(sWidth * .14),
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
                    borderRadius: BorderRadius.circular(sWidth * .125),
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
                      text: pmp,
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
                text: "Last Month",
                style: TextStyle(
                  color: AppColors.iconHeading,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: sWidth * .32,
                  height: sWidth * .32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(sWidth * .16),
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
                  width: sWidth * .29,
                  height: sWidth * .29,
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary,
                    borderRadius: BorderRadius.circular(sWidth * .145),
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
                      text: progress,
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontSize: 18,
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
                text: "Total",
                style: TextStyle(
                  color: AppColors.iconHeading,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(sWidth * .14),
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
                    borderRadius: BorderRadius.circular(sWidth * .125),
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
                      text: tmp,
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
                text: "This Month",
                style: TextStyle(
                  color: AppColors.iconHeading,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget thisMonthAchievements(
      BuildContext context, List<Achievement> newAchievements) {
    final sHeight = MediaQuery.of(context).size.height;
    final sWidth = MediaQuery.of(context).size.width;

    if (newAchievements.isEmpty) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This Month Achievements",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.iconHeading,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sHeight * .24),
            crossAxisSpacing: 5,
            crossAxisCount: 2,
            children: List.generate(
              newAchievements.length,
              (index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: sHeight * 0.17,
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/achievement/" +
                              newAchievements[index].name! +
                              ".png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      newAchievements[index].name!,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget previousMonthAchievements(
      BuildContext context, List<Achievement> oldAchievements) {
    final sHeight = MediaQuery.of(context).size.height;
    final sWidth = MediaQuery.of(context).size.width;

    if (oldAchievements.isEmpty) {
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last Month Achievements",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.iconHeading,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sHeight * .24),
            crossAxisSpacing: 5,
            crossAxisCount: 2,
            children: List.generate(
              oldAchievements.length,
              (index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        height: sHeight * 0.17,
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/achievement/" +
                              oldAchievements[index].name! +
                              ".png",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      oldAchievements[index].name!,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
