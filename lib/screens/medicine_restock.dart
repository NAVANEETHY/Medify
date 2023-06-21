import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:Medify/reusable_widgets/reusableWidgets.dart';
import 'package:Medify/screens/appollo.dart';
import 'package:Medify/screens/netmeds.dart';
import 'package:Medify/screens/pharmeasy.dart';

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
          SizedBox(
            height: 40,
          ),
          Restock(context, 'Apollo Pharmacy', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ApolloScreen()));
          }),
          SizedBox(
            height:5,
          ),
          Restock(context, 'Pharmeasy', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => pharmeasyScreen()));
          }),
          SizedBox(
            height:5,
          ),
          Restock(context, 'Netmeds', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=> netmedsScreen()));
          }),
        ],
      ),
    );
  }
}
