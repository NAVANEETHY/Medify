import 'package:Medify/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:Medify/reusable_widgets/reusableWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:animated_background/animated_background.dart';
import 'package:fluttertoast/fluttertoast.dart';

class resetPass extends StatefulWidget {
  const resetPass({super.key});

  @override
  State<resetPass> createState() => _resetPassState();
}

class _resetPassState extends State<resetPass> with TickerProviderStateMixin {
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
      ),
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
                resetButton(context, () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailTextController.text);
                    Fluttertoast.showToast(
                        msg: 'Mail has been sent to reset the password',
                        gravity: ToastGravity.BOTTOM);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => signIn()));
                  } on FirebaseException catch (e) {
                    Fluttertoast.showToast(
                        msg: e.message.toString(), gravity: ToastGravity.TOP);
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
