import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class ApolloScreen extends StatefulWidget {
  const ApolloScreen({super.key});

  @override
  State<ApolloScreen> createState() => _ApolloScreenState();
}

class _ApolloScreenState extends State<ApolloScreen> {
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Apollo Pharmacy'),
      ),
      body: Stack(children: [
        InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse('https://www.apollopharmacy.in')),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
          },
          onProgressChanged: (InAppWebViewController controller, int progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
        ),
        _progress< 1? SizedBox(
          height: 3,
          child: LinearProgressIndicator(
            value: _progress,
          ),
        ):SizedBox(),
      ]),
    );
  }
}