import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Medify/screens/signin.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Medify/screens/splashscreen.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        title: 'Medify',
        themeMode: ThemeMode.system,
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrim,
          scaffoldBackgroundColor: kScaff,
          appBarTheme: AppBarTheme(
              toolbarHeight: 7.h,
              backgroundColor: kScaff,
              elevation: 0,
              iconTheme: IconThemeData(
                color: kSec,
                size: 20.sp,
              ),
              titleTextStyle: GoogleFonts.mulish(
                color: kText,
                fontWeight: FontWeight.w800,
                fontStyle: FontStyle.normal,
                fontSize: 16.sp,
              )),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.breeSerif(
              fontSize: 28.sp,
              color: kText,
              fontWeight: FontWeight.w700,
            ),
            displayMedium: GoogleFonts.aBeeZee(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: kError,
            ),
            displaySmall: GoogleFonts.breeSerif(
              fontSize: 24.sp,
              color: kSec,
            ),
          ),
          /*inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kTextLight,
                width: 0.7,
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: kTextLight),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kPrim,
              ),
            ),
          ),*/
        ),
        home: const SplashScreen(),
      );
    }));
  }
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medify',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
        home: const SplashScreen(),
    );
  }
}*/
