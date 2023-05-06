import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io' as io;
import 'package:Medify/services/firebase_services.dart';
import 'package:Medify/services/check_per.dart';
import 'package:Medify/services/dir_path.dart';
import 'package:Medify/screens/caseHistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:Medify/screens/files.dart';

class fileScreen extends StatefulWidget {
  const fileScreen({super.key});
  @override
  State<fileScreen> createState() => _fileScreenState();
}

class _fileScreenState extends State<fileScreen> {
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  bool downloading = false;
  bool fileExists = false;
  double progress = 0;
  var getPathFile = dirPath();
  late String filePath;
  String fileName = "";

  Future downloadFile(Reference ref) async {
    var url = await ref.getDownloadURL();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    try {
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          setState(() {
            progress = (count / total);
          });
        },
      );
      setState(() {
        downloading = false;
        fileExists = true;
      });
    } catch (e) {
      setState(() {
        downloading = false;
      });
    }
  }

  checkFileExist() async {
    var storePath = getPathFile.getPath();
    filePath = '$filePath/$fileName';
    bool fileExistCheck = await io.File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  late Future<ListResult> cases;
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    cases = FirebaseStorage.instance.ref('/$userId').listAll();
    checkPermission();
    checkFileExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Case history"),
      ),
      body: FutureBuilder<ListResult>(
          future: cases,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final files = snapshot.data!.items;
              return ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return ListTile(
                        title: Text(file.name),
                        textColor: Colors.black,
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ));
                  });
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error occured'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

Future downloadFile(Reference ref) async {
  final url = await ref.getDownloadURL();
  final dir = await getTemporaryDirectory();
  final file = io.File('${dir.path}/${ref.name}');
  final response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  await file.writeAsBytes(response.data);
}
