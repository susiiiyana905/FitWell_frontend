import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fit_well/widget/navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fit_well/api/http/expense_http.dart';
import 'package:flutter/material.dart';

import '../../api/res/expense_res.dart';
import '../../resource/colors.dart';

class CategorizedExpense extends StatefulWidget {
  final String? category;
  const CategorizedExpense({Key? key, @required this.category})
      : super(key: key);

  @override
  State<CategorizedExpense> createState() => _CategorizedExpenseState();
}

class _CategorizedExpenseState extends State<CategorizedExpense> {
  String startDate = "", endDate = "", firstDate = "";

  late Future<List<ExpenseData>> expenseCategories;
  late List<ExpenseData> expenseList;
  int expenseAmount = 0;
  int expenseIndex = 0;

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.button,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  void getCategorizedExpenses() async {
    int tempExpenseAmount = 0;
    expenseCategories = ExpenseHttp().getCategorizedExpense(widget.category!);
    expenseCategories.then((value) {
      for (int i = 0; i < value.length; i++) {
        tempExpenseAmount = tempExpenseAmount + value[i].amount!;
      }
      setState(() {
        expenseList = value;
        expenseAmount = tempExpenseAmount;
      });
    });

    firstDate = await ExpenseHttp().getCategoryStartDate(widget.category!);
  }

  @override
  void initState() {
    super.initState();
    getCategorizedExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;
    final sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<List<ExpenseData>>(
            future: expenseCategories,
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
                    Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  child: Image(
                                    width: sWidth,
                                    height: sHeight * .3,
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "image/category/${widget.category}.jpg",
                                    ),
                                  ),
                                ),
                                Container(
                                  width: sWidth,
                                  height: sHeight * .3,
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: sWidth * 0.015,
                                vertical: 5,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      "${widget.category} (Rs. $expenseAmount)",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        IconButton(
                          padding: EdgeInsets.all(5.0),
                          constraints: BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_outlined,
                            color: AppColors.onPrimary,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    viewExpenses(context),
                    SizedBox(
                      height: 100,
                    ),
                  ];
                } else if (snapshot.hasError) {
                  children = <Widget>[
                    Container(
                      width: sWidth * 0.97,
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

              return Column(
                children: children,
              );
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 110,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (expenseIndex == 0) {
                  return;
                }

                List<ExpenseData> tempExpenseList =
                    await ExpenseHttp().getCategorizedExpense(widget.category!);
                int tempExpenseAmount = 0;
                for (int i = 0; i < tempExpenseList.length; i++) {
                  tempExpenseAmount =
                      tempExpenseAmount + tempExpenseList[i].amount!;
                }

                setState(() {
                  expenseList = tempExpenseList;
                  expenseAmount = tempExpenseAmount;
                  expenseIndex = 0;
                });
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: expenseIndex == 0
                      ? AppColors.primary
                      : AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.date_range_rounded,
                  color: expenseIndex == 0
                      ? AppColors.onPrimary
                      : AppColors.primary,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    expenseList = [];
                    expenseAmount = 0;
                    expenseIndex = 1;
                  });

                  showDialog(
                    context: context,
                    builder: (builder) => selectDate(context, firstDate),
                  );
                },
                backgroundColor:
                    expenseIndex == 1 ? AppColors.primary : AppColors.onPrimary,
                child: Icon(
                  Icons.search_rounded,
                  color: expenseIndex == 1
                      ? AppColors.onPrimary
                      : AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 0),
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
                      List<ExpenseData> tempExpenseList = await ExpenseHttp()
                          .getCategorizedSpecificExpense(
                              widget.category!, startDate, endDate);

                      int tempExpenseAmount = 0;
                      for (int i = 0; i < tempExpenseList.length; i++) {
                        tempExpenseAmount =
                            tempExpenseAmount + tempExpenseList[i].amount!;
                      }

                      setState(() {
                        expenseList = tempExpenseList;
                        expenseAmount = tempExpenseAmount;
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

  Widget viewExpenses(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return expenseList.isEmpty
        ? SizedBox(
            height: 200,
            child: Center(
              child: Text(
                "No expenses",
                style: TextStyle(
                  color: AppColors.iconHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              right: sWidth * 0.03,
              bottom: 10,
              left: sWidth * 0.03,
            ),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: expenseList.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onTap: () {},
                  contentPadding: EdgeInsets.zero,
                  minLeadingWidth: 5,
                  minVerticalPadding: 5,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  leading: Text(
                    (index + 1).toString() + ".",
                    style: TextStyle(
                      color: AppColors.iconHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(
                    expenseList[index].name!,
                    style: TextStyle(
                      color: AppColors.iconHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    expenseList[index].createdAt!.split("T")[0],
                    style: TextStyle(
                      color: AppColors.text,
                    ),
                  ),
                  trailing: Text(
                    "Rs. " + expenseList[index].amount!.toString(),
                    style: TextStyle(
                      color: AppColors.iconHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          );
  }
}
