import 'package:fitwell_frontend/api/http/achievement_http.dart';
import 'package:fitwell_frontend/api/res/progress_res.dart';
import 'package:fitwell_frontend/widget/navigator.dart';
import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class AllAchievements extends StatefulWidget {
  const AllAchievements({Key? key}) : super(key: key);

  @override
  State<AllAchievements> createState() => _AllAchievementsState();
}

class _AllAchievementsState extends State<AllAchievements> {
  late Future<List<Achievement>> allAchievements;

  void getAchievements() {
    allAchievements = AchievementHttp().getAllAchievements();
  }

  @override
  void initState() {
    super.initState();

    getAchievements();
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
          "Achievements",
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
          top: 10,
          right: sWidth * 0.03,
          left: sWidth * 0.03,
          bottom: 10,
        ),
        child: FutureBuilder<List<Achievement>>(
          future: allAchievements,
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
              children = <Widget>[
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: (sWidth - (sWidth * .53)) / (sHeight * .24),
                  crossAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: List.generate(
                    snapshot.data!.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (builder) => achievementDetail(
                              context,
                              snapshot.data![index].name!,
                              snapshot.data![index].progressPoint!,
                              snapshot.data![index].description!,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                height: sHeight * 0.17,
                                width: sWidth * 0.4,
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                  "image/achievement/" +
                                      snapshot.data![index].name! +
                                      ".png",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data![index].name!,
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                color: AppColors.iconHeading,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ];
              if (snapshot.hasData) {
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
      bottomNavigationBar: PageNavigator(
        pageIndex: 3,
      ),
    );
  }

  Widget achievementDetail(BuildContext context, String name, int progressPoint,
      String description) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return SimpleDialog(
      backgroundColor: AppColors.background,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(10),
      children: [
        Column(
          children: [
            Text(
              name,
              style: TextStyle(
                color: AppColors.iconHeading,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                height: sHeight * 0.17,
                width: sWidth * 0.4,
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  "image/achievement/" + name + ".png",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Progress Point: " + progressPoint.toString(),
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
