import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:the_test/runTest.dart';
import 'package:the_test/utils.dart' as utils;
import 'constants.dart' as Constants;
import 'package:dart_ping/dart_ping.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'package:udp/udp.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

// import 'package:ndt_7_dart/src/download.dart';
// import 'package:ndt_7_dart/src/locator.dart';
// import 'package:ndt_7_dart/src/upload.dart';

void main() => runApp(MyApp());

class TestResult {
  //object fields for future JSON
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

  // List<String> returnVals(TestResult Result){
  //   List<String> toReturn;
  //   for(int i = 0; i < 7; i++){
  //     toReturn[i] = Result[i];
  //   }
  // }

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

class incomingTestResult {
  String date;
  String duration;
  String phone_ID;
  String test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;

  factory incomingTestResult.fromJson(Map<String, dynamic> json) {
    return incomingTestResult(
        date: json['Date'],
        duration: json['Duration'],
        phone_ID: json['PhoneID'],
        test_ID: json['TestID'],
        downloadSpeed: json['DownloadSpeed'] + 0.0,
        uploadSpeed: json['UploadSpeed'] + 0.0,
        latency: json['Latency'] as int,
        jitter: json['Jitter'] as int,
        packetLoss: json['PacketLoss'] as int);
  }

  incomingTestResult(
      {required this.duration,
      required this.date,
      required this.phone_ID,
      required this.test_ID,
      required this.downloadSpeed,
      required this.uploadSpeed,
      required this.latency,
      required this.jitter,
      required this.packetLoss});

// factory fromJSON(dynamic json) => {
//   incomingTestResult hold;
//   return incomingTestResult;
// };
}

class PersonalInformation {
  //object fields for future JSON
  String firstName;
  String lastName;
  String street;
  String postalCode;
  String city;
  String state;
  String internetPlan;

  //constructor for object
  //passcode for protecting data
  PersonalInformation(this.firstName, this.lastName, this.street, this.postalCode, this.city, this.state, this.internetPlan);

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

class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: new ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: new Text(
                        '1. You may begin a test by hitting the wifi icon.  \n  2. You can view your results by hitting the clock icon.  \n 3.  You may alter your account information settings by hitting the person icon.')
                )
              ]),
        ),
      );
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Running a test!'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            // color: Colors.grey[400],
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/hillfarmer.gif"),
            )),
          ),
        ),
      ));
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Homepage'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: new ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: new Text(
                        'PAgCASA is all about fairness and bringing the internet to those who are disadvantaged because of their location.  By using this application, you will improve the lives of your neighbors and yourself.  \n\n\n\n '))
              ]),
        ),
      );
}

//TODO pass in the phone ID for all incoming results, parse results by the test duration
//incoming results array parse through type PastResults struct {
//     PhoneID string
//     lastUpdated time.Time
//     results []SpeedTestResult
// }
//use this URL /api/v0/getSpeedTestResults/:id replace ":id" with the phone id for GETTING
// us this /api/v0/submitSpeedTest for SUBMITTING(encode first)

//TODO about page and data upload page d

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test Homepage'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
          // color: Colors.grey[400],
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Center(),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: (Colors.brown[800])!, width: 7),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.all(10.0),
                // color: Colors.grey[600],
                width: 320.0,
                height: 515.0,
                child: Image(
                  image: AssetImage('assets/HomepageImage.jpg'),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: Text('About Us'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[500],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialScreen()),
                );
              },
              child: Text('Start a Test!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            )
          ])));
}

class Results extends StatefulWidget {
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  //future object for incoming data
  late Future<List<TestResult>> testsToDisplay;

  //get the test with the specified ID
  Future<List<TestResult>> fetchTests(Future<String> incomingID) async {
    //create the full url by appending ID to the base url stored in the constants file
    String fullURL = Constants.SERVER_RESULT_REQUEST_URL + await incomingID;

    //request the test at the full URL
    final response = await http.get(Uri.parse(fullURL));
    //if we recieved record with no error, print what we recieved
    if (response.statusCode == 200) {
      String body = response.body;
      print('This is what we received from the server \n\n  $body   \n\n');

      var json = jsonDecode(response.body);
      var rows = json['Results'];

      List<TestResult> results = List.empty(growable: true);

      if (rows != null) {
        // this is a really ugly way of looping through the results array and
        // turning them into test results
        for (var i = 0; i < (rows as List).length; i++) {
          var result = TestResult.fromJson(rows[i] as Map<String, dynamic>);
          results.insert(i, result);
        }
      }

      return results;
    } else {
      throw Exception('Failed to load record with id $incomingID ');
    }
  }

  //get the test with the specified ID first thing
  @override
  void initState() {
    super.initState();
    testsToDisplay = fetchTests(utils.getDeviceID());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Results'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        // body: buildTable()
        body: Container(
          // color: Colors.grey[400],
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),

          child: Center(
            child: Container(
              color: Colors.white,
              height: 500,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder<List<TestResult>>(
                          future: testsToDisplay,
                          builder: (context, snapshot) {
                            var data = snapshot.data;
                            if (snapshot.hasData && data != null) {
                              return buildTable(data);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          }))),
            ),
          ),
        ),
      );

  Widget buildTable(List<TestResult> results) {
    const columns = Constants.COLUMN_TITLES_RESULTS;
    return DataTable(
        columns: getColumns(columns),
        rows: results
            .map(
              (result) => DataRow(
                cells: <DataCell>[
                  DataCell(Text('TODO DATE')),
                  DataCell(Text(result.downloadSpeed.toString())),
                  DataCell(Text(result.uploadSpeed.toString())),
                  DataCell(Text(result.jitter.toString())),
                  DataCell(Text(result.latency.toString())),
                  DataCell(Text(result.packetLoss.toString())),
                  DataCell(Text("TODO DURATION")),
                ],
              ),
            )
            .toList());
  }

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String firstName = '-';
  String lastName = '-';
  String street = '-';
  String postalCode = '-';
  String city = '-';
  String state = '-';
  String internetPlan = '-';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Profile Settings'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
        height: 750,
        width: 450,
        // color: Colors.grey[400],
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/HomepageBackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            height: 60,
            width: 40,
            // decoration: BoxDecoration(
            //   color: Colors.white
            // ),
            child: Form(
                key: formKey,
                child: Container(
                    color: Colors.white,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                        'Please enter your personal information below.  All data is stored securely and will NEVER be sold or distributed.'),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Enter your first name"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Please enter a valid first name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Enter your last name"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Please enter a valid last name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Enter your street name"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Please enter a valid street name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Enter your postal code"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[0-9]+$').hasMatch(value)) {
                          return "Please enter a valid postal code";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Enter your city or town name"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Please enter a valid city or town name";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: "Enter your state"),
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Please enter a valid state name";
                        } else {
                          return null;
                        }
                      },
                    ),

                    // Use imagepicker for uploading image https://pub.dev/packages/image_picker/install
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            new PersonalInformation(firstName, lastName, street,
                                postalCode, city, state, internetPlan);
                            //TODO send this to the server
                          }
                        },
                        child: Text('Submit!'))
                  ],
                )))),
      ));
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

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // //TODO put these widgets in separate files

  final buttonList = <Widget>[HomePage(), RunTest(), Results(), Settings()];

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
