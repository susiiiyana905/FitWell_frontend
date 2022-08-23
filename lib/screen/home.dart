import 'package:fitwell_frontend/api/http/home_http.dart';
import 'package:fitwell_frontend/api/http/progress_http.dart';
import 'package:fitwell_frontend/api/http/user_http.dart';
import 'package:fitwell_frontend/api/res/expense_res.dart';
import 'package:fitwell_frontend/api/res/home_res.dart';
import 'package:fitwell_frontend/resource/category.dart';
import 'package:fitwell_frontend/screen/expense/categorized_expense.dart';
import 'package:fitwell_frontend/screen/income/categorized_income.dart';
import 'package:fitwell_frontend/screen/progress/result.dart';
import 'package:fitwell_frontend/screen/setting/change_password.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../api/res/income_res.dart';
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
  String greeting = "Expense Tracker";

  late Future<HomeData> userHomeData;
  bool moreExpense = false;
  bool moreIncome = false;
  List<String> expenseCategories = [];
  List<String> incomeCategories = [];

  int touchedGroupIndex = -1;

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

  void getUserHomeData() async {
    userHomeData = HomeHttp().viewHome();

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

    userHomeData.then((value) {
      List<ExpenseCategorized> e = value.thisMonthExpenseCategories!;
      List<IncomeCategorized> i = value.thisMonthIncomeCategories!;

      if (e.isEmpty) {
        expenseCategories = Category.expenseCategory;
      } else {
        expenseCategories = e
            .asMap()
            .map((key, value) {
              return MapEntry(key, e[key].category!);
            })
            .values
            .toList();
      }

      if (i.isEmpty) {
        incomeCategories = Category.incomeCategory;
      } else {
        incomeCategories = i
            .asMap()
            .map((key, value) {
              return MapEntry(key, i[key].category!);
            })
            .values
            .toList();
      }
    });

    final pc = await ProgressHttp().calculateProgress();
    if (pc["achievementUnlocked"]) {
      showDialog(
        context: context,
        builder: (builder) => congratulation(context),
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

    getUserHomeData();
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
                    barChart(
                      context,
                      snapshot.data!.thisMonthView!,
                      snapshot.data!.thisMonthExpenseAmount!,
                      snapshot.data!.thisMonthIncomeAmount!,
                      snapshot.data!.previousMonthExpenseAmount!,
                      snapshot.data!.previousMonthIncomeAmount!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    feedback(context, snapshot.data!),
                    SizedBox(
                      height: 5,
                    ),
                    incomeDetail(
                      context,
                      snapshot.data!.thisMonthIncomeCategories!,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    expenseDetail(
                      context,
                      snapshot.data!.thisMonthExpenseCategories!,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    snapshot.data!.expenseDays!.length > 2
                        ? expenseLineChart(
                            context,
                            snapshot.data!.thisMonthView!,
                            snapshot.data!.expenseDays!,
                            snapshot.data!.expenseAmounts!,
                            snapshot.data!.maxExpenseAmount!,
                          )
                        : SizedBox(),
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

  Widget congratulation(BuildContext context) {
    return SimpleDialog(
      backgroundColor: AppColors.background,
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(10),
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  "image/Congratulation.png",
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "New Achievement Unlocked.",
              style: TextStyle(
                color: AppColors.iconHeading,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                minimumSize: Size.zero,
                padding: EdgeInsets.all(8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => Result(),
                  ),
                );
              },
              child: Text("Check Out"),
            ),
          ],
        ),
      ],
    );
  }

  Widget barChart(
    BuildContext context,
    bool thisMonthView,
    int thisMonthExpenseAmount,
    int thisMonthIncomeAmount,
    int previousMonthExpenseAmount,
    int previousMonthIncomeAmount,
  ) {
    if (thisMonthExpenseAmount == 0 &&
        thisMonthIncomeAmount == 0 &&
        previousMonthExpenseAmount == 0 &&
        previousMonthIncomeAmount == 0) {
      return SizedBox();
    }

    final sWidth = MediaQuery.of(context).size.width;
    const Color leftBarColor = Colors.orange;
    Color rightBarColor = AppColors.primary;
    double width = sWidth * .16;
    const BorderRadius borderRadius = BorderRadius.only(
      topLeft: Radius.circular(5),
      topRight: Radius.circular(5),
      bottomLeft: Radius.circular(0),
      bottomRight: Radius.circular(0),
    );

    List<int> amounts = [
      thisMonthExpenseAmount,
      thisMonthIncomeAmount,
      previousMonthExpenseAmount,
      previousMonthIncomeAmount
    ];
    amounts.sort();
    int maxAmount = amounts.last + amounts.last ~/ 10;

    List<BarChartGroupData> showingBarGroups = [];
    List<BarChartRodData> thisMonthBarRods = [];
    List<BarChartRodData> previousMonthBarRods = [];

    if (thisMonthIncomeAmount != 0) {
      thisMonthBarRods.add(BarChartRodData(
        borderRadius: borderRadius,
        toY: (thisMonthIncomeAmount / maxAmount) * 5,
        color: rightBarColor,
        width: width,
      ));
    }
    if (thisMonthExpenseAmount != 0) {
      thisMonthBarRods.add(BarChartRodData(
        borderRadius: borderRadius,
        toY: (thisMonthExpenseAmount / maxAmount) * 5,
        color: leftBarColor,
        width: width,
      ));
    }
    if (previousMonthIncomeAmount != 0) {
      previousMonthBarRods.add(BarChartRodData(
        borderRadius: borderRadius,
        toY: (previousMonthIncomeAmount / maxAmount) * 5,
        color: rightBarColor,
        width: width,
      ));
    }
    if (previousMonthExpenseAmount != 0) {
      previousMonthBarRods.add(BarChartRodData(
        borderRadius: borderRadius,
        toY: (previousMonthExpenseAmount / maxAmount) * 5,
        color: leftBarColor,
        width: width,
      ));
    }
    if (thisMonthBarRods.isNotEmpty) {
      showingBarGroups.add(BarChartGroupData(
        barsSpace: 5,
        x: 0,
        barRods: thisMonthBarRods,
      ));
    }
    if (previousMonthBarRods.isNotEmpty) {
      showingBarGroups.add(BarChartGroupData(
        barsSpace: 5,
        x: 1,
        barRods: previousMonthBarRods,
      ));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Income",
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange,
                      radius: 5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "Expense",
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 200,
          width: sWidth * .94,
          child: BarChart(
            BarChartData(
              maxY: 5,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: AppColors.primary,
                  tooltipMargin: 25,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      "Rs." + (((rod.toY / 5) * maxAmount).round()).toString(),
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                touchCallback: (FlTouchEvent event, barTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        barTouchResponse == null ||
                        barTouchResponse.spot == null) {
                      touchedGroupIndex = -1;
                      return;
                    }
                    touchedGroupIndex =
                        barTouchResponse.spot!.touchedBarGroupIndex;
                  });
                },
              ),
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      List<String> titles = ["This Month", "Last Month"];

                      Widget text = Text(
                        titles[value.toInt()],
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      );

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 5, //margin top
                        child: text,
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: maxAmount > 100000
                        ? 40
                        : maxAmount > 10000
                            ? 35
                            : 25,
                    interval: 1,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      TextStyle style = TextStyle(
                        color: AppColors.iconHeading,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      );
                      String text;

                      String amount1 = (maxAmount / 5000) > 0.1
                          ? (maxAmount / 5000).toStringAsFixed(1) + "k"
                          : (maxAmount / 5000).toStringAsFixed(2) + "k";
                      String amount2 = ((maxAmount / 5000) * 2) > 0.1
                          ? ((maxAmount / 5000) * 2).toStringAsFixed(1) + "k"
                          : ((maxAmount / 5000) * 2).toStringAsFixed(2) + "k";
                      String amount3 = ((maxAmount / 5000) * 3) > 0.1
                          ? ((maxAmount / 5000) * 3).toStringAsFixed(1) + "k"
                          : ((maxAmount / 5000) * 3).toStringAsFixed(2) + "k";
                      String amount4 = ((maxAmount / 5000) * 4) > 0.1
                          ? ((maxAmount / 5000) * 4).toStringAsFixed(1) + "k"
                          : ((maxAmount / 5000) * 4).toStringAsFixed(2) + "k";
                      String amount5 = (maxAmount / 1000) > 0.1
                          ? (maxAmount / 1000).toStringAsFixed(1) + "k"
                          : (maxAmount / 1000).toStringAsFixed(2) + "k";

                      if (value.toInt() == 1) {
                        text = amount1;
                      } else if (value.toInt() == 2) {
                        text = amount2;
                      } else if (value.toInt() == 3) {
                        text = amount3;
                      } else if (value.toInt() == 4) {
                        text = amount4;
                      } else if (value.toInt() == 5) {
                        text = amount5;
                      } else {
                        text = "";
                      }

                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 5,
                        child: Text(text, style: style),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.iconHeading,
                    width: 2,
                  ),
                  left: BorderSide(
                    color: AppColors.iconHeading,
                    width: 2,
                  ),
                  right: BorderSide(color: Colors.transparent),
                  top: BorderSide(color: Colors.transparent),
                ),
              ),
              barGroups: showingBarGroups,
            ),
          ),
        ),
      ],
    );
  }

  Widget feedback(BuildContext context, HomeData homeData) {
    final sWidth = MediaQuery.of(context).size.width;

    if (homeData.thisMonthExpenseAmount! == 0 &&
        homeData.thisMonthIncomeAmount! == 0) {
      return SizedBox();
    }

    bool isPadding = false;
    if (homeData.thisMonthExpenseAmount! > homeData.thisMonthIncomeAmount! &&
        homeData.thisMonthIncomeAmount != 0) {
      isPadding = true;
    }
    if (homeData.previousMonthExpenseAmount! != 0 &&
        homeData.thisMonthExpenseAmount! >
            homeData.previousMonthExpenseAmount!) {
      isPadding = true;
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        right: sWidth * 0.03,
        left: sWidth * 0.03,
      ),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          homeData.thisMonthExpenseAmount! > homeData.thisMonthIncomeAmount! &&
                  homeData.thisMonthIncomeAmount != 0
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Container(
                    width: sWidth * .94,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: sWidth * .14,
                          child: Icon(
                            FontAwesomeIcons.faceSadTear,
                            color: Colors.deepOrange,
                            size: 40,
                          ),
                        ),
                        SizedBox(
                          width: sWidth * .8 - 20,
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text:
                                  "This month expenses looks bad. Save money.",
                              style: TextStyle(
                                color: AppColors.iconHeading,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : homeData.previousMonthExpenseAmount! != 0 &&
                      homeData.thisMonthExpenseAmount! >
                          homeData.previousMonthExpenseAmount!
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Container(
                        width: sWidth * .94,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.onPrimary,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: sWidth * .14,
                              child: Icon(
                                FontAwesomeIcons.faceSurprise,
                                color: Colors.orange,
                                size: 40,
                              ),
                            ),
                            SizedBox(
                              width: sWidth * .8 - 20,
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  text:
                                      "Last month expense was less than this month.",
                                  style: TextStyle(
                                    color: AppColors.iconHeading,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox(),
          homeData.thisMonthExpenseAmount! < homeData.thisMonthIncomeAmount! &&
                  homeData.thisMonthExpenseAmount != 0
              ? Padding(
                  padding: EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    left: isPadding ? 20 : 0,
                  ),
                  child: Container(
                    width: sWidth * .94,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: sWidth * .14,
                          child: Icon(
                            FontAwesomeIcons.faceSmileBeam,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                        SizedBox(
                          width: sWidth * .8 - 20,
                          child: RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              text:
                                  "This month expenses looks good. Keep it up.",
                              style: TextStyle(
                                color: AppColors.iconHeading,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  Widget incomeDetail(BuildContext context, List<IncomeCategorized> category) {
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
                "Income Categories",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              category.isNotEmpty
                  ? TextButton.icon(
                      onPressed: () {
                        if (moreIncome) {
                          List<String> tempCategory = category
                              .asMap()
                              .map((key, value) {
                                return MapEntry(key, category[key].category!);
                              })
                              .values
                              .toList();

                          setState(() {
                            incomeCategories = tempCategory;
                            moreIncome = !moreIncome;
                          });
                        } else {
                          List<String> tempCategory = incomeCategories;
                          for (int i = 0;
                              i < Category.incomeCategory.length;
                              i++) {
                            if (!tempCategory
                                .contains(Category.incomeCategory[i])) {
                              tempCategory.add(Category.incomeCategory[i]);
                            }
                          }
                          setState(() {
                            incomeCategories = tempCategory;
                            moreIncome = !moreIncome;
                          });
                        }
                      },
                      icon: AnimatedRotation(
                        turns: moreIncome ? (90 / 360) : (270 / 360),
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.iconHeading,
                          size: 18,
                        ),
                      ),
                      label: Text(
                        moreIncome ? "Less" : "More",
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sWidth * .58),
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: List.generate(
              incomeCategories.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CategorizedIncome(
                          category: incomeCategories[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: sWidth * 0.2,
                            width: sWidth * 0.2,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "image/category/${incomeCategories[index]}.jpg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        incomeCategories[index],
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

  Widget expenseDetail(
      BuildContext context, List<ExpenseCategorized> category) {
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
                "Expense Categories",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              category.isNotEmpty
                  ? TextButton.icon(
                      onPressed: () {
                        if (moreExpense) {
                          List<String> tempCategory = category
                              .asMap()
                              .map((key, value) {
                                return MapEntry(key, category[key].category!);
                              })
                              .values
                              .toList();

                          setState(() {
                            expenseCategories = tempCategory;
                            moreExpense = !moreExpense;
                          });
                        } else {
                          List<String> tempCategory = expenseCategories;
                          for (int i = 0;
                              i < Category.expenseCategory.length;
                              i++) {
                            if (!tempCategory
                                .contains(Category.expenseCategory[i])) {
                              tempCategory.add(Category.expenseCategory[i]);
                            }
                          }
                          setState(() {
                            expenseCategories = tempCategory;
                            moreExpense = !moreExpense;
                          });
                        }
                      },
                      icon: AnimatedRotation(
                        turns: moreExpense ? (90 / 360) : (270 / 360),
                        duration: Duration(milliseconds: 500),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.iconHeading,
                          size: 18,
                        ),
                      ),
                      label: Text(
                        moreExpense ? "Less" : "More",
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: (sWidth - (sWidth * .53)) / (sWidth * .58),
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 4,
            children: List.generate(
              expenseCategories.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => CategorizedExpense(
                          category: expenseCategories[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: sWidth * 0.2,
                            width: sWidth * 0.2,
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "image/category/${expenseCategories[index]}.jpg",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        expenseCategories[index],
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  Widget expenseLineChart(BuildContext context, bool thisMonthView,
      List<int> expenseDays, List<int> expenseAmounts, int maxExpenseAmount) {
    final sWidth = MediaQuery.of(context).size.width;
    List<FlSpot> expenseLineData = [];
    List<int> tempExpenseDays = [];

    for (int i = 1; i < expenseDays.length + 1; i++) {
      tempExpenseDays.add(i);
    }

    int maxAmount = maxExpenseAmount + maxExpenseAmount ~/ 5;

    for (int i = 0; i < expenseDays.length; i++) {
      expenseLineData.add(FlSpot(
          tempExpenseDays[i].toDouble(), (expenseAmounts[i] / maxAmount) * 5));
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: sWidth * 0.03,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                thisMonthView
                    ? "This" " Month Expenses"
                    : "Last" " Month Expenses",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 200,
            width: sWidth * .98,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: AppColors.primary,
                      tooltipMargin: 50,
                      tooltipRoundedRadius: 5,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          if (flSpot.x == 0 || flSpot.x == 6) {
                            return null;
                          }

                          return LineTooltipItem(
                            "Rs. ${((flSpot.y / 5) * maxAmount).round()}",
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      }),
                ),
                gridData: FlGridData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: maxAmount > 100000
                          ? 40
                          : maxAmount > 10000
                              ? 35
                              : 28,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        TextStyle style = TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        );
                        String text = "";
                        String amount1 = (maxAmount / 5000) > 0.1
                            ? (maxAmount / 5000).toStringAsFixed(1) + "k"
                            : (maxAmount / 5000).toStringAsFixed(2) + "k";
                        String amount2 = ((maxAmount / 5000) * 2) > 0.1
                            ? ((maxAmount / 5000) * 2).toStringAsFixed(1) + "k"
                            : ((maxAmount / 5000) * 2).toStringAsFixed(2) + "k";
                        String amount3 = ((maxAmount / 5000) * 3) > 0.1
                            ? ((maxAmount / 5000) * 3).toStringAsFixed(1) + "k"
                            : ((maxAmount / 5000) * 3).toStringAsFixed(2) + "k";
                        String amount4 = ((maxAmount / 5000) * 4) > 0.1
                            ? ((maxAmount / 5000) * 4).toStringAsFixed(1) + "k"
                            : ((maxAmount / 5000) * 4).toStringAsFixed(2) + "k";
                        String amount5 = (maxAmount / 1000) > 0.1
                            ? (maxAmount / 1000).toStringAsFixed(1) + "k"
                            : (maxAmount / 1000).toStringAsFixed(2) + "k";

                        if (value.toInt() == 1) {
                          text = amount1;
                        } else if (value.toInt() == 2) {
                          text = amount2;
                        } else if (value.toInt() == 3) {
                          text = amount3;
                        } else if (value.toInt() == 4) {
                          text = amount4;
                        } else if (value.toInt() == 5) {
                          text = amount5;
                        }

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 5,
                          child: Text(
                            text,
                            style: style,
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: Text(
                      "Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      interval: 1,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        TextStyle style = TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: expenseDays.length > 12
                              ? expenseDays.length > 20
                                  ? 7
                                  : 9
                              : 10,
                        );
                        Widget text = Text("");

                        for (int i = 1; i < expenseDays.length + 1; i++) {
                          if (value.toInt() == i) {
                            text = Text(expenseDays[i - 1].toString(),
                                style: style);
                          }
                        }

                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 5,
                          child: text,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.iconHeading,
                      width: 2,
                    ),
                    left: BorderSide(
                      color: AppColors.iconHeading,
                      width: 2,
                    ),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFF8B44F),
                    ),
                    spots: expenseLineData,
                  ),
                ],
                minX: 0,
                maxX: expenseDays.length + 1,
                maxY: 5,
                minY: 0,
              ),
              swapAnimationDuration: const Duration(milliseconds: 250),
            ),
          ),
        ],
      ),
    );
  }
}