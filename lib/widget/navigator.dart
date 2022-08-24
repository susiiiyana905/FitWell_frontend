import 'package:fit_well/resource/colors.dart';
import 'package:fit_well/screen/income/income.dart';
import 'package:fit_well/screen/progress/profile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../screen/home.dart';

class PageNavigator extends StatelessWidget {
  final int? pageIndex;
  const PageNavigator({Key? key, @required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.button,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.home_filled,
              color: AppColors.iconHeading,
              size: 25,
            ),
            selectedIcon: Icon(
              Icons.home_filled,
              color: AppColors.primary,
              size: 25,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              FontAwesomeIcons.personRunning,
              color: AppColors.iconHeading,
              size: 25,
            ),
            selectedIcon: Icon(
              FontAwesomeIcons.personRunning,
              color: AppColors.primary,
              size: 25,
            ),
            label: "Progress",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person,
              color: AppColors.iconHeading,
              size: 25,
            ),
            selectedIcon: Icon(
              Icons.person,
              color: AppColors.primary,
              size: 25,
            ),
            label: "Profile",
          ),
        ],
        height: 55,
        selectedIndex: pageIndex!,
        backgroundColor: AppColors.background,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => Home(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => Income(),
              ),
            );
          }  else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (builder) => Profile(),
              ),
            );
          }
        },
      ),
    );
  }
}
