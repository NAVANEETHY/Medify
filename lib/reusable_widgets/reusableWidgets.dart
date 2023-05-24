//import 'dart:html';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:Medify/services/firebase_services.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:Medify/screens/files.dart';
import 'package:Medify/screens/signin.dart';
import 'package:Medify/screens/homepage.dart';
import 'package:flutter/services.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.transparent.withOpacity(0.1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white.withOpacity(0.7);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Future<void> Logout(BuildContext context) async {
  FirebaseAuth.instance.signOut().then((value) {
    Fluttertoast.showToast(msg: 'Signed out', gravity: ToastGravity.TOP);
    Navigator.push(context, MaterialPageRoute(builder: (context) => signIn()));
  });
  await FirebaseServices().signOut().then((value) {
    Fluttertoast.showToast(msg: 'Signed out', gravity: ToastGravity.TOP);
    Navigator.push(context, MaterialPageRoute(builder: (context) => signIn()));
  });
}

Container googleSignInButton(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 80,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () async {
        try {
          await FirebaseServices().signInWithGoogle();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        } catch (e) {
          Fluttertoast.showToast(
              msg: "You haven't used google login", gravity: ToastGravity.TOP);
          throw e;
        }
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white.withOpacity(0.7);
          }),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder())),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/googlebg.png",
                width: 50,
                height: 50,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Container googleLogout(BuildContext context) {
  return Container(
      child: ElevatedButton(
    child: Text("Logout"),
    onPressed: () async {
      FirebaseAuth.instance.signOut().then((value) {
        print("Signed out");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => signIn()));
      });
      await FirebaseServices().signOut().then((value) {
        print("Signed out");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => signIn()));
      });
    },
  ));
}

Container uploadFileButton(BuildContext context) {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'doc', 'png', 'jpeg', 'jpg'],
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
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/upload.png",
                  width: 40,
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Upload case history",
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ));
}

Container showCaseButton(BuildContext context) {
  return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => fileScreen()));
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)))),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                const Text("Show case history",
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
        ),
      ));
}




Future<bool> backButtonPressed(BuildContext context) async {
  bool exitApp = false;

  Future<void> _showExitConfirmationDialog() async {
    exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Medify"),
          content: const Text("Do you want to close the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );

    if (exitApp ?? false) {
      SystemNavigator.pop(); // Exit the app
    }
  }

  await _showExitConfirmationDialog();

  return exitApp ?? false;
}


/*Future<bool> backButtonPressed(BuildContext context) async {
  bool exitApp = false;

  Future<void> _showExitConfirmationDialog() async {
    exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Medify"),
          content: const Text("Do you want to close the app?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  await _showExitConfirmationDialog();

  return exitApp ?? false;
}*/



