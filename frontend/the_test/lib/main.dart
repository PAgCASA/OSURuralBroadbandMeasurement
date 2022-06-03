import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_test/personalInfoScreen.dart';
import 'package:the_test/resultsScreen.dart';
import 'package:the_test/runTest.dart';
import 'homeScreen.dart';

// import 'package:ndt_7_dart/src/download.dart';
// import 'package:ndt_7_dart/src/locator.dart';
// import 'package:ndt_7_dart/src/upload.dart';

void main() => runApp(const MyApp());

//Class for test result object which will be sent to the back end
class TestResult {
  //object fields
  String phone_ID;
  String test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;
  DateTime testStartTime;
  Duration testDuration;

  Position position;

  //constructor for object
  TestResult(
      {required this.phone_ID,
      required this.test_ID,
      required this.downloadSpeed,
      required this.uploadSpeed,
      required this.latency,
      required this.jitter,
      required this.packetLoss,
      required this.testStartTime,
      required this.testDuration,
      required this.position});

  //JSON conversion method
  Map toJSON() => {
        "phoneID": phone_ID,
        "testID": test_ID,
        "downloadSpeed": downloadSpeed,
        "uploadSpeed": uploadSpeed,
        "latency": latency,
        "jitter": jitter,
        "packetLoss": packetLoss,
        "testStartTime": testStartTime.toUtc().toIso8601String(),
        "testDuration": testDuration.inMilliseconds,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "accuracy": position.accuracy
      };

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
        phone_ID: json['phoneID'],
        test_ID: json['testID'],
        downloadSpeed: json['downloadSpeed'] + 0.0,
        uploadSpeed: json['uploadSpeed'] + 0.0,
        latency: json['latency'] as int,
        jitter: json['jitter'] as int,
        packetLoss: json['packetLoss'] as int,
        //try and parse a string
        testStartTime: DateTime.tryParse(json['testStartTime']) ?? DateTime.now(),
        //the below is just fake data
        testDuration: const Duration(),
        position: const Position(speedAccuracy: 0, timestamp: null, latitude: 0, accuracy: 0, speed: 0, altitude: 0, longitude: 0, heading: 0)
    );
  }
}

//Class for sending personal information to the backend
class PersonalInformation {
  //object fields
  String deviceID;
  String firstName;
  String lastName;
  String street;
  String postalCode;
  String city;
  String state;
  String internetPlan;

  //Constructor
  PersonalInformation(this.deviceID, this.firstName, this.lastName, this.street,
      this.postalCode, this.city, this.state, this.internetPlan);

  //JSON conversion method
  Map<String, String> toJSON() => {
        "deviceID": deviceID,
        "firstName": firstName,
        "lastName": lastName,
        "street": street,
        "postalCode": postalCode,
        "city": city,
        "state": state,
        "internetPlan": internetPlan,
      };

  factory PersonalInformation.fromJson(Map<String, dynamic> json) {
    return PersonalInformation(
        json['deviceID'],
        json['firstName'],
        json['lastName'],
        json['street'],
        json['postalCode'],
        json['city'],
        json['state'],
        "");
  }
}

//The animation going across the screen when a test is implemented
class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int timerValid = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Running a test!'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            const Text("Please wait while we run your test!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Center(child: Image.asset("assets/hillfarmer.gif")),
          ])),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NavBarPrimary(),
    );
  }
}

class NavBarPrimary extends StatefulWidget {
  const NavBarPrimary({Key? key}) : super(key: key);

  @override
  State<NavBarPrimary> createState() => _NavBarPrimaryState();
}

class _NavBarPrimaryState extends State<NavBarPrimary> {
  int _selectedIndex = 0;

  var buttonList = <Widget>[];

  _NavBarPrimaryState() {
    buttonList = <Widget>[
      HomePage(onPressed),
      RunTest(onPressed),
      const Results(),
      const Settings()
    ];
  }

  void onPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: buttonList[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration_sharp),
            label: 'Run Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_backup_restore_rounded),
            label: 'Past Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey[700],
        selectedItemColor: Colors.green[700],
        onTap: onPressed,
      ),
    );
  }
}
