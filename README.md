# FlutDot - Godot meets Flutter!

Export your Godot app and run it in Flutter. This way you can combine high performance material design apps from Flutter and 3D visual worlds from GoDot.
Bi-directional communication between GoDot and Flutter gives your GoDot game full access to all hardware sensor data from your smartphone out of Flutter.

**Repository is currently under development and should only give an impression in which direction the project should rise up.**

## Test it on your Android device (Download)
[FlutDot APK Download](https://raw.githubusercontent.com/Celpear/FlutDot/main/APKBuilds/flutdot_test.apk)

## Getting Started

1. Make a Godot Web export to the flutdot_flutter/GoDotExport/ folder.

2. Build the flutter Project.

3. Enjoy the Demo. :)

## Required permissions

### IOS
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Android
```xml
    <uses-permission android:name="android.permission.INTERNET"/> <!-- <= Important!-->
   <application
        android:label="flutdot"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true"> <!-- <= Important!-->
```


ToDo | State GoDot | State Flutter 
-------- | -------- | -------- 
Show GoDot Web export in Flutter. | Done   | Done
Communication between GoDot and Flutter via JS inject and Log parse. (Temporary) | In Progress   | Done
Implement Socket.io or just WebSocket for the Communication between GoDot and Flutter | Planned | Planned
Implement GoDot native IOS Export in Flutter | Planned | Planned
Implement GoDot native Android Export in Flutter | Planned | Planned


#### This packages based on the following packages
- [flutter_inappwebview](https://pub.dev/packages/flutter_inappwebview)
- [socket.io](https://socket.io/)
- [Axios](https://github.com/axios/axios)
- [sensors_plus](https://pub.dev/packages/sensors_plus)
