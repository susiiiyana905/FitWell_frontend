import 'package:fit_well/api/http/completed_http.dart';
import 'package:fit_well/api/res/home_res.dart';
import 'package:flutter/material.dart';
import '../api/res/exercise_res.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';
import 'exercise_step.dart';

class UserExercises extends StatefulWidget {
  const UserExercises({Key? key}) : super(key: key);

  @override
  State<UserExercises> createState() => _UserExercisesState();
}

class _UserExercisesState extends State<UserExercises> {
  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.button,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  TextStyle textStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.black87,
  );

  late Future<Workout> myExercises;

  @override
  void initState() {
    super.initState();
    myExercises = CompletedHttp().myExercises();
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
              left: sWidth * 0.03,
              bottom: 50,
            ),
            child: FutureBuilder<Workout>(
              future: myExercises,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  snapshot.data!.profilePicture!,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Exercises",
                                style: TextStyle(
                                  color: AppColors.iconHeading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                                  color: Colors.green,
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
                                    text: snapshot.data!.todayProgressPoint!
                                        .toString(),
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
                      SizedBox(
                        height: 10,
                      ),
                      favoriteExercise(context, snapshot.data!.myFavorite!),
                      SizedBox(
                        height: 20,
                      ),
                      todayExercise(context, snapshot.data!.todayExercises!),
                      SizedBox(
                        height: 20,
                      ),
                      recentExercise(context, snapshot.data!.recentExercises!),
                      SizedBox(
                        height: 10,
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    if ("${snapshot.error}".split("Exception: ")[0] ==
                        "Socket") {
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
            )),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 1),
    );
  }

  Widget favoriteExercise(BuildContext context, List<Exercise> exercises) {
    final sWidth = MediaQuery.of(context).size.width;

    if (exercises.isEmpty) {
      return SizedBox();
    }

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
                "Favorite Exercises",
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

  Widget todayExercise(BuildContext context, List<Exercise> exercises) {
    final sWidth = MediaQuery.of(context).size.width;

    if (exercises.isEmpty) {
      return SizedBox();
    }

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
                "Today Exercises",
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

  Widget recentExercise(BuildContext context, List<Exercise> exercises) {
    final sWidth = MediaQuery.of(context).size.width;

    if (exercises.isEmpty) {
      return SizedBox();
    }

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
                "Previous Exercises",
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
