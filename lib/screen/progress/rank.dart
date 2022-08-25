import 'package:fit_well/api/http/progress_http.dart';
import 'package:fit_well/api/res/progress_res.dart';
import 'package:fit_well/widget/navigator.dart';
import 'package:flutter/material.dart';

import '../../resource/colors.dart';

class RankingSystem extends StatefulWidget {
  const RankingSystem({Key? key}) : super(key: key);

  @override
  State<RankingSystem> createState() => _RankingSystemState();
}

class _RankingSystemState extends State<RankingSystem> {
  late Future<TopProgress> usersProgress;
  List<Progress> progressPoints = [];
  List<Progress> tmpPoints = [];
  List<Progress> pmpPoints = [];
  List<Progress> progressList = [];
  List<String> pointList = [];
  int progressIndex = 0;

  void topUsersProgress() {
    usersProgress = ProgressHttp().topUsersProgress();
    usersProgress.then((value) {
      progressPoints = value.progressPoints!;
      tmpPoints = value.tmpPoints!;
      pmpPoints = value.pmpPoints!;
      progressList = value.progressPoints!;

      for (int i = 0; i < progressList.length; i++) {
        String point = "";
        point = progressList[i].progress! > 1000
            ? (progressList[i].progress! / 1000).toStringAsFixed(1) + " K"
            : progressList[i].progress!.toString();
        pointList.add(point);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    topUsersProgress();
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
          "Progress Point Ranking",
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
          right: sWidth * 0.03,
          left: sWidth * 0.03,
          bottom: 10,
        ),
        child: FutureBuilder<TopProgress>(
          future: usersProgress,
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
                SizedBox(
                  height: 10,
                ),
                rankedUsers(context),
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
        pageIndex: 2,
      ),
    );
  }

  Widget rankedUsers(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    Color color = Colors.black54;
    if (progressIndex == 0) {
      color = AppColors.primary;
    } else if (progressIndex == 1) {
      color = Colors.green;
    } else if (progressIndex == 2) {
      color = Colors.orange;
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: progressList.length,
      itemBuilder: ((context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    (index + 1).toString() + ".",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.iconHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.form,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            progressList[index].user!.profilePicture!),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: sWidth * .4,
                    child: Text(
                      progressList[index].user!.profileName!,
                      textAlign: TextAlign.start,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.iconHeading,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(32.5),
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
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(27.5),
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
                        text: pointList[index],
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
