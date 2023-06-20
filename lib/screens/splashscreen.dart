import 'package:flutter/material.dart';
import 'package:Medify/screens/signin.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Medify/screens/homepage.dart';
import 'package:lottie/lottie.dart';
import 'package:Medify/utils/color_utils.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  int splashtime = 3;
  // duration of splash screen on second

  var auth = FirebaseAuth.instance;
  var isLogin = false;

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return isLogin ? const HomePage() : const signIn();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //vertically align center
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                            top: 0.3.h,
                          ),
                          child: Text(
                            'Live happily.\nLive healthily.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: appBar,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        Material(
                          color: Colors.white,
                          child: Center(
                            child: Lottie.asset(
                              'assets/images/splash.json',
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        /*  Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/spscn.png",
                        height: 300.0,
                        // color: Colors.white,
                        // colorBlendMode: BlendMode.colorBurn,
                        // filterQuality: FilterQuality.high,
                        //  fit: BoxFit.fill,
                      ),
                    ), */
                        SizedBox(
                          height: 2.h,
                        ),
                        /*  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30.0),
                      child: Image.asset(
                        "assets/logo1.png",
                        height: 250.0,
                        width: 500.0,
                        //  color: Colors.white,

                        colorBlendMode: BlendMode.hue,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fill,
                      ),
                    ), */
                      ])),
            ],
          ));
    }));
  }
}
