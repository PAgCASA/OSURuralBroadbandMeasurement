import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'constants.dart' as Constants;
import 'package:dart_ping/dart_ping.dart';
import 'package:device_info/device_info.dart';
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
    return DataTable(
      columns: getColumns(columns),
      // rows:  ['2-11-2022 15:03:07','23.5Mbps','3.4Mbps','4','12ms','3%','12.33s'],
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('2-11-2022 15:03:07')),
            DataCell(Text('23.5Mbps')),
            DataCell(Text('3.4Mbps')),
            DataCell(Text('4')),
            DataCell(Text('12ms')),
            DataCell(Text('3%')),
            DataCell(Text('12.33s')),
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








class RunTest extends StatelessWidget {

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
      columns: const <DataColumn>[
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
      rows: const <DataRow>[
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Download Speed')),
            DataCell(Text('23.5Mbps')),

            // DataCell(Text('4')),
            // DataCell(Text('12ms')),
            // DataCell(Text('3%')),
            // DataCell(Text('12.33s')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Upload Speed')),
            DataCell(Text('3.4Mbps')),

            // DataCell(Text('4')),
            // DataCell(Text('12ms')),
            // DataCell(Text('3%')),
            // DataCell(Text('12.33s')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Jitter')),
            DataCell(Text('4')),

            // DataCell(Text('4')),
            // DataCell(Text('12ms')),
            // DataCell(Text('3%')),
            // DataCell(Text('12.33s')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Latency')),
            DataCell(Text('12ms')),
            // DataCell(Text('4')),
            // DataCell(Text('12ms')),
            // DataCell(Text('3%')),
            // DataCell(Text('12.33s')),
          ],
        ),
        DataRow(
          cells: <DataCell>[
            DataCell(Text('Packet Loss')),
            DataCell(Text('3%')),
            // DataCell(Text('4')),
            // DataCell(Text('12ms')),
            // DataCell(Text('3%')),
            // DataCell(Text('12.33s')),
          ],
        ),
      ],

     ),
    )
      ],
    ),



    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {},
      label: Text('Begin Test'),
      icon: Icon(Icons.compass_calibration_sharp),

    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );

  Future<void> createSocketAndTest() async {
    //TODO make stateful implementation for displaying these results


    //initialize holder variables for storing results from each of the sections
    String phone_ID = 'holder';
    int test_ID;
    double downloadSpeed;
    double uploadSpeed;
    int latency;
    int jitter;
    int packetLoss;


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


    //**********************************************************TEST ID SECTION
    //TODO get the test ID via the server
    //initially stick with UUID -> server later on
    Random testRand = new Random();
    int testIDGenerate = testRand.nextInt(1000000000);
    print("Test ID is $testIDGenerate");
    test_ID = testIDGenerate;

    //**************** *********************************************************


    //socket initialization
    print("Socket initialized.");
    //TODO this cannot be asychronous as the time will not be accurate
    Socket.connect(Constants.SERVER_IP, Constants.PORT).then((socket) async {
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
      //************************************************************************


      //**********************************************************DOWNLOAD SPEED
      //TODO find an extremely precise timer library
      //stick closer to NDT-7 mlab suite

      //initiallize the http client
      // var client = HttpClient();
      // // start timer request the first data chunk
      // HttpClientRequest request1 = await client.get(Constants.SERVER_IP, Constants.PORT, Constants.FILE_PATH1);
      //
      // //stop timer and close the client
      // request1.close();
      //************************************************************************


      //************************************************************UPLOAD SPEED
      //TODO same thing as download but reversed
      //************************************************************************


      //******************************************************************JITTER
      //TODO make sequence number generator(8 byte), timestamp(8 byte), data condenser

      int packetsSent = 0;
      int packetsRecieved = 0;
      var data = Constants.DATA;
      var codec = new Utf8Codec();
      String addressToListen = serverString;
      List<int> dataSendStream = codec.encode(data);
      RawDatagramSocket.bind(Constants.SERVER_IP, Constants.PORT).then((
          RawDatagramSocket udpSocket) {
        udpSocket.forEach((RawSocketEvent event) {
          // udpSocket.send(null,Constants.SERVER_IP,null )
          packetsSent += 1;
          if (event == RawSocketEvent.read) {
            packetsRecieved += 1;
            // Datagram dg = udpSocket.receive().noSuchMethod;
            // dg.data.forEach((x) => print(x));
          }
        });
      });
      //************************************************************************


      //*************************************************************PACKET LOSS
      packetLoss = (packetsSent / packetsRecieved).floor();
      //************************************************************************


      //*****************************************************************LATENCY
      latency = lowestPing;
      //************************************************************************


      socket.destroy();
    });
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
        selectedItemColor: Colors.green[700],
        onTap: onPressed,
      ),
    );
  }
}


//
// void main() => runApp(MyApp());
//
// class TestResult{
//   //object fields for future JSON
//   String phone_ID;
//   int test_ID;
//   double downloadSpeed;
//   double uploadSpeed;
//   int latency;
//   int jitter;
//   int packetLoss;
//
//   //constructor for object
//   TestResult(this.phone_ID, this.test_ID, this.downloadSpeed, this.uploadSpeed, this.latency, this.jitter, this.packetLoss);
//
//   //JSON conversion method
//   Map toJSON() => {
//       "phoneID": phone_ID,
//       "testID": test_ID,
//       "downloadSpeed": downloadSpeed,
//       "uploadSpeed": uploadSpeed,
//       "latency": latency,
//       "jitter": jitter,
//       "packetLoss": packetLoss,
//   };
// }
//
// class PersonalInformation{
//   //object fields for future JSON
//   String firstName;
//   String lastName;
//   String street;
//   String postalCode;
//   String city;
//   String state;
//   String internetPlan;
//
//   //constructor for object
//   PersonalInformation(this.firstName, this.lastName, this.street, this.postalCode, this.city, this.state, this.internetPlan);
//
//
//   //JSON conversion method
//   Map toJSON() => {
//     "firstName": firstName ,
//     "lastName": lastName,
//     "street": street,
//     "postalCode": postalCode,
//     "city": city,
//     "state": state,
//     "internetPlan": internetPlan,
//   };
//
// }
//
//
// class MyApp extends StatelessWidget {
//
//   Future<void> createSocketAndTest() async {
//     //TODO change this entire class to a stateful one
//
//
//     //initialize holder variables for storing results from each of the sections
//     //TODO change all nums to ints
//     String phone_ID = 'holder';
//     int test_ID;
//     double downloadSpeed;
//     double uploadSpeed;
//     int latency;
//     int jitter;
//     int packetLoss;
//
//
//     //**********************************************************PHONE ID SECTION
//     //uses discontinued library https://pub.dev/packages/device_info
//     //TODO look into another device ID finding library as this one is out of date
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//
//     if (Platform.isAndroid) {
//       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       phone_ID = androidInfo.androidId.toString();
//     }
//     //TODO use a different identifier for iphones as there is no build in method for the library
//     else if (Platform.isIOS) {
//       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       phone_ID = iosInfo.identifierForVendor.toString();
//     }
//     else {
//       print('error detecting device type');
//     }
//     print("This is the phone ID $phone_ID");
//     //**************************************************************************
//
//
//     //**********************************************************TEST ID SECTION
//     //TODO get the test ID via the server
//     //initially stick with UUID -> server later on
//     Random testRand = new Random();
//     int testIDGenerate = testRand.nextInt(1000000000);
//     print("Test ID is $testIDGenerate");
//     test_ID = testIDGenerate;
//
//     //**************** *********************************************************
//
//
//     //socket initialization
//     print("Socket initialized.");
//     //TODO this cannot be asychronous as the time will not be accurate
//     Socket.connect(Constants.SERVER_IP, Constants.PORT).then((socket) async {
//       print("we have connected");
//       print('Connected to: ' '${socket.remoteAddress.address}:${socket
//           .remotePort}');
//
//
//       //*****************************************************************LATENCY
//       //
//       //integers to keep track of the beginning and end of the time in the event
//       int timeIndexHolderBegin;
//       int timeIndexHolderEnd;
//
//       //holders for the entire event as a string, and the substring containing the time
//       String eventStringHolder;
//       String timeStringExtracted;
//       String serverString = 'SERVER PLACEHOLDER';
//
//
//       //start with the lowest ping of zero
//       int lowestPing = Constants.MAX_INITIAL_PING;
//
//       for (int i = 0; i < Constants.NUMBER_OF_SERVERS; i++) {
//         serverString = Constants.SERVER_IP_LIST[i];
//         print('this is the server string $serverString');
//         final ping = Ping(serverString,
//             count: Constants.NUMBER_OF_PINGS_TO_SEND_INITIAL);
//         //TODO make this a broadcast stream
//         ping.stream.listen((event) {
//           print("below is the result of the ping");
//           print(event.toString());
//           eventStringHolder = event.toString();
//           timeIndexHolderBegin = eventStringHolder.indexOf('time: ');
//           timeIndexHolderEnd = eventStringHolder.indexOf(' ms,');
//           // print('this is the index of the time $timeIndexHolderBegin');
//           // print('this is the index of the end of the time $timeIndexHolderEnd');
//           // 6 away from begin, 1 behind end
//           timeStringExtracted = eventStringHolder.substring(
//               (timeIndexHolderBegin + 6), (timeIndexHolderEnd));
//           print('this is the time for the ping:  $timeStringExtracted');
//           if (int.parse(timeStringExtracted) < lowestPing) {
//             lowestPing = int.parse(timeStringExtracted);
//           }
//         });
//       }
//       print('The selected server is $serverString with $lowestPing ms ping.');
//       //************************************************************************
//
//
//       //**********************************************************DOWNLOAD SPEED
//       //TODO find an extremely precise timer library
//       //stick closer to NDT-7 mlab suite
//
//       //initiallize the http client
//       // var client = HttpClient();
//       // // start timer request the first data chunk
//       // HttpClientRequest request1 = await client.get(Constants.SERVER_IP, Constants.PORT, Constants.FILE_PATH1);
//       //
//       // //stop timer and close the client
//       // request1.close();
//       //************************************************************************
//
//
//       //************************************************************UPLOAD SPEED
//       //TODO same thing as download but reversed
//       //************************************************************************
//
//
//       //******************************************************************JITTER
//       //TODO make sequence number generator(8 byte), timestamp(8 byte), data condenser
//
//       var data = Constants.DATA;
//       var codec = new Utf8Codec();
//       String addressToListen = serverString;
//       List<int> dataSendStream = codec.encode(data);
//       RawDatagramSocket.bind(Constants.SERVER_IP, Constants.PORT).then((
//           RawDatagramSocket udpSocket) {
//         udpSocket.forEach((RawSocketEvent event) {
//           if (event == RawSocketEvent.read) {
//             // Datagram dg = udpSocket.receive().noSuchMethod;
//             // dg.data.forEach((x) => print(x));
//           }
//           // udpSocket.send(dataSendStream,  )
//         });
//       });
//       //************************************************************************
//
//
//       //*************************************************************PACKET LOSS
//       //
//       //************************************************************************
//
//
//       //*****************************************************************LATENCY
//       //
//       //************************************************************************
//
//
//       socket.destroy();
//     });
//   }
// //
//
//     @override
//     Widget build(BuildContext context) {
//       return MaterialApp(
//         home: Scaffold(
//             appBar: AppBar(
//               title: Text('PAgCASA Speed Test App'),
//             ),
//             body: Column(
//               children: [
//                 ElevatedButton(child: Text('Start The Test'),
//                     onPressed: createSocketAndTest),
//                 ElevatedButton(child: Text('Test1'),
//                     onPressed: createSocketAndTest),
//               ],
//             )
//         ),
//       );
//     }
//   }
//
//
//
// class Button2 extends StatelessWidget {
//
// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     home: Scaffold(
//         appBar: AppBar(
//           title: Text('PAgCASA Speed Test App'),
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(child: Text('Start The Test'),
//                 onPressed: (){
//
//                 },
//             ),
//             ElevatedButton(child: Text('Test1'),
//                 onPressed: () {
//
//                 },
//             )
//           ],
//         )
//     ),
//   );
// }
// }


