# FlutDot

Godot meets Flutter!
Export your Godot App and let it run inside of Flutter. This enables you to combine High Performance Material design Apps from Flutter and 3D Visual worlds from Unity.
A bidirectional communication between GoDot and Flutter get your GoDot game the full access to all Hardware Sensor data from your Smartphone out of Flutter.

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
