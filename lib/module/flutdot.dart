import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FlutDot {
  late int _localPort;
  late InAppLocalhostServer _localhostServer;
  late InAppWebViewController _webcontroller;
  late Function(dynamic jsonData) cb;

  ///Must be initialized in the void main(){}
  FlutDot([int port = 1878]) {
    _localPort = port;
    _localhostServer = InAppLocalhostServer(port: _localPort);
    // start the localhost server
    _startServer();
  }

  int get port {
    return _localPort;
  }

  void set port(int portNumber) {
    _localPort = portNumber;
  }

  void _startServer() async {
    // start the localhost server
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await _localhostServer.start();
      if (Platform.isAndroid) {
        await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
            true);
      }
    } catch (e) {
      print("FlotDotError: " + e.toString());
    }
  }

  Widget GoDotContainer() {
    return InAppWebView(
      onConsoleMessage: (controller, consoleMessage) {
        if (cb != null) {
          try {
            dynamic jsonOBJ = jsonDecode(consoleMessage.message);
            cb(jsonOBJ);
          } catch (e) {}
        }
      },
      onWebViewCreated: (controller) {
        _webcontroller = controller;
      },
      initialUrlRequest:
          //URLRequest(url: Uri.parse("http://scooter-report.de/2d")),
          URLRequest(
              url: Uri.parse(
                  "http://127.0.0.1:${_localPort}/GoDotExport/index.html")),
    );
  }

  void sendMessage(String channel, String msg) {
    if (_webcontroller != null) {
      _webcontroller.evaluateJavascript(
          source: 'goDotJSChannel("{${channel}:${msg}}");');
    }
  }
}
