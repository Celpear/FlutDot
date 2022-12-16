import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'module/flutdot.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:ffi';

import 'dart:io'
    show
        HttpRequest,
        HttpServer,
        InternetAddress,
        WebSocket,
        WebSocketTransformer;
import 'dart:convert' show json;
import 'dart:async' show Timer;

late FlutDot FlutDotHandler;

void main() {
  FlutDotHandler = FlutDot();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'flutdot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String godotData = "";
  late MagnetometerEvent magEvent;
  @override
  void initState() {
    // TODO: implement initState
    FlutDotHandler.msgReceiveCB = (data, da) {
      print(data);
    };
    magnetometerEvents.listen((MagnetometerEvent event) {
      magEvent = event;
      //print("MagnetometerEvent:" + event.toString());
    });
    initServer();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Stack(
        children: [
          FlutDotHandler.GoDotContainer(),
          Align(
            alignment: Alignment(0.0, 0.9),
            child: Text(godotData),
          ),
          Align(
            alignment: Alignment(0.8, -0.8),
            child: TextButton(
              child: Text("Send Hello Hero! -> GoDot"),
              onPressed: () {
                //FlutDotHandler.sendMessage("AlertData", "Hello Hero!");
                FlutDotHandler.sendMessage("GG");
              },
            ),
          )
        ],
      ),
    ));
  }
}

void initServer() {
  print("FlutDot: Init Server!");
  HttpServer.bind('localhost', 8170).then((HttpServer server) {
    print('FlutDot: [+]WebSocket listening at -- ws://localhost:8170/');
    server.listen((HttpRequest request) {
      WebSocketTransformer.upgrade(request).then((WebSocket ws) {
        ws.listen(
          (data) {
            print(
                '\t\t FlutDot:${request?.connectionInfo?.remoteAddress} -- ${Map<String, String>.from(json.decode(data))}');

            Timer(Duration(seconds: 1), () {
              if (ws.readyState == WebSocket.open)
                // checking connection state helps to avoid unprecedented errors
                ws.add(json.encode({
                  'data': 'from server at ${DateTime.now().toString()}',
                }));
            });
          },
          onDone: () => print('[+]Done :)'),
          onError: (err) => print('[!]Error -- ${err.toString()}'),
          cancelOnError: true,
        );
      }, onError: (err) => print('[!]Error -- ${err.toString()}'));
    }, onError: (err) => print('[!]Error -- ${err.toString()}'));
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}

void initClient() {
  WebSocket.connect('ws://localhost:8000').then((WebSocket ws) {
    // our websocket server runs on ws://localhost:8000
    if (ws?.readyState == WebSocket.open) {
      // as soon as websocket is connected and ready for use, we can start talking to other end
      ws.add(json.encode({
        'data': 'from client at ${DateTime.now().toString()}',
      })); // this is the JSON data format to be transmitted
      ws.listen(
        // gives a StreamSubscription
        (data) {
          print(
              '\t\t -- ${Map<String, String>.from(json.decode(data))}'); // listen for incoming data and show when it arrives
          Timer(Duration(seconds: 1), () {
            if (ws.readyState ==
                WebSocket
                    .open) // checking whether connection is open or not, is required before writing anything on socket
              ws.add(json.encode({
                'data': 'from client at ${DateTime.now().toString()}',
              }));
          });
        },
        onDone: () => print('[+]Done :)'),
        onError: (err) => print('[!]Error -- ${err.toString()}'),
        cancelOnError: true,
      );
    } else
      print('[!]Connection Denied');
    // in case, if serer is not running now
  }, onError: (err) => print('[!]Error -- ${err.toString()}'));
}
