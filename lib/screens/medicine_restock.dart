import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:Medify/utils/color_utils.dart';

class MedicineRestockPage extends StatefulWidget {
  const MedicineRestockPage({super.key});

  @override
  State<MedicineRestockPage> createState() => _MedicineRestockPageState();
}

class _MedicineRestockPageState extends State<MedicineRestockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Book your Medicine'),
      ),
      body: Column(
        children: [
          Text(
            'We’ve got your medicine covered',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: appBar, fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          Material(
            color: Colors.white,
            child: Center(
              child: Lottie.asset(
                'assets/images/medicine_order.json',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
