import 'dart:io';
import 'package:flutter/material.dart';
import 'package:homieeee/new_chat/presentation/home_chat_screen.dart';
import 'package:homieeee/screens/add_page.dart';
import 'package:homieeee/screens/explore_screen.dart';
import 'package:homieeee/screens/home_screen.dart';
import 'package:homieeee/screens/profile_screen.dart';
import 'package:homieeee/utils/constants/constants.dart';
import 'package:sizer/sizer.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  DateTime? currentBackPressTime;
  int selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FirebaseMarkersMap(),
    const AddProductPage(),
    const ChatsScreen(),
    const ProfilePage()
  ];

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: primaryColor,
        content: Text('Press back agin to exit', style: whiteRegular16),
        duration: const Duration(seconds: 1),
      ));
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            canvasColor: transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: transparent,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedIndex == 0 ? primaryColor : transparent,
                    child: SizedBox(
                        height: 2.5.h,
                        child: Icon(
                          Icons.home,
                          color: selectedIndex == 0 ? white : color8A,
                        )),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedIndex == 1 ? primaryColor : transparent,
                    child: SizedBox(
                      height: 2.5.h,
                      child: Icon(
                        Icons.travel_explore_rounded,
                        color: selectedIndex == 1 ? white : color8A,
                      ),
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedIndex == 2 ? primaryColor : transparent,
                    child: SizedBox(
                      height: 2.5.h,
                      child: Icon(
                        Icons.add_box_rounded,
                        color: selectedIndex == 2 ? white : color8A,
                      ),
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedIndex == 3 ? primaryColor : transparent,
                    child: SizedBox(
                      height: 2.5.h,
                      child: Icon(
                        Icons.message_rounded,
                        color: selectedIndex == 3 ? white : color8A,
                      ),
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        selectedIndex == 4 ? primaryColor : transparent,
                    child: SizedBox(
                      height: 2.5.h,
                      child: Icon(
                        Icons.supervised_user_circle,
                        color: selectedIndex == 4 ? white : color8A,
                      ),
                    ),
                  ),
                  label: ''),
            ],
            onTap: (int index) {
              setState(() => selectedIndex = index);
            },
            currentIndex: selectedIndex,
            selectedItemColor: primaryColor,
            unselectedItemColor: color8A,
            showUnselectedLabels: true,
            // selectedLabelStyle: primaryBold14,
            // unselectedLabelStyle: colorB7Bold14,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        body: _widgetOptions.elementAt(selectedIndex),
      ),
    );
  }
}
