import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:connectme/connectme.dart';

class FlutDot {
  late int _localWebPort;
  late int _localWSPort;
  late InAppLocalhostServer _localhostServer;
  late InAppWebViewController _webcontroller;
  late final ConnectMeServer _server;
  late Function(String message, ConnectMeClient client) msgReceiveCB;
  late Function(String msg) sendmsgCB;

  ///Must be initialized in the void main(){}
  FlutDot({int portWeb = 1878, int portWS = 1996}) {
    _localWebPort = portWeb;
    _localWSPort = portWS;
    if (!kIsWeb) {
      _localhostServer = InAppLocalhostServer(port: _localWebPort);
    }
    // start the localhost server
    _startServer();
  }

  int get port {
    return _localWebPort;
  }

  void set port(int portNumber) {
    _localWebPort = portNumber;
  }

  void _startServer() async {
    // start the localhost server
    try {
      WidgetsFlutterBinding.ensureInitialized();
      if (!kIsWeb) await _localhostServer.start();
      if (Platform.isAndroid) {
        await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
            true);
      }
    } catch (e) {
      print("FlotDotError: " + e.toString());
    }
    //Start websocket Server
    try {
      _server = await ConnectMe.serve(
        //InternetAddress('127.0.0.1'),
        InternetAddress("192.168.178.74"),
        port: _localWSPort,
        onConnect: (ConnectMeClient client) {
          print('connected.');
          client.autoReconnect = true;
          print('start listener.');
          client.send("FlutDot init msg");
          _server.listen<String>((String message, ConnectMeClient client) {
            if (msgReceiveCB != null) {
              msgReceiveCB(message, client);
            }
          });
        },
        onDisconnect: (ConnectMeClient client) {
          print('${client.address} disconnected.');
        },
        type: ConnectMeType
            .ws, // by default, means using WebSocket server, can be also pure TCP
      );
    } catch (e) {
      print("FlotDotError: " + e.toString());
    }
  }

  Widget GoDotContainer() {
    return InAppWebView(
      onWebViewCreated: (controller) {
        _webcontroller = controller;
      },
      initialUrlRequest:
          //URLRequest(url: Uri.parse("http://scooter-report.de/2d")),
          URLRequest(
              url: Uri.parse(
                  "http://127.0.0.1:${_localWebPort}/GoDotExport/index.html")),
    );
  }

  void sendMessage(String message) {
    if (_server != null) _server.broadcast('Cheese for Everyone!');
  }
}
