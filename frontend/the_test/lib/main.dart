import 'package:flutter/material.dart';
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
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'dart:math';

//flip x y axis on chart

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

//The tutorial screen
//Accessed when pressing "start a test" on main screen
class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: Container(
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "The Precision Ag Connectivity & Accuracy Stakeholder Alliance (PAgCASA) is a not-for-profit education foundation whose mission is to design, field test, and deploy technical and policy tools needed to ensure accurate broadband mapping and deployment across America to ignite smart agriculture and rural prosperity. \n\nConsistent with the Broadband DATA Act of 2020 and the recent findings of the FCC's Precision Ag Task Force, PAgCASA aims to drive transparent broadband mapping methodology specific to rural America by establishing a standards-based, open source toolkit for collecting accurate, granular, crowdsourced, and citizen-centric data. \n\nAccurate broadband maps are essential to inform wise infrastructure investments and effective broadband deployment for communities still left behind. ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                  child: Text("Go Back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                  ),
                )
              ]),
        ),
      );
}

//About us screen
//Accessed when hitting "about us" from the main screen
class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Homepage'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: Container(
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "Please read this brief tutorial on how to use our applicatiion \n\n1. You may begin a test by navigating to the \"run a test\" page.  Press the wifi icon on the bottom bar to reach this page. \n\n2. You will be greeted by a screen displaying your current approximate location and an empty field where the test results will appear.  Begin a test by hitting the red \"Begin Test\" button on the bottom bar.\n\n3. After the test is complete, results will be displayed and recorded.  You may now view your previous test history by navigating to the \"Results\" page.  You can navigate to this page by hitting the rewinding clock icon on the bottom bar.  \n\n4.  Finally, we ask that you upload some personal information to help us accomplish our goals.  You may view and modify this information by navigating to the \"Profile Settings\" page.  You may navigate to this page by hitting the person icon on the bottom bar. \n\nFor additional support, please email holder@holder.com or contact us at 111-222-3333.  Thank you! ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                  child: Text("Start Testing!"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                  ),
                )
              ]),
        ),
      );
}

class MobileConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: Container(
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "It appears that you are connected to a mobile network.  Please turn off your mobile data and connect to your wireless network to proceed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => MobileConnectionScreen()),
                    );
                  },
                  child: Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                  ),
                )
              ]),
        ),
      );
}

class NoConnectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: [
                Center(
                    child: Container(
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "It appears that you do not have network connectivity..  Please turn off your mobile data and connect to your wireless network to proceed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => NoConnectionScreen()),
                    );
                  },
                  child: Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                  ),
                )
              ]),
        ),
      );
}



class dataUploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('PAgCASA: Speed Test Homepage'),
      centerTitle: true,
      backgroundColor: Colors.lightGreen[700],
    ),
    body: Center(
      child: ListView(
        // shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            Center(
                child: Container(
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                        "Thank you for uploading your personal data!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => dataUploadScreen()),
                );
              },
              child: Text("Go back"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[500],
              ),
            )
          ]),
    ),
  );
}

// class CountDownPage extends StatefulWidget {
//   CountDownPage({Key ?key}) : super(key: key);
//
//   @override
//   _CountDownPageState createState() => _CountDownPageState();
// }
//
// class _CountDownPageState extends State<CountDownPage> {
//   int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 3;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("count down"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CountdownTimer(
//                     endTime: endTime,
//                     widgetBuilder: (_, CurrentRemainingTime time) {
//                       if (time == null) {
//                         WidgetsBinding.instance?.addPostFrameCallback((_) {
//                           Navigator.of(context).pop();
//                         });
//                         return Container();
//                       } else {
//                         return Text(
//                             '${(time.hours == null) ? "00" : time.hours}:${(time.min == null) ? "00" : time.min}:${(time.sec == null) ? "00" : time.sec}');
//                       }
//                     })),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Container(
                child: Text("Please wait while we run your test!",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            SizedBox(height: 10),
            Center(child: Image.asset("assets/hillfarmer.gif")),
          ])),
    );
  }
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
                width: 319.0,
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
                primary: Colors.green[500],
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
      // print('This is what we received from the server \n\n  $body   \n\n');

      var json = jsonDecode(response.body);
      var rows = json['Results'];
      // print('\n\n\n\n this is the incoming rows $rows \n\n\n\n\n\n');
      List<incomingTestResult> results = List.empty(growable: true);

      if (rows != null) {
        // this is a really ugly way of looping through the results array and
        // turning them into test results
        for (var i = 0; i < (rows as List).length; i++) {
          var result =
              incomingTestResult.fromJson(rows[i] as Map<String, dynamic>);
          results.insert(i, result);
          // print("$results");
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
        columnSpacing: 10,
        columns: getColumns(columns),
        rows:
        results
            .map(
              (result) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(getDateFormat(result.date))),
                  DataCell(Text(result.downloadSpeed.toString())),
                  DataCell(Text(result.uploadSpeed.toString())),
                  DataCell(Text(result.jitter.toString())),
                  DataCell(Text(result.latency.toString())),
                  DataCell(Text(result.packetLoss.toString())),
                ],
              ),
            )
            .toList());
  }

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();
  String getDateFormat(String data) {
    var date = DateTime.parse(data).toLocal();
    return "${date.day}-${date.month}-${date.year-2000} ${date.hour}:"
        "${date.minute.toString().length == 1 ?
            "0"+ date.minute.toString() : date.minute.toString()}";
  }
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
              children: [Center(child: new Text('PAg4 hold \n '))]),
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
    print('sending data to server ');

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
      decoration: InputDecoration(labelText: "Enter your first name"
      ),
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

        decoration: InputDecoration(labelText: "Enter your state" ),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid state name";
          } else {
            state = value;
          }
        });
  }

  Future _buildImageGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final imageHold = File(image.path);
    this.image = imageHold;
    return null;
  }

  Future _buildImageCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    final imageHold = File(image.path);
    this.image = imageHold;
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Upload Profile Information'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
       body:Form(
                  key: formKey,
                  child: Container(
                      color: Colors.yellow[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          Text(
                              'Please enter your personal information below.  All data is stored securely and will NEVER be sold or distributed.',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text('Upload an image of your internet bill from Gallery'),
                              onPressed: () {
                                _buildImageGallery();
                                if (image != null) {
                                  List<int> imageBytes =
                                      image!.readAsBytesSync();
                                  String base64Image =
                                      base64.encode(imageBytes);
                                  internetPlan = base64Image;
                                } else {
                                  print('Something is wrong with the image');
                                }
                              }),
                          SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text('Upload an image of your internet bill from Camera'),
                              onPressed: () {
                                _buildImageCamera();
                                if (image != null) {
                                  List<int> imageBytes =
                                      image!.readAsBytesSync();
                                  String base64Image =
                                      base64.encode(imageBytes);
                                  internetPlan = base64Image;
                                } else {
                                  print(
                                      'Something is wrong with the image from the camera');
                                }
                              }),
                          SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                final isValid =
                                    formKey.currentState?.validate();
                                if (formKey.currentState!.validate()) {
                                  PersonalInformation person =
                                       PersonalInformation(
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
                                  uploadPersonalInfo(person.toJSON());
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => dataUploadScreen()),
                                  );
                                }
                              },
                              child: Text('Submit!'))
                        ],
                      ))));
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
