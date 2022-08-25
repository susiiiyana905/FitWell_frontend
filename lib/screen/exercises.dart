import 'package:fit_well/api/http/exercise_http.dart';
import 'package:flutter/material.dart';

import '../api/res/exercise_res.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';
import 'exercise_step.dart';

class ExerciseFromType extends StatefulWidget {
  final String? exerciseType;
  final String? exerciseTypeId;
  const ExerciseFromType(
      {Key? key, required this.exerciseType, required this.exerciseTypeId})
      : super(key: key);

  @override
  State<ExerciseFromType> createState() => _ExerciseFromTypeState();
}

class _ExerciseFromTypeState extends State<ExerciseFromType> {
  late Future<List<Exercise>> exercises;

  @override
  void initState() {
    super.initState();
    exercises = ExerciseHttp().getExercises(widget.exerciseTypeId!);
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
          widget.exerciseType!,
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
          bottom: 10,
        ),
        child: FutureBuilder<List<Exercise>>(
          future: exercises,
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
                  SizedBox(
                    height: 10,
                  ),
                  allExercises(
                    context,
                    snapshot.data!,
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
      bottomNavigationBar: PageNavigator(pageIndex: 0),
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
