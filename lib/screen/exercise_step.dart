import 'package:fit_well/api/http/completed_http.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/http/exercise_step_http.dart';
import '../api/res/exercise_res.dart';
import '../resource/colors.dart';
import '../widget/navigator.dart';

class StepsFromExercise extends StatefulWidget {
  final String? exercise;
  final String? exerciseId;
  const StepsFromExercise(
      {Key? key, required this.exercise, required this.exerciseId})
      : super(key: key);

  @override
  State<StepsFromExercise> createState() => _ExerciseStepState();
}

class _ExerciseStepState extends State<StepsFromExercise> {
  late Future<List<ExerciseStep>> exerciseSteps;

  @override
  void initState() {
    super.initState();
    exerciseSteps = ExerciseStepHttp().getExerciseSteps(widget.exerciseId!);
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
          widget.exercise!,
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
        child: FutureBuilder<List<ExerciseStep>>(
          future: exerciseSteps,
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
                  stepsOfExercise(
                    context,
                    snapshot.data!,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await CompletedHttp()
                          .completeExercise(widget.exerciseId!);

                      Navigator.pop(context);
                      Fluttertoast.showToast(
                        msg: "Exercise Completed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.green,
                        textColor: AppColors.onPrimary,
                        fontSize: 16.0,
                      );
                    },
                    child: Text(
                      "Complete",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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

  Widget stepsOfExercise(
      BuildContext context, List<ExerciseStep> exerciseSteps) {
    final sWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exerciseSteps.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step " + (index + 1).toString(),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.iconHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image(
                    width: sWidth * .94,
                    height: 200,
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(
                      exerciseSteps[index].image!,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: exerciseSteps[index].step!.length,
                    itemBuilder: (context, index1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: sWidth * .94,
                              padding: const EdgeInsets.only(top: 5),
                              child: RichText(
                                text: TextSpan(
                                  text: (index1 + 1).toString() +
                                      ". " +
                                      exerciseSteps[index].step![index1],
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: AppColors.iconHeading,
                                  ),
                                ),
                              )),
                        ],
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
