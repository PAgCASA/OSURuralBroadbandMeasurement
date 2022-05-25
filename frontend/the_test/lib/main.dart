import 'package:flutter/material.dart';
import 'package:the_test/personalInfoScreen.dart';
import 'package:the_test/resultsScreen.dart';
import 'package:the_test/runTest.dart';
import 'homeScreen.dart';

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

  //constructor for object
  TestResult(
      {required this.phone_ID,
      required this.test_ID,
      required this.downloadSpeed,
      required this.uploadSpeed,
      required this.latency,
      required this.jitter,
      required this.packetLoss});

  //JSON conversion method
  Map toJSON() => {
        "phoneID": phone_ID,
        "testID": test_ID,
        "downloadSpeed": downloadSpeed,
        "uploadSpeed": uploadSpeed,
        "latency": latency,
        "jitter": jitter,
        "packetLoss": packetLoss,
      };

  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
        phone_ID: json['PhoneID'],
        test_ID: json['TestID'],
        downloadSpeed: json['DownloadSpeed'] + 0.0,
        uploadSpeed: json['UploadSpeed'] + 0.0,
        latency: json['Latency'] as int,
        jitter: json['Jitter'] as int,
        packetLoss: json['PacketLoss'] as int);
  }
}

//Class for test result to be displayed
class incomingTestResult {
  String date;
  String phone_ID;
  String test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;

  incomingTestResult({
    required this.phone_ID,
    required this.test_ID,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.latency,
    required this.jitter,
    required this.packetLoss,
    required this.date,
  });

  factory incomingTestResult.fromJson(Map<String, dynamic> json) {
    return incomingTestResult(
      phone_ID: json['PhoneID'],
      test_ID: json['TestID'],
      downloadSpeed: json['DownloadSpeed'] + 0.0,
      uploadSpeed: json['UploadSpeed'] + 0.0,
      latency: json['Latency'] as int,
      jitter: json['Jitter'] as int,
      packetLoss: json['PacketLoss'] as int,
      date: json['TestStartTime'],
    );
  }
}

//Class for sending personal information to the backend
//TODO consider implementing passcode for security
class PersonalInformation {
  //object fields
  String firstName;
  String lastName;
  String street;
  String postalCode;
  String city;
  String state;
  String internetPlan;

  PersonalInformation(this.firstName, this.lastName, this.street,
      this.postalCode, this.city, this.state, this.internetPlan);

  //JSON conversion method
  Map<String, dynamic> toJSON() => {
        "firstName": firstName,
        "lastName": lastName,
        "street": street,
        "postalCode": postalCode,
        "city": city,
        "state": state,
        "internetPlan": internetPlan,
      };
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
                style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
    buttonList = <Widget>[const HomePage(), RunTest(onPressed), const Results(), const Settings()];
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
