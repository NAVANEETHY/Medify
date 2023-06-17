import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class netmedsScreen extends StatefulWidget {
  const netmedsScreen({super.key});

  @override
  State<netmedsScreen> createState() => _netmedsScreenState();
}

class _netmedsScreenState extends State<netmedsScreen> {
  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Netmeds'),
      ),
      body: Stack(children: [
        InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse('https://m.netmeds.com')),
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