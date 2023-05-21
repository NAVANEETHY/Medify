import 'package:flutter/material.dart';
import 'package:Medify/screens/signin.dart';
import 'package:sizer/sizer.dart';

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

  @override
  void initState() {
    Future.delayed(Duration(seconds: splashtime), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(
          //pushReplacement = replacing the route so that
          //splash screen won't show on back button press
          //navigation to Home page.
          builder: (context) {
        return const signIn();
      }));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return Scaffold(
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
                        bottom: 1.h,
                      ),
                      child: Text(
                        'Live happily.\nLive healthily.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/spscn.png",
                        height: 300.0,
                        // color: Colors.white,
                        // colorBlendMode: BlendMode.colorBurn,
                        // filterQuality: FilterQuality.high,
                        //  fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30.0),
                      child: Image.asset(
                        "assets/images/logo1mod.png",
                        height: 250.0,
                        width: 500.0,
                        //  color: Colors.white,

                        colorBlendMode: BlendMode.hue,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ])),
        ],
      ));
    }));
  }
}
