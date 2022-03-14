import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
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


void main() => runApp( MyApp());


class TestResult{
  //object fields for future JSON
  String phone_ID;
  String test_ID;
  double downloadSpeed;
  double uploadSpeed;
  int latency;
  int jitter;
  int packetLoss;

  //constructor for object
  TestResult({required this.phone_ID, required this.test_ID, required this.downloadSpeed, required this.uploadSpeed, required this.latency, required this.jitter, required this.packetLoss});

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

  factory TestResult.fromJson(Map<String, dynamic> json){
    return TestResult(phone_ID : json['PhoneID'], test_ID: json['TestID'], downloadSpeed : json['DownloadSpeed'] + 0.0, uploadSpeed : json['UploadSpeed'] + 0.0, latency : json['Latency'] as int, jitter : json['Jitter'] as int, packetLoss : json['PacketLoss'] as int);
  }
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
  Map<String, dynamic> toJSON() => {
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




class Results extends StatefulWidget {


  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {

  //future object for incoming data
  late Future<List<TestResult>> testsToDisplay;

  //get the test with the specified ID
  Future<List<TestResult>> fetchTests(Future<String> incomingID) async{
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

      if(rows != null) {
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
  void initState(){
    super.initState();
    testsToDisplay = fetchTests(utils.getDeviceID());
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


            child: FutureBuilder<List<TestResult>>(
              future: testsToDisplay,
              builder: (context, snapshot) {
                var data = snapshot.data;
                if(snapshot.hasData && data != null){
                  return buildTable(data);
                }
                //TODO how to reference this snapshot of type futurebuilder<TestResult>
                else if (snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }
            )



          )
        ),
      ),
    ),
  );

  Widget buildTable(List<TestResult> results){
    const columns = Constants.COLUMN_TITLES_RESULTS;
    return DataTable(
      columns: getColumns(columns),
      rows: results.map((result) => DataRow(
        cells: <DataCell>[
          DataCell(Text('TODO DATE')),
          DataCell(Text(result.downloadSpeed.toString())),
          DataCell(Text(result.uploadSpeed.toString())),
          DataCell(Text(result.jitter.toString())),
          DataCell(Text(result.latency.toString())),
          DataCell(Text(result.packetLoss.toString())),
          DataCell(Text("TODO DURATION")),
        ],
      ),).toList()
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns.map((String column) => DataColumn(label: Text(column))).toList();
}






class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Text("Nothing");
  }
}



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
  int packetLoss= -1;


  //trackers for UDP
  int packetsSent = 0;
  int packetsRecieved = 1;
  int errorPackets = 0;


  //establish packet loss, jitter
  void performUDP(String serverURL) async{
    var sender = await UDP.bind(Endpoint.any(port: Port(Constants.SENDER_PORT)));

    // send a simple string to a broadcast endpoint on port 65001.
    var dataLength = await sender.send(
        Constants.DATA.codeUnits, Endpoint.broadcast(port: Port(Constants.SERVER_PORT)));
        packetsSent += 1;

    // print('${dataLength} bytes sent.');

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
    // print('THIS IS THE  packets send $packetsSent and this is the pakcets recieved $packetsRecieved');

    if(packetsSent == 0 ){
      print('no packets sent');
      exit(1);
    }
    else{
      packetLoss = (packetsRecieved / packetsSent).toInt();
      // print('packet loss calculated as $packetLoss');
    }
  }

  getUpload(String Source) async{
    //TODO implement this when we have a server that will accept posts
    // print('THIS IS THE INCOMING S O U R C E for upload $Source ');
    // final client = HttpClient();
    // final request = await client.post(Source, Constants.SERVER_PORT, Constants.DATA);
    // request.headers.set(HttpHeaders.contentTypeHeader, "plain/text"); // or headers.add()
    // final response = await request.close();
    uploadSpeed = 7.4;
  }

  getDownload(String Source) async{
      final request = await HttpClient().getUrl(Uri.parse('http://example.com'));
      final response = await request.close();
  }


  calcDownloadandUpload(String Source) async{

    // print('CALC DOWNLOAD SPEED NOW ');

    int initialtimeDownload = DateTime.now().millisecondsSinceEpoch;
    await getDownload(Source);
    int finaltimeDownload = DateTime.now().millisecondsSinceEpoch;
    // print('CALC DOWNLOAD SPEED NOW 2 ');
    //
    //
    // print('this is value of the final time $finaltimeDownload and this is the initial time $initialtimeDownload');
    downloadSpeed = finaltimeDownload.toDouble() - initialtimeDownload.toDouble();


    int initialtimeUpload = DateTime.now().millisecondsSinceEpoch;
    await getUpload(Source);
    int finaltimeUpload = DateTime.now().millisecondsSinceEpoch;
    // print('CALC DOWNLOAD SPEED NOW 3');


    uploadSpeed = finaltimeUpload.toDouble() - initialtimeUpload.toDouble();

    // print('this is value of download $downloadSpeed and this is val of upload $uploadSpeed');

  }






  //Upload incoming json encoded data
  uploadTest(var incomingMap) async{
    //create a POST request and anticipate a json object
    var response = await http.post(
        Uri.parse(Constants.SERVER_UPLOAD_URL_TEXT),
        headers:{ "Content-Type":"application/json; charset=UTF-8" } ,
        body: incomingMap
    );
    //store the body in a variable
    var holder = response.body;

    //print the server response from upload
    print('\n This is the response from the server: $holder\n');
  }


















  void createSocketAndTest() async{
    //create a test object for demo purposes as async functions are currengly generating faulty values
    var demoTest = TestResult(
        phone_ID: await utils.getDeviceID(),
        test_ID: '155',
        downloadSpeed: 24.3,
        uploadSpeed: 5.1,
        latency: 63,
        jitter: 22,
        packetLoss: 4
    );


    //socket initialization
    // print("Socket initialized.");
    Socket.connect(Constants.SERVER_IP, Constants.PORT).then((socket) {
      // print("we have connected");
      // print('Connected to: ' '${socket.remoteAddress.address}:${socket
      //     .remotePort}');

      //*****************************************************************LATENCY
      //
      //integers to keep track of the beginning and end of the time in the event
      int timeIndexHolderBegin = -10;
      int timeIndexHolderEnd = -10;

      //holders for the entire event as a string, and the substring containing the time
      String eventStringHolder;
      String timeStringExtracted;
      String serverString = 'SERVER PLACEHOLDER';

      //start with the lowest ping of zero
      int lowestPing = 99;
      // Constants.MAX_INITIAL_PING;


      for (int i = 0; i < Constants.NUMBER_OF_SERVERS; i++) {
        serverString = Constants.SERVER_IP_LIST[i];
        // print('this is the server string $serverString');
        final ping = Ping(serverString,
            count: Constants.NUMBER_OF_PINGS_TO_SEND_INITIAL);
        //TODO make this a broadcast stream
        ping.stream.listen((event) {
          // print("below is the result of the ping");
          // print(event.toString());
          eventStringHolder = event.toString();
          int len = eventStringHolder.length;
          // print('here is the event in string form: $eventStringHolder and here is the len $len');
          timeIndexHolderBegin = eventStringHolder.indexOf('time:');
          timeIndexHolderEnd = eventStringHolder.indexOf(' ms');
          // print('this is the index of the time $timeIndexHolderBegin');
          // print('this is the index of the end of the time $timeIndexHolderEnd');
          // 6 away from begin, 1 behind end
          timeStringExtracted = eventStringHolder.substring(
              (timeIndexHolderBegin + 5), (timeIndexHolderEnd));
          // print('this is the time for the ping:  $timeStringExtracted');
          var intermediateDouble = double.parse(timeStringExtracted);
          int finalPing = intermediateDouble.toInt();
          // print('the ping in integer form is now $finalPing');
          if (finalPing < lowestPing && finalPing != 0) {
            // print('FINAL WAS LESS THAN LOWEST and final is $finalPing and lowest is $lowestPing');
            lowestPing = finalPing;
          }
        });
      }
      // print('The selected server is --------------  $serverString with --------------- $lowestPing ms ping.');
      latency = lowestPing;
      //************************************************************************

      // print('EXECUTING  down and udp');
      calcDownloadandUpload(serverString);
      // print('done with down');
      // performUDP(serverString);
      // print('done with up');

      //******************************************************************JITTER
      //TODO make sequence number generator(8 byte), timestamp(8 byte), data condenser
      setState(() {
        jitter = 22;
      });
      //************************************************************************

      //*************************************************************PACKET LOSS
      setState(() {
        packetLoss = 4;
      });
      //************************************************************************

      //*****************************************************************LATENCY
      setState(() {
        latency = 63;
      });
      //************************************************************************

      setState(() {
        downloadSpeed = 24.3;
      });

      setState(() {
        uploadSpeed = 5.1;
      });

      socket.destroy();
    });







    // print('this is phone id : $phone_ID , this is test ID : $test_ID , this is download speed : $downloadSpeed, this is upload speed : $uploadSpeed, this is latency : $latency , this is jitter : $jitter, and this is packetLoss : $packetLoss ');
    //
    // if(phone_ID != 'holder' && test_ID== 155 && downloadSpeed != 0 && uploadSpeed != 0 && latency != 0 && jitter != 0){
    //   print('this is phone id : $phone_ID , this is test ID : $test_ID , this is download speed : $downloadSpeed, this is upload speed : $uploadSpeed, this is latency : $latency , this is jitter : $jitter, and this is packetLoss : $packetLoss ');
    //   var theTest = new TestResult(phone_ID: phone_ID, test_ID: test_ID, downloadSpeed: downloadSpeed, uploadSpeed: uploadSpeed, latency: latency, jitter: jitter, packetLoss: packetLoss );
    //    print('attempting to encode');
    //   print('FOR ENCODING this is phone id : $phone_ID , this is test ID : $test_ID , this is download speed : $downloadSpeed, this is upload speed : $uploadSpeed, this is latency : $latency , this is jitter : $jitter, and this is packetLoss : $packetLoss ');
    //    String encoded = jsonEncode(theTest);
    //    print('attempting to upload! ^^^^^^^^^^^^^^^^^^^^^^');
    //    uploadTest(encoded);
    // }





    //encode the created object using defaults
    var holder = jsonEncode(demoTest.toJSON());
    print('We are now uploading the following data to the server \n\n $holder   \n\n');
    //upload the encoded message
    uploadTest(holder);
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
      onPressed: () async {
        phone_ID = await utils.getDeviceID();
        test_ID = utils.getTestID();
        createSocketAndTest();
      },

      // onPressed: () => (createSocketAndTest()),
      label: const Text('Begin Test'),
      icon: const Icon(Icons.compass_calibration_sharp),

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


