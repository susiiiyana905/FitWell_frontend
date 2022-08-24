import 'package:flutter/material.dart';

import 'api/log_status.dart';
import '../resource/colors.dart';
import 'screen/authentication/login.dart';
import 'screen/home.dart';

void main() {
  WidgetsFlutterBinding();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: AppColors.primary,
        child: Center(
          child: Text(
            details.exception.toString(),
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  };

  LogStatus().getToken().then(
    (value) {
      if (value.isNotEmpty) {
        LogStatus.token = value;

        runApp(const FitWell(initialPage: Home()));
      } else {
        runApp(const FitWell(initialPage: Login()));
      }
    },
  );
}

class FitWell extends StatefulWidget {
  final Widget? initialPage;
  const FitWell({
    Key? key,
    @required this.initialPage,
  }) : super(key: key);

  @override
  State<FitWell> createState() => _FitWellState();
}

class _FitWellState extends State<FitWell> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
      debugShowCheckedModeBanner: false,
      title: 'FitWell',
      home: widget.initialPage,
    );
  }
}
