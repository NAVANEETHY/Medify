import 'package:Medify/utils/color_utils.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Medify/services/notification_services.dart';
import 'package:Medify/global_bloc.dart';
import 'package:Medify/utils/errors.dart';
import 'package:Medify/screens/homepage.dart';
import 'package:Medify/services/rem_set_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:Medify/services/convert_time.dart';
import 'package:Medify/utils/medicine.dart';
import 'package:Medify/utils/medicine_type.dart';
import 'success_screen.dart';

class RemSetPage extends StatefulWidget {
  const RemSetPage({super.key});

  @override
  State<RemSetPage> createState() => _RemSetPageState();
}

class _RemSetPageState extends State<RemSetPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  late NewEntryBloc _newEntryBloc;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late final NotificationService notificationService = NotificationService();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _newEntryBloc = NewEntryBloc();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    notificationService.initializePlatformNotifications();

    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Set New Reminder'),
      ),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Padding(
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
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.cyan[600],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
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
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.cyan[600],
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                height: 2.h,
              ),
              const PanelTitle(title: 'Medicine Type', isRequired: false),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: StreamBuilder<MedicineType>(
                  stream: _newEntryBloc.selectedMedicineType,
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MedicineTypeColumn(
                            medicineType: MedicineType.Pill,
                            name: 'Pill',
                            iconValue: 'assets/images/pill.svg',
                            //'assets/medicine.svg',
                            isSelected: snapshot.data == MedicineType.Pill
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.Bottle,
                            name: 'Bottle',
                            iconValue: 'assets/images/bottle.svg',
                            //'assets/syrup.svg',
                            isSelected: snapshot.data == MedicineType.Bottle
                                ? true
                                : false),
                        MedicineTypeColumn(
                            medicineType: MedicineType.Injection,
                            name: 'Injection',
                            iconValue: 'assets/images/injection.svg',
                            //'assets/syringe.svg',
                            isSelected: snapshot.data == MedicineType.Injection
                                ? true
                                : false),
                      ],
                    );
                  },
                ),
              ),
              const PanelTitle(title: 'Interval', isRequired: true),
              const IntervalSelection(),
              Row(
                children: [
                  const PanelTitle(title: 'Start Time', isRequired: true),
                  SizedBox(
                    width: 10.w,
                  ),
                  const SelectTime(),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 8.w,
                  right: 8.w,
                ),
                child: Center(
                  child: SizedBox(
                    width: 46.w,
                    height: 9.h,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: kText,
                        shape: const StadiumBorder(),
                      ),
                      child: Text('Confirm'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: kScaff, fontSize: 12.sp)),
                      onPressed: () async {
                        //function to be added
                        String? medicineName;
                        int? dosage;
                        if (nameController.text == ".") {
                          _newEntryBloc.submitError(EntryError.nameNull);
                          return;
                        }
                        if (nameController.text != "") {
                          medicineName = nameController.text;
                        }
                        if (dosageController.text == "") {
                          dosage = 0;
                        }
                        if (dosageController.text != "") {
                          dosage = int.parse(dosageController.text);
                        }
                        for (var medicine in globalBloc.medicineList$!.value) {
                          if (medicineName == medicine.medicineName) {
                            _newEntryBloc.submitError(EntryError.nameDuplicate);
                            return;
                          }
                        }
                        if (_newEntryBloc.selectIntervals!.value == 0) {
                          _newEntryBloc.submitError(EntryError.interval);
                          return;
                        }
                        if (_newEntryBloc.selectedTimeOfDay!.value == 'None') {
                          _newEntryBloc.submitError(EntryError.startTime);
                          return;
                        }

                        String medicineType = _newEntryBloc
                            .selectedMedicineType!.value
                            .toString()
                            .substring(13);
                        int interval = _newEntryBloc.selectIntervals!.value;
                        String startTime =
                            _newEntryBloc.selectedTimeOfDay!.value;
                        List<int> intIDs =
                            makeIDs(24 / _newEntryBloc.selectIntervals!.value);
                        List<String> notificationIDs =
                            intIDs.map((i) => i.toString()).toList();
                        Medicine newEntryMedicine = Medicine(
                          notificationIDs: notificationIDs,
                          medicineName: medicineName,
                          dosage: dosage,
                          medicineType: medicineType,
                          interval: interval,
                          startTime: startTime,
                        );

                        globalBloc.updateMedicineList(newEntryMedicine);
                        await notificationService.showLocalNotification(
                          id: 0,
                          title:
                              'Reminder: ${newEntryMedicine.medicineName} at  ${newEntryMedicine.startTime?[0]}${newEntryMedicine.startTime?[1]}:${newEntryMedicine.startTime?[2]}${newEntryMedicine.startTime?[0]}',
                          body:
                              'Take ${newEntryMedicine.medicineName} at ${newEntryMedicine.interval} hour intervals',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuccessScreen()),
                        );
                        //schedule notif
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$!.listen((EntryError error) {
      switch (error) {
        case EntryError.nameNull:
          displayError('Please enter the medicine name');
          break;
        case EntryError.nameDuplicate:
          displayError('Medicine name already exists');
          break;
        case EntryError.dosage:
          displayError('Please enter the dosage required');
          break;
        case EntryError.interval:
          displayError('Please select the reminder interval');
          break;
        case EntryError.startTime:
          displayError('Please enter the reminder start time');
          break;
        default:
          break;
      }
    });
  }

  void displayError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kOther,
        content: Text(error),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }
/*
  initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
 Future<void> schedulePeriodicNotifications({
  required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  required int notificationId,
  required String title,
  required String body,
  required String startTime,
  required Duration interval,
}) async {
  final startHour = int.parse(startTime.substring(0, 2));
  final startMinute = int.parse(startTime.substring(2, 4));
  final now = DateTime.now();
   final startTimeDateTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, startHour, startMinute);
  // Cancel any previously scheduled notifications with the same ID
  await flutterLocalNotificationsPlugin.cancel(notificationId);

  // Calculate the next notification time based on the start time and interval
   tz.TZDateTime nextNotificationTime = startTimeDateTime;


  while (nextNotificationTime.isBefore(DateTime.now())) {
    nextNotificationTime = nextNotificationTime.add(interval);
  }

  // Schedule the periodic notifications
  while (nextNotificationTime.isBefore(DateTime.now().add(const Duration(days: 365)))) {
    const platformChannelSpecifics = NotificationDetails(
      android:  AndroidNotificationDetails(
       'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      importance: Importance.max,
      priority: Priority.max,
      ledColor: kOther,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
      enableVibration: true,
      ),
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      nextNotificationTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'Notification payload',
      androidAllowWhileIdle: true,
    );

    // Calculate the next notification time
    nextNotificationTime = nextNotificationTime.add(interval);
  }
}

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime![0] + medicine.startTime![1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime![2] + medicine.startTime![3]);

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      importance: Importance.max,
      priority: Priority.max,
      ledColor: kOther,
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
      enableVibration: true,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    tz.initializeTimeZones(); // Initialize the time zones
    var now = tz.TZDateTime.now(tz.local);

    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      hour = ogValue + (medicine.interval! * i);
      if (hour > 23) {
        hour = hour - 24;
      }
      var notificationDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

      await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        medicine.medicineType.toString() != MedicineType.None.toString()
            ? 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to the schedule.'
            : 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to the schedule.',
        notificationDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'Notification payload',
      );
      /* for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      if (hour + (medicine.interval! * i) > 23) {
        hour = hour + (medicine.interval! * i) - 24;
      } else {
        hour = hour + (medicine.interval! * i);
      } */

      /*   await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs![i]),
          'Reminder : ${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.None.toString()
              ? 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule'
              : 'It is time to take your ${medicine.medicineType!.toLowerCase()}, according to schedule',
          Time(hour, minute, 0),
          platformChannelSpecifics); */
      hour = ogValue;
    }
  } */
}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;
  Future<TimeOfDay> _selectTime() async {
    final NewEntryBloc newEntryBloc =
        Provider.of<NewEntryBloc>(context, listen: false);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        //update state with provider dart packages - to be done
        newEntryBloc.updateTime(convertTime(_time.hour.toString()) +
            convertTime(_time.minute.toString()));
      });
    }
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7.h,
      child: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: kText,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            _selectTime();
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? '00:00'
                  : "${convertTime(_time.hour.toString())}: ${convertTime(_time.minute.toString())}",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: kScaff, fontSize: 14.sp),
            ),
          ),
        ),
      ),
    );
  }
}

class IntervalSelection extends StatefulWidget {
  const IntervalSelection({super.key});

  @override
  State<IntervalSelection> createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  final _intervals = [6, 8, 12, 24];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Remind me every',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: kText, fontSize: 12.sp),
          ),
          DropdownButton(
            iconEnabledColor: kOther,
            dropdownColor: kScaff,
            itemHeight: 8.h,
            hint: _selected == 0
                ? Text(
                    'Select an interval',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kSec, fontSize: 12.sp),
                  )
                : null,
            elevation: 4,
            value: _selected == 0 ? null : _selected,
            items: _intervals.map(
              (int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.cyan[600], fontSize: 14.sp),
                  ),
                );
              },
            ).toList(),
            onChanged: (newVal) {
              setState(
                () {
                  _selected = newVal!;
                  newEntryBloc.updateInterval(newVal);
                },
              );
            },
          ),
          Text(
            _selected == 1 ? 'hour' : 'hours',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: kText, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  const MedicineTypeColumn(
      {super.key,
      required this.medicineType,
      required this.name,
      required this.iconValue,
      required this.isSelected});
  final MedicineType medicineType;
  final String name;
  final String iconValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        //select functionality
        newEntryBloc.updateSelectedMedicine(medicineType);
      },
      child: Column(
        children: [
          Container(
            width: 20.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.h),
              color: isSelected ? kOther : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 1.h,
                  bottom: 1.h,
                ),
                child: SvgPicture.asset(
                  iconValue,
                  height: 7.h,
                  // color: isSelected ? Colors.white : kOther,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Container(
              width: 20.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? kOther : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: kText, fontSize: 12.sp),
              )),
            ),
          ),
        ],
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
