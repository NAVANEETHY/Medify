import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:sizer/sizer.dart';

class RemSetPage extends StatefulWidget {
  const RemSetPage({super.key});

  @override
  State<RemSetPage> createState() => _RemSetPageState();
}

class _RemSetPageState extends State<RemSetPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Set New Reminder'),
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PanelTitle(
              title: "Medicine Name",
              isRequired: true,
            ),
            TextFormField(
              maxLength: 12,
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kOther,
                  ),
            ),
            const PanelTitle(
              title: "Dosage (in mg)",
              isRequired: false,
            ),
            TextFormField(
              maxLength: 12,
              controller: dosageController,
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: UnderlineInputBorder()),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kOther,
                  ),
            ),
            SizedBox(
              height: 2.h,
            ),
            const PanelTitle(title: 'Medicine Type', isRequired: false),
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.h),
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset('assets/images/pill.svg'),
                    ),
                    Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.h),
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset('assets/images/bottle.svg'),
                    ),
                    Container(
                      width: 20.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.h),
                        color: Colors.white,
                      ),
                      child: SvgPicture.asset('assets/images/injection.svg'),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  const PanelTitle({super.key, required this.title, required this.isRequired});

  final String title;
  final bool isRequired;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Text.rich(
        TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kText,
              ),
            ),
            TextSpan(
              text: isRequired ? "*" : "",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                color: kText,
              ).copyWith(color: kPrim),
            )
          ],
        ),
      ),
    );
  }
}
