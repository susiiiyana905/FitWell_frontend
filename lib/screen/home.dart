import 'package:fit_well/api/http/exercise_type_http.dart';
import 'package:fit_well/api/http/user_http.dart';
import 'package:fit_well/api/res/exercise_res.dart';
import 'package:fit_well/api/res/home_res.dart';
import 'package:fit_well/screen/exercise_step.dart';
import 'package:fit_well/screen/exercises.dart';
import 'package:fit_well/screen/setting/change_password.dart';
import 'package:flutter/material.dart';

import '../resource/colors.dart';
import '../widget/navigator.dart';
import 'setting.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int curTime = DateTime.now().hour;
  String greeting = "Fit Well";

  late Future<HomeData> userHomeData;

  ButtonStyle elevated = ElevatedButton.styleFrom(
    primary: AppColors.primary,
    minimumSize: Size.zero,
    padding: EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 5,
    ),
    elevation: 10,
    shadowColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );

  void getExerciseTypes() async {
    userHomeData = ExerciseTypeHttp().exerciseTypes();

    bool checkPassword = await UserHttp().checkPassword();

    if (checkPassword) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => ChangePassword(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (5 <= curTime && 12 >= curTime) {
      greeting = "Good Morning";
    } else if (12 <= curTime && 18 >= curTime) {
      greeting = "Good Afternoon";
    } else {
      greeting = "Good Evening";
    }

    getExerciseTypes();
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
            bottom: 10,
          ),
          child: FutureBuilder<HomeData>(
            future: userHomeData,
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
              } else {
                if (snapshot.hasData) {
                  children = <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sWidth * 0.03,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              color: AppColors.iconHeading,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            constraints: BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.settings,
                              color: AppColors.iconHeading,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => Setting(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    exerciseType(
                      context,
                      snapshot.data!.exerciseTypes!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    allExercises(
                      context,
                      snapshot.data!.exercises!,
                    ),
                    SizedBox(
                      height: 10,
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
      bottomNavigationBar: PageNavigator(pageIndex: 0),
    );
  }

  Widget exerciseType(BuildContext context, List<ExerciseType> types) {
    final sWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Exercise Types",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sWidth * .58),
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(
              types.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ExerciseFromType(
                          exerciseType: types[index].name,
                          exerciseTypeId: types[index].id!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            height: sWidth * 0.28,
                            width: sWidth * 0.28,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              types[index].image!,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        types[index].name!,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget allExercises(BuildContext context, List<Exercise> exercises) {
    final sWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Exercises",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sWidth * .58),
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: List.generate(
              exercises.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => StepsFromExercise(
                          exercise: exercises[index].name,
                          exerciseId: exercises[index].id!,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image(
                            height: sWidth * 0.28,
                            width: sWidth * 0.28,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              exercises[index].image!,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        exercises[index].name!,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
