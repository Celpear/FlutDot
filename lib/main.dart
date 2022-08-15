import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'module/flutdot.dart';
import 'package:sensors_plus/sensors_plus.dart';

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
    FlutDotHandler.cb = (data) {
      godotData = data.toString();
      setState(() {});
    };
    magnetometerEvents.listen((MagnetometerEvent event) {
      magEvent = event;
      print("MagnetometerEvent:" + event.toString());
    });
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
                FlutDotHandler.sendMessage("AlertData", "Hello Hero!");
              },
            ),
          )
        ],
      ),
    ));
  }
}
