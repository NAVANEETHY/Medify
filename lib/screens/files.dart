//import 'dart:html';
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
import 'package:path/path.dart' as Path;
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/*Future downloadFile(Reference ref) async {
  final url = await ref.getDownloadURL();
  final dir = await getTemporaryDirectory();
  final file = io.File('${dir.path}/${ref.name}');
  final response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  await file.writeAsBytes(response.data);
}*/

class fileScreen extends StatefulWidget {
  const fileScreen({super.key});

  @override
  State<fileScreen> createState() => _fileScreenState();
}

class _fileScreenState extends State<fileScreen> {
  late Future<ListResult> cases;
  String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    cases = FirebaseStorage.instance.ref('/$userId').listAll();
  }

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
                    itemBuilder: (context, index)  {
                      final file = files[index];
                      String fileName = file.name;
                      return ListTile(
                        title: Text(file.name),
                        textColor: Colors.black,
                        leading: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.close, color: Colors.black)),
                        trailing: IconButton(
                            onPressed: () async {
                              String downloadUrl = await FirebaseStorage.instance.ref('$userId/$fileName').getDownloadURL();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => View(
                                            url:downloadUrl,
                                          )));
                            },
                            icon: Icon(Icons.download, color: Colors.black)),
                      );
                    });
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error occured'),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class View extends StatelessWidget {
  PdfViewerController? _pdfViewerController;
  final String url;

  View({required this.url});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('case history viewer'),
      ),
      body: SfPdfViewer.network(
        url,
        controller: _pdfViewerController,
      ),
    );
  }
}