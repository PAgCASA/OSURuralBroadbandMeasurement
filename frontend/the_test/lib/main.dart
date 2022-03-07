import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'constants.dart' as Constants;
import 'package:dart_ping/dart_ping.dart';
import 'package:device_info/device_info.dart';
import 'package:udp/udp.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';



void main() => runApp( MyApp());





class TestResult{
  //object fields for future JSON
  String phone_ID;
  int test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;

  //constructor for object
  TestResult(this.phone_ID, this.test_ID, this.downloadSpeed, this.uploadSpeed, this.latency, this.jitter, this.packetLoss);

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
}

class PersonalInformation{
  //object fields for future JSON
  String firstName;
  String lastName;
  String street;
  String postalCode;
  String city;
  String state;
  String internetPlan;

  //constructor for object
  PersonalInformation(this.firstName, this.lastName, this.street, this.postalCode, this.city, this.state, this.internetPlan);


  //JSON conversion method
  Map toJSON() => {
    "firstName": firstName ,
    "lastName": lastName,
    "street": street,
    "postalCode": postalCode,
    "city": city,
    "state": state,
    "internetPlan": internetPlan,
  };
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
      title: const Text('PAgCASA Speed Test Application'),
      centerTitle: true,
      backgroundColor: Colors.green[700],
    ),

    body : Column(
        children: <Widget>[
          Center(
            child: Text('Extremely brief description of organization')
          ),
       Container(
          margin: const EdgeInsets.all(10.0),
          color: Colors.grey[600],
          width: 350.0,
          height: 300.0,
         child: Text('Insert PAgCASA related image or video')
        ),
          Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.indigo,
              width: 300.0,
              height: 100.0,
              child: Text('Insert background information? Statistics on rural broadband coverage? Examples of federal fund misuse?')
          ),

          //  floatingActionButton: FloatingActionButton.extended(
          //   //TODO change the index selector
          //   onPressed: () {},
          //   label: Text('Start Test'),
          //   icon: Icon(Icons.compass_calibration_sharp),
          // ),
       // Container(
       //       margin: const EdgeInsets.all(10.0),
       //       color: Colors.yellow[600],
       //       width: 200.0,
       //       height: 50.0,
       //   child: Text('About Us'),
       //     ),
          ElevatedButton(
            onPressed: (){},
            child: Text('About Us'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),

          ),
          ElevatedButton(
              onPressed: (){},
              child: Text('Start a Test!'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),

          )

      ]
    )
  );
}




class Results extends StatelessWidget {


  fetchData(String testID) async{

    final client = HttpClient();
    var response = await client.get(Constants.SERVER_RESULT_REQUEST_URL, Constants.SERVER_PORT, testID);
  }

  Future retrieveDataManager(String id) async{
    await fetchData(id);
  }




  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Results'),
      centerTitle: true,
      backgroundColor: Colors.green[700],
    ),
    // body: buildTable()
    body: Center(
      child: Container(
        color: Colors.white,
        height: 130,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: buildTable(),
          )
        ),
      ),
    ),
  );
  Widget buildTable(){
    final columns = Constants.COLUMN_TITLES_RESULTS;
    Future results = retrieveDataManager('');
    return DataTable(
      columns: getColumns(columns),
      rows: const <DataRow>[
        //TODO connect with server here for row data
        DataRow(
          cells: <DataCell>[
            DataCell(Text('2-11-2022 15:03:07')),
            // DataCell(Text(results.time)),
            DataCell(Text('23.5Mbps')),
            // DataCell(Text('results.downloadSpeed')),
            DataCell(Text('3.4Mbps')),
            // DataCell(Text('results.uploadSpeed')),
            DataCell(Text('4')),
            // DataCell(Text('results.jitter')),
            DataCell(Text('12ms')),
            // DataCell(Text('results.latency')),
            DataCell(Text('3%')),
            // DataCell(Text('results.packetloss')),
            DataCell(Text('12.33s')),
            // DataCell(Text('results.duration')),
          ],
        ),
      ],
    );
  }
  List<DataColumn> getColumns(List<String> columns) => columns.map((String column) => DataColumn(label: Text(column))).toList();
  //TODO finish implementing this using guide when incoming json -> object method is completed
  // List<DataRow> getRows(List<Test> users) => users.map((Test users) => DataColumn(label: Text(column))).toList();
}






class Settings extends StatefulWidget {
  // Settings({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      // body: SettingsList(
      //   sections: [
      //     SettingsSection(
      //       title: Text('Section 1'),
      //       tiles: [
      //         SettingsTile(
      //           title: Text('Language'),
      //           leading: Icon(Icons.language),
      //           onPressed: (BuildContext context) {},
      //         ),
      //         SettingsTile.switchTile(
      //           title: 'Use System Theme',
      //           leading: Icon(Icons.phone_android),
      //           initia: isSwitched,
      //           onToggle: (value) {
      //             setState(() {
      //               isSwitched = value;
      //             });
      //           },
      //         ),
      //       ],
      //     ),
      //     SettingsSection(
      //       titlePadding: EdgeInsets.all(20),
      //       title: 'Section 2',
      //       tiles: [
      //         SettingsTile(
      //           title: 'Security',
      //           subtitle: 'Fingerprint',
      //           leading: Icon(Icons.lock),
      //           onPressed: (BuildContext context) {},
      //         ),
      //         SettingsTile.switchTile(
      //           title: 'Use fingerprint',
      //           leading: Icon(Icons.fingerprint),
      //           switchValue: true,
      //           onToggle: (value) {},
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
    );
  }
}
// class Settings extends StatelessWidget {
//   //https://pub.dev/packages/settings_ui
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: const Text('Settings'),
//       centerTitle: true,
//       backgroundColor: Colors.green[700],
//     ),
//     SettingsList(
//       sections: [
//         SettingsSection(
//           title: Text('Common'),
//           tiles: <SettingsTile>[
//             SettingsTile.navigation(
//               leading: Icon(Icons.language),
//               title: Text('Language'),
//               value: Text('English'),
//             ),
//             SettingsTile.switchTile(
//               onToggle: (value) {},
//               initialValue: true,
//               leading: Icon(Icons.format_paint),
//               title: Text('Enable custom theme'),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }








class RunTest extends StatefulWidget {

  @override
  State<RunTest> createState() => _RunTestState();
}

class _RunTestState extends State<RunTest> {

  //initialize holder variables for storing results from each of the sections
  String phone_ID = 'holder';
  int test_ID = 0;
  double downloadSpeed = 0;
  double uploadSpeed= 0;
  int latency= 0;
  int jitter= 0;
  int packetLoss= 0;


  //trackers for UDP
  int packetsSent = 0;
  int packetsRecieved = 0;
  int errorPackets = 0;




  Future<void> assignDeviceInfo() async{
    //**********************************************************PHONE ID SECTION
    //uses discontinued library https://pub.dev/packages/device_info
    //TODO look into another device ID finding library as this one is out of date
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phone_ID = androidInfo.androidId.toString();
    }
    //TODO use a different identifier for iphones as there is no build in method for the library
    else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phone_ID = iosInfo.identifierForVendor.toString();
    }
    else {
      print('error detecting device type');
    }
    print("This is the phone ID $phone_ID");
    //**************************************************************************
  }



  void getTestID(){
    //TODO get the test ID via the server
    //initially stick with UUID -> server later on
    Random testRand = new Random();
    int testIDGenerate = testRand.nextInt(1000000000);
    print("Test ID is $testIDGenerate");
    test_ID = testIDGenerate;
  }


  //establish packet loss, jitter
  void performUDP() async{
    var sender = await UDP.bind(Endpoint.any(port: Port(Constants.SENDER_PORT)));

    // send a simple string to a broadcast endpoint on port 65001.
    var dataLength = await sender.send(
        Constants.DATA.codeUnits, Endpoint.broadcast(port: Port(Constants.SERVER_PORT)));
    packetsSent += 1;

    print('${dataLength} bytes sent.');

    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    var receiver = await UDP.bind(Endpoint.loopback(port: Port(Constants.RECIEVER_PORT)));

    // receiving\listening
    receiver.asStream(timeout: Duration(seconds: Constants.ACCEPTED_RESPONSE_WINDOW)).listen((datagram) {
      var str = String.fromCharCodes(datagram!.data);
      if (str == Constants.DATA){
        packetsRecieved += 1;
      }
      else{
        errorPackets += 1;
      }
    });

    // close the UDP instances and their sockets.
    sender.close();
    receiver.close();

    packetLoss = (packetsSent / packetsRecieved).floor();
  }

  getUpload(String Source) async{
    final client = HttpClient();
    final request = await client.post(Source, Constants.SERVER_PORT, Constants.DATA);
    request.headers.set(HttpHeaders.contentTypeHeader, "plain/text"); // or headers.add()
    final response = await request.close();
  }

  getDownload(String Source) async{
      final request = await HttpClient().getUrl(Uri.parse('http://example.com'));
      final response = await request.close();
  }


  calcDownloadandUpload(String Source) async{
    int initialtimeDownload = DateTime.now().millisecondsSinceEpoch;
    await getDownload(Source);
    int finaltimeDownload = DateTime.now().millisecondsSinceEpoch;


    int initialtimeUpload = DateTime.now().millisecondsSinceEpoch;
    await getUpload(Source);
    int finaltimeUpload = DateTime.now().millisecondsSinceEpoch;


    downloadSpeed = finaltimeDownload.toDouble() - initialtimeDownload.toDouble();
    uploadSpeed = finaltimeUpload.toDouble() - initialtimeUpload.toDouble();

  }


  uploadTest(String incomingMap){
    final client = HttpClient();
    client.post(Constants.SERVER_TEST_UPLOAD_URL, Constants.SERVER_PORT, incomingMap);
  }






  void createSocketAndTest(){
    //TODO make stateful implementation for displaying these results




    //socket initialization
    print("Socket initialized.");
    //TODO this cannot be asychronous as the time will not be accurate
    Socket.connect(Constants.SERVER_IP, Constants.PORT).then((socket) {
      print("we have connected");
      print('Connected to: ' '${socket.remoteAddress.address}:${socket
          .remotePort}');




      //*****************************************************************LATENCY
      //
      //integers to keep track of the beginning and end of the time in the event
      int timeIndexHolderBegin;
      int timeIndexHolderEnd;

      //holders for the entire event as a string, and the substring containing the time
      String eventStringHolder;
      String timeStringExtracted;
      String serverString = 'SERVER PLACEHOLDER';

      //start with the lowest ping of zero
      int lowestPing = Constants.MAX_INITIAL_PING;

      for (int i = 0; i < Constants.NUMBER_OF_SERVERS; i++) {
        serverString = Constants.SERVER_IP_LIST[i];
        print('this is the server string $serverString');
        final ping = Ping(serverString,
            count: Constants.NUMBER_OF_PINGS_TO_SEND_INITIAL);
        //TODO make this a broadcast stream
        ping.stream.listen((event) {
          print("below is the result of the ping");
          print(event.toString());
          eventStringHolder = event.toString();
          timeIndexHolderBegin = eventStringHolder.indexOf('time: ');
          timeIndexHolderEnd = eventStringHolder.indexOf(' ms,');
          // print('this is the index of the time $timeIndexHolderBegin');
          // print('this is the index of the end of the time $timeIndexHolderEnd');
          // 6 away from begin, 1 behind end
          timeStringExtracted = eventStringHolder.substring(
              (timeIndexHolderBegin + 6), (timeIndexHolderEnd));
          print('this is the time for the ping:  $timeStringExtracted');
          if (int.parse(timeStringExtracted) < lowestPing) {
            lowestPing = int.parse(timeStringExtracted);
          }
        });
      }
      print('The selected server is $serverString with $lowestPing ms ping.');
      latency = lowestPing;
      //************************************************************************

      calcDownloadandUpload(serverString);

      //******************************************************************JITTER
      //TODO make sequence number generator(8 byte), timestamp(8 byte), data condenser
      setState(() {
        jitter = 79;
      });
      //************************************************************************

      //*************************************************************PACKET LOSS
      setState(() {
        packetLoss;
      });
      //************************************************************************

      //*****************************************************************LATENCY
      setState(() {
        latency;
      });
      //************************************************************************

      setState(() {
        downloadSpeed = 9.4;
      });

      setState(() {
        uploadSpeed = 3.4;
      });

      socket.destroy();
    });


    if(phone_ID != 'holder' && test_ID!= 0 && downloadSpeed != 0 && uploadSpeed != 0 && latency != 0 && jitter != 0 && packetLoss != 0){
      TestResult(phone_ID, test_ID, downloadSpeed, uploadSpeed, latency, jitter, packetLoss);
      String encoded = json.encode(TestResult);
      uploadTest(encoded);
    }



  }



  @override
  Widget build(BuildContext context) => Scaffold(

    appBar: AppBar(
      title: const Text('Run a Test'),
      centerTitle: true,
      backgroundColor: Colors.green[700],
    ),
    body:
    Column(
      children: <Widget>[
        Container(
            height: 250.0,
            width: 350.0,
            color: Colors.yellow,
            child: Text('The map will go here')
        ),


        Center(
          child: DataTable(
            columns: <DataColumn>[
              DataColumn(

                label: Text(
                  'Metric',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),

              DataColumn(
                label: Text(
                  'Result',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],

            // rows:  ['2-11-2022 15:03:07','23.5Mbps','3.4Mbps','4','12ms','3%','12.33s'],
            rows: <DataRow>[
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Download Speed')),
                  DataCell(Text('$downloadSpeed')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Upload Speed')),
                  DataCell(Text('$uploadSpeed')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Jitter')),
                  DataCell(Text('$jitter')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Latency')),
                  DataCell(Text('$latency')),
                ],
              ),
              DataRow(
                cells: <DataCell>[
                  DataCell(Text('Packet Loss')),
                  DataCell(Text('$packetLoss')),
                ],
              ),
            ],

          ),
        )
      ],
    ),



    floatingActionButton: FloatingActionButton.extended(
      onPressed: (){
        assignDeviceInfo();
        createSocketAndTest();
      },

      // onPressed: () => (createSocketAndTest()),
      label: Text('Begin Test'),
      icon: Icon(Icons.compass_calibration_sharp),

    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
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


  final buttonList = <Widget>[HomePage(), RunTest(), Results(), Settings() ];

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
            icon: Icon(Icons.settings),
            label: 'Settings',
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


