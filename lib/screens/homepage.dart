// ignore_for_file: prefer_const_constructors

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:Medify/screens/rem_set_page.dart';
import 'package:sizer/sizer.dart';
import 'package:Medify/services/firebase_services.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:Medify/reusable_widgets/reusableWidgets.dart';
import 'package:Medify/screens/appointment.dart';
import 'package:flutter/services.dart';
import 'package:Medify/screens/pharmeasy.dart';
import 'package:Medify/screens/appollo.dart';
import 'package:Medify/screens/netmeds.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => backButtonPressed(context),
        child: Scaffold(
            //backgroundColor: bg,
            appBar: AppBar(
              backgroundColor: appBar,
              actions: [
                PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: IconButton(
                          onPressed: (){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>netmedsScreen())));
                          },
                          icon:Icon(
                            Icons.download,
                            color: kPrim,
                          )
                        )
                      ),
                      const PopupMenuItem<int>(
                        value: 1,
                        child: Text("Settings"),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: IconButton(
                            onPressed: () => Logout(context),
                            icon: Icon(
                              Icons.logout,
                              color: kPrim,
                            )),
                      ),
                    ];
                  },
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(2.h),
              child: Column(
                children: [
                  const TopContainer(),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Flexible(
                    child: BottomContainer(),
                  ),
                ],
              ),
            ),
            floatingActionButton: SizedBox(
              child: FabCircularMenu(
                // ignore: prefer_const_literals_to_create_immutables
                ringColor: ringColor,
                ringDiameter: 400.0,
                ringWidth: 100,

                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HistoryScreen())));
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: kPrim,
                        size: 30.00,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => docApp())));
                      },
                      icon: Icon(
                        Icons.event,
                        color: kPrim,
                        size: 30.00,
                      )),
                  IconButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>pharmeasyScreen())));
                      },
                      icon: Icon(
                        Icons.call,
                        color: kPrim,
                        size: 30.00,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>ApolloScreen())));
                      },
                      icon: Icon(
                        Icons.dark_mode_rounded,
                        color: kPrim,
                        size: 30.00,
                      )),
                ],
              ),
            )));
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'Set your next dosage.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(40.0),
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            '0',
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Medicine yet',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
