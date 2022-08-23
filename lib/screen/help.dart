import 'package:flutter/material.dart';

import '../resource/colors.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  bool dataInsertion = false;
  bool dataVisualization = false;
  bool progressAndAchievement = false;
  bool dataPrivacy = false;

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: TextStyle(
            color: AppColors.iconHeading,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.iconHeading,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 40,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: sWidth * .03,
          right: sWidth * .03,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  dataInsertion = !dataInsertion;
                });
              },
              child: Container(
                height: 40,
                color: AppColors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data Insertion",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.iconHeading,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "How to insert income and expense data?",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AnimatedRotation(
                      turns: dataInsertion ? (90 / 360) : (270 / 360),
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.iconHeading,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dataInsertion
                ? Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "1. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can add incomes and expenses daily.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image(
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/help/Add Income.png",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "2. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Name, amount and category should be given while adding an income or expense data.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image(
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/help/Add Expense.png",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "3. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "There is no any limitation on how much incomes and expenses can be added daily.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  dataVisualization = !dataVisualization;
                });
              },
              child: Container(
                height: 40,
                color: AppColors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data Visualization",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.iconHeading,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "How data can be viewed with dates?",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AnimatedRotation(
                      turns: dataVisualization ? (90 / 360) : (270 / 360),
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.iconHeading,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dataVisualization
                ? Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "1. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can visualize their daily, weekly, and monthly incomes and expenses detail.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image(
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/help/Incomes.png",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "2. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can even search their expenses and incomes by giving start and end dates.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Search Expense.png",
                            ),
                          ),
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Searched Expense.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "3. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can view last and current month incomes and expense details with a bar chart in the home page with feedback message.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/BarChart.png",
                            ),
                          ),
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Category.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "4. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can view their income and expense categories of the current month from high to low amount in the home page.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Income Category.png",
                            ),
                          ),
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Expense Category.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "5. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can also view the graph of the total expense amount of those days that they have inserted expenses in a month.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  progressAndAchievement = !progressAndAchievement;
                });
              },
              child: Container(
                height: 40,
                color: AppColors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Progress Point and Achievement",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.iconHeading,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "What is progress point and achievement?",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AnimatedRotation(
                      turns: progressAndAchievement ? (90 / 360) : (270 / 360),
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.iconHeading,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            progressAndAchievement
                ? Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "1. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users will get 15 progress points on adding an income and 10 progress point on adding an expense.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "2. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can also unlock achievements and get even more progress points.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Expense Page Congratulation.png",
                            ),
                          ),
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Home Page Congratulation.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "3. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can view their progress and achievements in the progress page.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image(
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/help/Progress Page.png",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "4. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Achievements are base on expenses and incomes. Their detail are provided on the achievement page. ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Achievement Page.png",
                            ),
                          ),
                          Image(
                            width: sWidth * 0.4,
                            fit: BoxFit.fitWidth,
                            image: AssetImage(
                              "image/help/Achievement Detail.png",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "5. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users will have two kind of achievements. One is last month achievements which includes achievements got from the last month expenses and incomes and another is this month achievements which contains achievement got on the current month.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "6. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "Users can also share their progress point and compete in the raking system.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image(
                        width: sWidth * 0.4,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          "image/help/Ranking Page.png",
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  dataPrivacy = !dataPrivacy;
                });
              },
              child: Container(
                height: 40,
                color: AppColors.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data Privacy",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.iconHeading,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "How users' data are protected?",
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    AnimatedRotation(
                      turns: dataPrivacy ? (90 / 360) : (270 / 360),
                      duration: Duration(milliseconds: 500),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.iconHeading,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dataPrivacy
                ? Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "1. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "The expenses and incomes data of a user can be seen by the user only.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "2. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "The users' data have not been shared with any other users and not used for any other purposes.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "3. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "The rank page shows only those users' data who have shared their progress and achievements.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: sWidth * .04,
                            child: Text(
                              "4. ",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: sWidth * .90,
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                text:
                                    "No one has been harmed intentionally by the use of this application.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
