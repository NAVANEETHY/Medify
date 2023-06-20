import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Medify/screens/rem_set_page.dart';

class RemSetScreen extends StatefulWidget {
  const RemSetScreen({super.key});

  @override
  State<RemSetScreen> createState() => _RemSetScreenState();
}

class _RemSetScreenState extends State<RemSetScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1000), () {
      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => const RemSetPage())));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Lottie.asset(
          'assets/images/timer.json',
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
