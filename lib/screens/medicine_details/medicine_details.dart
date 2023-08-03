import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:Medify/global_bloc.dart';
import 'package:Medify/utils/medicine.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:Medify/screens/homepage.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({super.key, required this.medicine});
  final Medicine medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MainSection(medicine: widget.medicine),
            ExtendedSection(medicine: widget.medicine),
            Spacer(),
            SizedBox(
              width: 100.w,
              height: 7.h,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kSec,
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  //open alert dialog
                  openAlertBox(context, _globalBloc);
                },
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kScaff,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          )),
          contentPadding: EdgeInsets.only(top: 1.h),
          title: Text('Delete this Reminder?',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 14.sp, color: kOther)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.grey[700], fontSize: 12.sp),
              ),
            ),
            TextButton(
              onPressed: () {
                //global bloc to delete
                _globalBloc.removeMedicine(widget.medicine);
                //Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => HomePage())));
              },
              child: Text(
                'OK',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: kSec, fontSize: 12.sp),
              ),
            ),
          ],
        );
      },
    );
  }
}

class MainSection extends StatelessWidget {
  const MainSection({super.key, this.medicine});
  final Medicine? medicine;
  Hero makeIcon(double size) {
    if (medicine!.medicineType == 'Pill') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/images/medicine.svg',
          color: kOther,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Bottle') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/images/syrup.svg',
          color: kOther,
          height: 7.h,
        ),
      );
    } else if (medicine!.medicineType == 'Injection') {
      return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: SvgPicture.asset(
          'assets/images/syringe.svg',
          color: kOther,
          height: 7.h,
        ),
      );
    }
    return Hero(
        tag: medicine!.medicineName! + medicine!.medicineType!,
        child: Icon(
          Icons.error,
          color: kOther,
          size: size,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        makeIcon(7.h),
        /* SvgPicture.asset(
          'assets/bottle.svg',
          height: 7.h,
        ), */
        SizedBox(
          width: 2.w,
        ),
        Column(
          children: [
            Hero(
                tag: medicine!.medicineName!,
                child: Material(
                    color: Colors.transparent,
                    child: MainInfoTab(
                        fieldTitle: 'Medicine Name',
                        fieldInfo: medicine!.medicineName!))),
            MainInfoTab(
                fieldTitle: 'Dosage',
                fieldInfo: medicine!.dosage == 0
                    ? 'Not Specified'
                    : "${medicine!.dosage} mg"),
          ],
        ),
      ],
    );
  }
}

class MainInfoTab extends StatelessWidget {
  const MainInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.w,
      height: 10.h,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fieldTitle,
              style: TextStyle(
                color: kText,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(
              height: 0.3.h,
            ),
            Text(
              fieldInfo,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  const ExtendedSection({super.key, this.medicine});
  final Medicine? medicine;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExtendedInfoTab(
          fieldTitle: 'Medicine Type',
          fieldInfo: medicine!.medicineType! == 'None'
              ? 'Not Specified'
              : medicine!.medicineType!,
        ),
        ExtendedInfoTab(
            fieldTitle: 'Dosage Interval',
            fieldInfo:
                'Every ${medicine!.interval} hours | ${medicine!.interval == 24 ? "One time a day" : "${(24 / medicine!.interval!).floor()} times a day "} '),
        ExtendedInfoTab(
            fieldTitle: 'Start Time',
            fieldInfo:
                '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}'),
      ],
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  const ExtendedInfoTab(
      {super.key, required this.fieldTitle, required this.fieldInfo});

  final String fieldTitle;
  final String fieldInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Text(
              fieldTitle,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: kText, fontSize: 14.sp),
            ),
          ),
          Text(
            fieldInfo,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: kSec, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
