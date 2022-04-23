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
import 'package:image_picker/image_picker.dart';
import 'dart:math';


// import 'package:ndt_7_dart/src/download.dart';
// import 'package:ndt_7_dart/src/locator.dart';
// import 'package:ndt_7_dart/src/upload.dart';

void main() => runApp(MyApp());

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
  String duration;
  String phone_ID;
  String test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;

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

//The tutorial screen
//Accessed when pressing "start a test" on main screen
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
                        '1. You may begin a test by hitting the wifi icon.  \n  2. You can view your results by hitting the clock icon.  \n 3.  You may alter your account information settings by hitting the person icon.'))
              ]),
        ),
      );
}

//About us screen
//Accessed when hitting "about us" from the main screen
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

//The animation going across the screen when a test is implemented
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

//TODO pass in the phone ID for all incoming results, parse results by the test duration
//incoming results array parse through type PastResults struct {
//     PhoneID string
//     lastUpdated time.Time
//     results []SpeedTestResult
// }
//use this URL /api/v0/getSpeedTestResults/:id replace ":id" with the phone id for GETTING
// us this /api/v0/submitSpeedTest for SUBMITTING(encode first)

//TODO about page and data upload page d

//Homepage, the main page for the app
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

//Page for displaying past results
class Results extends StatefulWidget {
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  //future object for incoming data
  late Future<List<incomingTestResult>> testsToDisplay;

  //get the test with the specified ID
  Future<List<incomingTestResult>> fetchTests(Future<String> incomingID) async {
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

      List<incomingTestResult> results = List.empty(growable: true);

      if (rows != null) {
        // this is a really ugly way of looping through the results array and
        // turning them into test results
        for (var i = 0; i < (rows as List).length; i++) {
          var result =
              incomingTestResult.fromJson(rows[i] as Map<String, dynamic>);
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
                      child: FutureBuilder<List<incomingTestResult>>(
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

  Widget buildTable(List<incomingTestResult> results) {
    const columns = Constants.COLUMN_TITLES_RESULTS;
    return DataTable(
        columns: getColumns(columns),
        rows: results
            .map(
              (result) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(result.date.toString())),
                  DataCell(Text(result.downloadSpeed.toString())),
                  DataCell(Text(result.uploadSpeed.toString())),
                  DataCell(Text(result.jitter.toString())),
                  DataCell(Text(result.latency.toString())),
                  DataCell(Text(result.packetLoss.toString())),
                  DataCell(Text(result.duration.toString())),
                ],
              ),
            )
            .toList());
  }

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();
}




class personalInfoFormSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('PAgCASA: Submit Personal Information'),
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
                    'PAg4 hold \n '))
          ]),
    ),
  );
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

  String _firstName = '-';
  String _lastName = '-';
  String _street = '-';
  String _postalCode = '-';
  String _city = '-';
  String _state = '-';
  String _internetPlan = '-';

  //this will store the image in cache
  File? image = null;

  final formKey = GlobalKey<FormState>();

  //Upload incoming json encoded data
  uploadPersonalInfo(var incomingMap) async {
    //create a POST request and anticipate a json object
    var response =
        await http.post(Uri.parse(Constants.PERSONAL_INFO_UPLOAD_URL),
            //    headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: incomingMap);
    //store the body in a variable
    var holder = response.body;
    print('sending data to server hopefully ');

    //TODO increase error checking
    //check to ensure the server gave us a response
    if (holder == null) {
      print(
          "there was a problem connecting with the server.  Please try again");
    } else if (holder == "200 Error") {
    } else {
      //print the server response from upload
      print(
          '\n This is the response from the server for personal info uploading: $holder\n');
    }
  }

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Enter your first name"),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
          return "Please enter a valid first name";
        } else {
          firstName = value;
        }
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your last name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid last name";
          } else {
            lastName = value;
          }
        });
  }

  Widget _buildStreetName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Enter your street name"),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
          return "Please enter a valid last name";
        } else {
          street = value;
        }
      },
    );
  }

  Widget _buildPostal() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your postal code"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return "Please enter a valid postal code";
          } else {
            postalCode = value;
          }
        });
  }

  Widget _buildTown() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your city or town name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid city or town name";
          } else {
            city = value;
          }
        });
  }

  Widget _buildState() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your state"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid state name";
          } else {
            state = value;
          }
        });
  }

  Future _buildImageGallery() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null){
      return null;
    }
    final imageHold = File(image.path);
    this.image = imageHold;
    return null;
  }

  Future _buildImageCamera() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image == null){
      return null;
    }
    final imageHold = File(image.path);
    this.image = imageHold;
    return null;
  }

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
                        _buildFirstName(),
                        SizedBox(height: 10),
                        _buildLastName(),
                        SizedBox(height: 10),
                        _buildStreetName(),
                        SizedBox(height: 10),
                        _buildPostal(),
                        SizedBox(height: 10),
                        _buildTown(),
                        SizedBox(height: 10),
                        _buildState(),
                        // Use imagepicker for uploading image https://pub.dev/packages/image_picker/install
                        SizedBox(height: 10),
                        ElevatedButton(
                            child: Text('gallery'),
                            onPressed: () {
                              _buildImageGallery();
                              if(image != null){
                                List<int> imageBytes = image!.readAsBytesSync();
                                String base64Image = base64.encode(imageBytes);
                                internetPlan = base64Image;
                              }
                              else{
                                print('Something is wrong with the image');
                              }

                            }),
                        SizedBox(height: 10),
                        ElevatedButton(
                            child: Text('camera'),
                            onPressed: () {
                              _buildImageCamera();
                              if(image != null){
                                List<int> imageBytes = image!.readAsBytesSync();
                                String base64Image = base64.encode(imageBytes);
                                internetPlan = base64Image;
                              }
                              else{
                                print('Something is wrong with the image from the camera');
                              }
                            }),
                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              final isValid = formKey.currentState?.validate();
                              if (formKey.currentState!.validate()) {
                                PersonalInformation person =
                                    new PersonalInformation(
                                        firstName,
                                        lastName,
                                        street,
                                        postalCode,
                                        city,
                                        state,
                                        internetPlan);
                                //
                                print('sending data to method ');
                                print('this is the image $image ');
                                // uploadPersonalInfo(person.toJSON());
                              }
                            },
                            child: Text('Submit!'))
                      ],
                    )))
        ),
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
