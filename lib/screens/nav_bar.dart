import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:Medify/utils/color_utils.dart';
import 'package:Medify/screens/appointment.dart';
import 'package:Medify/screens/homepage.dart';
import 'package:Medify/screens/medicine_restock.dart';
import 'package:Medify/screens/files.dart';
import 'package:Medify/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:Medify/screens/files.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  

  @override
  Widget build(BuildContext context) {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    String user = userEmail.toString();
    String trim = '@';
    int trimIndex = user.indexOf(trim);
    String userName = user.substring(0, trimIndex);
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    return Drawer(
      backgroundColor: kText,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 60),
        child: ListView(
          children: [
            Row(
              children:  [
                Icon(Icons.account_circle),
                Text("Welcome $userName"),
              ],
            ),
            const Divider(),
            const Divider(
              color: Colors.white24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 40),
              child: Column(
                children: [
                  ListTile(
                      leading: const Icon(Icons.summarize),
                      title: const Text(
                        "My Case History",
                        style: TextStyle(color: kScaff),
                      ),
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const fileScreen(),
                            ),
                          );
                        }
                      }),
                  const Divider(
                    color: Colors.white24,
                  ),
                  ListTile(
                      leading: const Icon(Icons.summarize),
                      title: const Text(
                        "Upload New Case Details",
                        style: TextStyle(color: kScaff),
                      ),
                      onTap: () async{
                        {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'], //, 'doc', 'png', 'jpeg', 'jpg'
                          );
                          if (result != null) {
                            String filePath = result.files.single.path!;
                            String fileName = result.files.single.name;
                            io.File file = io.File(filePath);
                            Reference ref =
                              FirebaseStorage.instance.ref().child('$userId/$fileName');
                            UploadTask uploadTask = ref.putFile(file);
                            await uploadTask.whenComplete(() => Fluttertoast.showToast(
                            msg: "File uploaded successfully", gravity: ToastGravity.TOP));
                          }
                        }
                      }),
                  const Divider(
                    color: Colors.white24,
                  ),
                  ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text(
                        "Book Your Next Appointments",
                        style: TextStyle(color: kScaff),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const docApp(),
                          ),
                        );
                      }),
                  const Divider(
                    color: Colors.white24,
                  ),
                  ListTile(
                      leading: const Icon(Icons.shopping_cart),
                      title: const Text(
                        "Restock Medicines",
                        style: TextStyle(color: kScaff),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicineRestockPage(),
                          ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
