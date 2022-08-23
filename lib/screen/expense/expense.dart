import 'package:fitwell_frontend/api/http/expense_http.dart';
import 'package:fitwell_frontend/api/model/expense_income_model.dart';
import 'package:fitwell_frontend/api/res/expense_res.dart';
import 'package:fitwell_frontend/resource/category.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../../resource/colors.dart';
import '../../widget/navigator.dart';
import '../progress/result.dart';

class Expense extends StatefulWidget {
  const Expense({Key? key}) : super(key: key);

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String name = "", amount = "", category = "Other", firstDate = "";

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

  late Future<ExpenseDWM> userExpenseDetails;
  late List<ExpenseData> expenseList;
  late int expenseAmount;
  late List<ExpenseCategorized> expenseCategoryList;
  int expenseIndex = 0;
  int touchedIndex = 0;

  void getUserExpenseDetails() {
    userExpenseDetails = ExpenseHttp().getExpenseDWM();
    userExpenseDetails.then((value) {
      expenseList = value.todayExpenses!;
      expenseAmount = value.todayExpenseAmount!;
      expenseCategoryList = value.todayExpenseCategories!;
      firstDate = value.firstExpenseDate!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserExpenseDetails();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 10,
              right: sWidth * 0.03,
              left: sWidth * 0.03,
              bottom: 50,
            ),
            child: FutureBuilder<ExpenseDWM>(
              future: userExpenseDetails,
              builder: (context, snapshot) {
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
                                  snapshot.data!.profilePicture!,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Your Expenses",
                                style: TextStyle(
                                  color: AppColors.iconHeading,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                expenseList = [];
                                expenseAmount = 0;
                                expenseCategoryList = [];
                                expenseIndex = 3;
                                touchedIndex = 0;
                              });

                              showDialog(
                                context: context,
                                builder: (builder) =>
                                    selectDate(context, firstDate),
                              );
                            },
                            icon: Icon(
                              Icons.search_rounded,
                              color: AppColors.iconHeading,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      getButtons(context),
                      SizedBox(
                        height: 10,
                      ),
                      viewExpense(
                        context,
                        expenseList,
                        expenseAmount,
                        expenseCategoryList,
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
      floatingActionButton: SizedBox(
        height: 50,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return addExpense(context);
              },
            );
          },
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.add,
            color: AppColors.onPrimary,
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 2),
    );
  }

  void refreshPage(BuildContext context) {
    userExpenseDetails = ExpenseHttp().getExpenseDWM();
    if (expenseIndex == 0) {
      userExpenseDetails.then((value) {
        setState(() {
          expenseList = value.todayExpenses!;
          expenseAmount = value.todayExpenseAmount!;
          expenseCategoryList = value.todayExpenseCategories!;
        });
      });
    } else if (expenseIndex == 1) {
      userExpenseDetails.then((value) {
        setState(() {
          expenseList = value.thisWeekExpenses!;
          expenseAmount = value.thisWeekExpenseAmount!;
          expenseCategoryList = value.thisWeekExpenseCategories!;
        });
      });
    } else if (expenseIndex == 2) {
      userExpenseDetails.then((value) {
        setState(() {
          expenseList = value.thisMonthExpenses!;
          expenseAmount = value.thisWeekExpenseAmount!;
          expenseCategoryList = value.thisMonthExpenseCategories!;
        });
      });
    }
  }

  Widget addExpense(BuildContext context) {
    return StatefulBuilder(builder: (context, setState1) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        title: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: ((value) {
                  name = value!;
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.button,
                  hintStyle: TextStyle(
                    color: AppColors.text,
                  ),
                  hintText: "Enter name",
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                onSaved: ((value) {
                  amount = value!;
                }),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.button,
                  hintText: "Enter amount",
                  hintStyle: TextStyle(
                    color: AppColors.text,
                  ),
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.button,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton(
                  value: category,
                  elevation: 20,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontSize: 15,
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.button,
                  borderRadius: BorderRadius.circular(5),
                  onChanged: (String? newValue) {
                    setState1(() {
                      category = newValue!;
                    });
                  },
                  items: Category.expenseCategory.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(context);

                final resData = await ExpenseHttp().addExpense(
                  AddExpenseIncome(
                    name: name,
                    amount: amount,
                    category: category,
                  ),
                );

                name = "";
                amount = "";
                category = "Other";

                if (resData["statusCode"] == 201) {
                  refreshPage(context);

                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.green,
                    textColor: AppColors.onPrimary,
                    fontSize: 16.0,
                  );

                  if (resData["body"]["achievementUnlocked"]) {
                    showDialog(
                      context: _scaffoldKey.currentContext!,
                      builder: (builder) =>
                          congratulation(_scaffoldKey.currentContext!),
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: AppColors.onPrimary,
                    fontSize: 16.0,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Provide all information.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: AppColors.onPrimary,
                  fontSize: 16.0,
                );
              }
            },
            child: Text("Add"),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(10),
              side: BorderSide(
                color: AppColors.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              category = "Other";
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ],
      );
    });
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

  Widget getButtons(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: sWidth * .30,
          child: ElevatedButton(
            onPressed: () {
              if (expenseIndex == 0) {
                return;
              }

              userExpenseDetails.then((value) {
                setState(() {
                  expenseList = value.todayExpenses!;
                  expenseAmount = value.todayExpenseAmount!;
                  expenseCategoryList = value.todayExpenseCategories!;
                  expenseIndex = 0;
                  touchedIndex = 0;
                });
              });
            },
            child: Text(
              "Today",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: expenseIndex == 0 ? AppColors.primary : AppColors.button,
              onPrimary: expenseIndex == 0
                  ? AppColors.onPrimary
                  : AppColors.iconHeading,
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        SizedBox(
          width: sWidth * .30,
          child: ElevatedButton(
            onPressed: () {
              if (expenseIndex == 1) {
                return;
              }

              userExpenseDetails.then((value) {
                setState(() {
                  expenseList = value.thisWeekExpenses!;
                  expenseAmount = value.thisWeekExpenseAmount!;
                  expenseCategoryList = value.thisWeekExpenseCategories!;
                  expenseIndex = 1;
                  touchedIndex = 0;
                });
              });
            },
            child: Text(
              "This Week",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: expenseIndex == 1 ? AppColors.primary : AppColors.button,
              onPrimary: expenseIndex == 1
                  ? AppColors.onPrimary
                  : AppColors.iconHeading,
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        SizedBox(
          width: sWidth * .30,
          child: ElevatedButton(
            onPressed: () {
              if (expenseIndex == 2) {
                return;
              }

              userExpenseDetails.then((value) {
                setState(() {
                  expenseList = value.thisMonthExpenses!;
                  expenseAmount = value.thisMonthExpenseAmount!;
                  expenseCategoryList = value.thisMonthExpenseCategories!;
                  expenseIndex = 2;
                  touchedIndex = 0;
                });
              });
            },
            child: Text(
              "This Month",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: expenseIndex == 2 ? AppColors.primary : AppColors.button,
              onPrimary: expenseIndex == 2
                  ? AppColors.onPrimary
                  : AppColors.iconHeading,
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(
                vertical: 10,
              ),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget selectDate(BuildContext context, String firstDate) {
    String startDate = "", endDate = "";

    return StatefulBuilder(builder: (context, setState1) {
      return SimpleDialog(
        backgroundColor: AppColors.background,
        children: [
          SimpleDialogOption(
            padding: EdgeInsets.only(
              top: 5,
              left: 15,
              right: 15,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    DateTimeField(
                      onChanged: (value) {
                        setState1(() {
                          startDate = value.toString().split(" ")[0];
                        });
                      },
                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(
                            int.parse(firstDate.split("-")[0]),
                            int.parse(firstDate.split("-")[1]),
                            int.parse(firstDate.split("-")[2]),
                          ),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now(),
                        );
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.button,
                        hintText: "Start Date",
                        hintStyle: TextStyle(
                          color: AppColors.text,
                        ),
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    startDate == "" || startDate == "null"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              FontAwesomeIcons.calendarDays,
                              color: AppColors.primary,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    DateTimeField(
                      onChanged: (value) {
                        setState1(() {
                          endDate = value.toString().split(" ")[0];
                        });
                      },
                      format: DateFormat("yyyy-MM-dd"),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                          context: context,
                          firstDate: DateTime(
                            int.parse(firstDate.split("-")[0]),
                            int.parse(firstDate.split("-")[1]),
                            int.parse(firstDate.split("-")[2]),
                          ),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime.now(),
                        );
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.button,
                        hintText: "End Date",
                        hintStyle: TextStyle(
                          color: AppColors.text,
                        ),
                        enabledBorder: formBorder,
                        focusedBorder: formBorder,
                        errorBorder: formBorder,
                        focusedErrorBorder: formBorder,
                      ),
                    ),
                    endDate == "" || endDate == "null"
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              FontAwesomeIcons.calendarDays,
                              color: AppColors.primary,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (startDate == "" ||
                        startDate == "null" ||
                        endDate == "" ||
                        endDate == "null") {
                      Fluttertoast.showToast(
                        msg: "Both start and end date is required.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: AppColors.onPrimary,
                        fontSize: 16.0,
                      );
                    } else {
                      ExpenseSpecific resData = await ExpenseHttp()
                          .getExpenseSpecific(startDate, endDate);

                      setState(() {
                        expenseList = resData.expenses!;
                        expenseAmount = resData.expenseAmount!;
                        expenseCategoryList = resData.expenseCategories!;
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Search",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    onPrimary: AppColors.onPrimary,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.all(10),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget viewExpense(
    BuildContext context,
    List<ExpenseData> expenses,
    int amount,
    List<ExpenseCategorized> category,
  ) {
    final sWidth = MediaQuery.of(context).size.width;

    if (expenses.isNotEmpty) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
              children: [
                Text(
                  "Expense Categories",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.iconHeading,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: sWidth * .5,
            height: sWidth * .5,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }

                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: category
                    .asMap()
                    .map((index, data) {
                      final isTouched = index == touchedIndex;
                      final double fontSize = isTouched ? 20 : 15;
                      final double radius =
                          isTouched ? sWidth * .18 : sWidth * .16;

                      final pieData = PieChartSectionData(
                        value: double.parse(
                            ((data.amount! / amount) * 100).toStringAsFixed(1)),
                        title:
                            "${((data.amount! / amount) * 100).toStringAsFixed(1)}%",
                        color: ExpenseCategoryColors.colorList[
                            Category.expenseCategory.indexOf(data.category!)],
                        radius: radius,
                        titleStyle: TextStyle(
                          color: AppColors.onPrimary,
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      );

                      return MapEntry(index, pieData);
                    })
                    .values
                    .toList(),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: category.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: ExpenseCategoryColors.colorList[Category
                          .expenseCategory
                          .indexOf(category[index].category!)],
                      radius: 6,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: category[index].category!,
                        style: TextStyle(
                          color: AppColors.iconHeading,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  text: "= ",
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  children: [
                    TextSpan(
                      text: "Rs.${amount.toString()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                "Expense Items",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: expenses.length,
            itemBuilder: ((context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 5,
                minVerticalPadding: 5,
                visualDensity: VisualDensity(horizontal: -2, vertical: -4),
                onTap: () {
                  if (expenseIndex > 1) {
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (builder) {
                      return operationExpense(
                        context,
                        ExpenseData(
                          id: expenses[index].id,
                          name: expenses[index].name,
                          amount: expenses[index].amount,
                          category: expenses[index].category,
                        ),
                      );
                    },
                  );
                },
                leading: Text(
                  (index + 1).toString() + ".",
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                title: Text(
                  expenses[index].name!,
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  expenses[index].category!,
                  style: TextStyle(
                    color: AppColors.text,
                  ),
                ),
                trailing: Text(
                  "Rs. " + expenses[index].amount!.toString(),
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ),
        ],
      );
    } else if (expenseIndex != 3) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No expenses",
              style: TextStyle(
                color: AppColors.iconHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                minimumSize: Size.zero,
                padding: EdgeInsets.all(10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) {
                    return addExpense(context);
                  },
                );
              },
              child: Text("Add Expense"),
            ),
          ],
        ),
      );
    } else if (expenseIndex == 3) {
      return SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No expenses",
              style: TextStyle(
                color: AppColors.iconHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget operationExpense(BuildContext context, ExpenseData expenseData) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: MediaQuery.of(context).size.width * .20,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
        ),
      ),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: AppColors.primary,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (builder) {
                  return editExpense(
                    context,
                    expenseData,
                  );
                },
              );
            },
            child: SizedBox(
              height: 45,
              width: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              minimumSize: Size.zero,
              padding: EdgeInsets.all(0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);
              final resData =
                  await ExpenseHttp().removeExpense(expenseData.id!);
              refreshPage(context);
              Fluttertoast.showToast(
                msg: resData["resM"],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 3,
                backgroundColor: AppColors.primary,
                textColor: AppColors.onPrimary,
                fontSize: 16.0,
              );
            },
            child: SizedBox(
              height: 45,
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.delete),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Remove",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editExpense(BuildContext context, ExpenseData expenseData) {
    TextEditingController nameTEC = TextEditingController(),
        amountTEC = TextEditingController();
    nameTEC.text = expenseData.name!;
    amountTEC.text = expenseData.amount!.toString();
    String categoryTEC = expenseData.category!;

    return StatefulBuilder(builder: (context, setState1) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        title: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameTEC,
                onSaved: ((value) {
                  nameTEC.text = value!;
                }),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.button,
                  hintText: "Enter name",
                  hintStyle: TextStyle(
                    color: AppColors.iconHeading,
                  ),
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: amountTEC,
                onSaved: ((value) {
                  amountTEC.text = value!;
                }),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.button,
                  hintText: "Enter amount",
                  hintStyle: TextStyle(
                    color: AppColors.iconHeading,
                  ),
                  enabledBorder: formBorder,
                  focusedBorder: formBorder,
                  errorBorder: formBorder,
                  focusedErrorBorder: formBorder,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.button,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: DropdownButton(
                  value: categoryTEC,
                  elevation: 20,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: AppColors.iconHeading,
                    fontSize: 15,
                  ),
                  isExpanded: true,
                  dropdownColor: AppColors.button,
                  borderRadius: BorderRadius.circular(5),
                  onChanged: (String? newValue) {
                    setState1(() {
                      categoryTEC = newValue!;
                    });
                  },
                  items: Category.expenseCategory.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final resData = await ExpenseHttp().editExpense(
                  ExpenseData(
                    id: expenseData.id,
                    name: nameTEC.text,
                    amount: int.parse(amountTEC.text),
                    category: categoryTEC,
                  ),
                );

                if (resData["statusCode"] == 200) {
                  refreshPage(context);

                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.green,
                    textColor: AppColors.onPrimary,
                    fontSize: 16.0,
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: resData["body"]["resM"],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.red,
                    textColor: AppColors.onPrimary,
                    fontSize: 16.0,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Provide all information.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: AppColors.onPrimary,
                  fontSize: 16.0,
                );
              }
            },
            child: Text("Edit"),
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
            },
            child: Text("Cancel"),
          ),
        ],
      );
    });
  }
}
