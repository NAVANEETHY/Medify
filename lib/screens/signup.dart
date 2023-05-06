import 'dart:ui';

import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:Medify/reusable_widgets/reusableWidgets.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Medify/screens/homepage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: const Text(
          "Sign up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(
              spawnMaxRadius: 50,
              spawnMinSpeed: 0,
              particleCount: 60,
              spawnMaxSpeed:0,
              minOpacity: 0.3,
              spawnOpacity: 0.4,
              //baseColor: Colors.purple,
              image: Image(image: AssetImage('assets/images/purpleMod.png')),
        )),
        vsync: this,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 122, 20, 0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter username", Icons.person_outline, false,
                    _usernameTextController),
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter email ID", Icons.person_outline, false,
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } on FirebaseException catch (e) {
                    Fluttertoast.showToast(
                        msg: e.message.toString(), gravity: ToastGravity.TOP);
                  }
                }),
              ],
            ),
          ))),
    );
  }
}
