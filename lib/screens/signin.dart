//import 'dart:html';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Medify/reusable_widgets/reusableWidgets.dart';
import 'package:Medify/screens/signup.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:Medify/screens/homepage.dart';
import 'package:Medify/services/firebase_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animated_background/animated_background.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> with TickerProviderStateMixin {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(
          spawnMaxRadius: 50,
          spawnMinSpeed: 0,
          particleCount: 60,
          spawnMaxSpeed: 0,
          minOpacity: 0.3,
          spawnOpacity: 0.4,
          image: Image(image: AssetImage('assets/images/purpleMod.png')),
        )),
        vsync: this,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email", Icons.person_outline, false,
                    _emailTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true,
                    _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, false, () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } on FirebaseException catch (e) {
                    Fluttertoast.showToast(
                        msg: e.message.toString(), gravity: ToastGravity.TOP);
                  }
                }),
                signUpOption(),
                SizedBox(
                  height: 20,
                ),
                orOption(),
                SizedBox(
                  height: 5,
                ),
                googleSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

Row orOption() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'Or login with',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      )
    ],
  );
}
