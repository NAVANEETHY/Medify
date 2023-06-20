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
import 'package:Medify/global_bloc.dart';
import 'package:Medify/utils/medicine.dart';
import 'package:Medify/screens/medicine_details/medicine_details.dart';
import 'package:Medify/screens/nav_bar.dart';
import 'package:Medify/screens/remsetscreen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => backButtonPressed(context),
    child:Scaffold(
        //backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: appBar,
          actions: [
            PopupMenuButton(
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
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
        drawer: NavBar(),
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
                            builder: ((context) => RemSetScreen())));
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: kPrim,
                    size: 30.00,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => docApp())));
                  },
                  icon: Icon(
                    Icons.event,
                    color: kPrim,
                    size: 30.00,
                  )),
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.call,
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
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            top: 1.h,
          ),
          child: Text(
            'Welcome  To  Medify',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: kText, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'Set your next dosage',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: Colors.grey.shade700),
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        StreamBuilder<List<Medicine>>(
            stream: globalBloc.medicineList$,
            builder: ((context, snapshot) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.only(
                  bottom: 1.h,
                ),
                child: Text(
                  !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: kSec),
                ),
              );
            })),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    /*  return Center(
      child: Text(
        'No Medicine yet',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall,
      ),*/
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'NO MEDICINE',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: kSec),
              ),
            );
          } else {
            return GridView.builder(
              padding: EdgeInsets.only(top: 1.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MedicineCard(medicine: snapshot.data![index]);
              },
            );
          }
        });
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;

  Hero makeIcon(double size) {
    if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/images/pill.svg',
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Bottle') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/images/bottle.svg',
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Injection') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/images/injection.svg',
          height: 7.h,
        ),
      );
    }
    return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: Icon(
          Icons.error,
          color: kOther,
          size: size,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      splashColor: Colors.grey,
      onTap: () {
        //go to details activity
        /*  Navigator.push(context,
            MaterialPageRoute(builder: (context) => MedicineDetails())); */
        Navigator.of(context).push(
          PageRouteBuilder<void>(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, Widget? child) {
                  return Opacity(
                    opacity: animation.value,
                    child: MedicineDetails(medicine: medicine),
                  );
                },
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 2.w,
          right: 2.w,
          top: 1.h,
          bottom: 1.h,
        ),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            makeIcon(7.h),
            const Spacer(),
            Hero(
              tag: medicine.medicineName!,
              child: Text(
                medicine.medicineName!,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
              ),
            ),
            Text(
              medicine.interval == 1
                  ? 'Every ${medicine.interval} hour'
                  : 'Every ${medicine.interval} hour',
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: kPrim,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}


/*class HomePage extends StatelessWidget {
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            netmedsScreen())));
                              },
                              icon: Icon(
                                Icons.download,
                                color: kPrim,
                              ))),
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => pharmeasyScreen())));
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
                                builder: ((context) => ApolloScreen())));
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
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String user = userEmail.toString();
    String trim = '@';
    int trimIndex = user.indexOf(trim);
    String userName = user.substring(0, trimIndex);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'welcome $userName',
            //'Set your next dosage.',
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
}*/
