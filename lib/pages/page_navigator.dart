import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hptracker/constants/colors.dart';
import 'package:hptracker/pages/home_screen.dart';
import 'package:hptracker/pages/med_history.dart';
import 'package:hptracker/pages/add_medicine_screen.dart';

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  List<Widget> pages = const [
    Homescreen(),
    AddMedicineScreen(),
    MedHistory(),
  ];
  int index = 0;
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExistWarning = difference >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExistWarning) {
          Fluttertoast.showToast(msg: "Press again to exit");
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedIconTheme: const IconThemeData(
            color: Colors.black,
          ),
          unselectedIconTheme: const IconThemeData(color: Colors.black, ),
          elevation: 5,
          backgroundColor:  Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 0,
          unselectedFontSize: 12,
          showSelectedLabels: false,
          showUnselectedLabels: true,
          iconSize: width * 0.09,
          onTap: (val) {
            setState(() {
              index = val;
            });
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: width * 0.023),
                child: Column( 
                  children: [
                    const Icon(
                      Icons.home,
                    ),
                    const Text("Home"),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Divider(
                        thickness: 3,
                        color: index == 0 ?  primary : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: width * 0.023),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.add,
                      ),
                      const Text("Add Medicine"),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                        child: Divider(
                        thickness: 3,
                        color: index == 1 ? primary : Colors.white,
                                      ),
                      ) ,
                    ],
                  ),
                ),
                label: "Add Medicine"),
            BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(top: width * 0.023),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.question_answer_rounded,
                      ),
                      const Text("Medical History"),
                       Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                        child: Divider(
                        thickness: 3,
                        color: index == 2 ? primary  : Colors.white,
                
                                      ),
                      ),
                    ],
                  ),
                ),
                label: "Medical History"),
          ],
        ),
      ),
    );
  }
}
