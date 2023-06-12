import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as DatePickers;
//request.time < timestamp.date(2023, 5, 16);

class docApp extends StatefulWidget {
  const docApp({super.key});

  @override
  State<docApp> createState() => _docAppState();
}

class _docAppState extends State<docApp> {
  String? selectedLocation;
  String? selectedSpecialist;
  String? selectedDoctor;
  DateTime? selectedDate;
  String? selectedTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Appointment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting location
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('Location').get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                List<DropdownMenuItem<String>> dropdownItems =
                    snapshot.data!.docs
                        .map((doc) => DropdownMenuItem<String>(
                              value: doc.id,
                              child: Text(doc.id),
                            ))
                        .toList();

                return DropdownButton<String>(
                  value: selectedLocation,
                  hint: Text(
                    'Select a location',
                    style: TextStyle(color: Colors.black),
                  ),
                  dropdownColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                      selectedSpecialist = null;
                      selectedDoctor = null;
                      selectedDate = null;
                      selectedTime = null;
                    });
                  },
                  items: dropdownItems,
                );
              },
            ),
            SizedBox(height: 16.0),
            FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Location')
                    .doc(selectedLocation)
                    .collection('Specialists')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  List<DropdownMenuItem<String>> dropdownItems =
                      snapshot.data!.docs
                          .map((doc) => DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text(doc.id),
                              ))
                          .toList();
                  return DropdownButton<String>(
                    value: selectedSpecialist,
                    hint: Text(
                      'Select a specialist',
                      style: TextStyle(color: Colors.black),
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        selectedSpecialist = value;
                        selectedDoctor = null;
                        selectedDate = null;
                        selectedTime = null;
                      });
                    },
                    items: dropdownItems,
                  );
                }),
            SizedBox(height: 16.0),
            FutureBuilder<DocumentSnapshot>(
                future: selectedLocation != null && selectedSpecialist != null
                    ? FirebaseFirestore.instance
                        .collection('Location')
                        .doc(selectedLocation)
                        .collection('Specialists')
                        .doc(selectedSpecialist)
                        .get()
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  Map<String, dynamic> specialistData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  List<DropdownMenuItem<String>> dropdownItems =
                      specialistData.keys
                          .map(
                            (key) => DropdownMenuItem<String>(
                              value: key,
                              child: Text(key),
                            ),
                          )
                          .toList();
                  return DropdownButton<String>(
                    value: selectedDoctor,
                    hint: Text('Select a Doctor',
                        style: TextStyle(color: Colors.black)),
                    dropdownColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {
                        selectedDoctor = value;
                        selectedDate = null;
                        selectedTime = null;
                      });
                    },
                    items: dropdownItems,
                  );
                }),
            SizedBox(height: 16.0),
            TextButton(
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                onPressed: () async {
                  final DateTime? pickedDate = await showDialog(
                      context: context,
                      builder: (context) {
                        return DatePickerDialog(
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2024),
                        );
                      });
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      selectedTime = null;
                    });
                  }
                },
                child: Text('Select Date')),
            SizedBox(height: 16.0),
            selectedDate != null
                ? Text(
                    'Selected Date: ${selectedDate!.toString()}',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  )
                : SizedBox(),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
