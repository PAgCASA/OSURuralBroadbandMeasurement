import 'package:flutter/material.dart';
import 'package:the_test/utils.dart' as utils;
import 'constants.dart' as Constants;
import 'package:dart_ping/dart_ping.dart';
import 'package:http/http.dart' as http;
import 'package:udp/udp.dart';
import 'dart:io';
import 'dart:convert';
import 'package:ndt_7_dart/exports.dart' as NDT;

import 'main.dart';

class RunTest extends StatefulWidget {
  @override
  State<RunTest> createState() => _RunTestState();
}

class _RunTestState extends State<RunTest> {
  //initialize holder variables for storing results from each of the sections
  String phone_ID = '';
  int test_ID = -1;
  double downloadSpeed = -1;
  double uploadSpeed = -1;
  int latency = -1;
  int jitter = -1;
  int packetLoss = -1;

  //trackers for UDP
  int packetsSent = 0;
  int packetsReceived = 1;
  int errorPackets = 0;

  //establish packet loss, jitter
  void performUDP(String serverURL) async {
    var sender =
        await UDP.bind(Endpoint.any(port: const Port(Constants.SENDER_PORT)));

    // send a simple string to a broadcast endpoint on port 65001.
    var dataLength = await sender.send(Constants.DATA.codeUnits,
        Endpoint.broadcast(port: const Port(Constants.SERVER_PORT)));
    packetsSent += 1;

    // print('${dataLength} bytes sent.');

    // creates a new UDP instance and binds it to the local address and the port
    // 65002.
    var receiver = await UDP
        .bind(Endpoint.loopback(port: const Port(Constants.RECIEVER_PORT)));

    // receiving\listening
    receiver
        .asStream(
            timeout:
                const Duration(seconds: Constants.ACCEPTED_RESPONSE_WINDOW))
        .listen((datagram) {
      var str = String.fromCharCodes(datagram!.data);
      if (str == Constants.DATA) {
        packetsReceived += 1;
      } else {
        errorPackets += 1;
      }
    });

    // close the UDP instances and their sockets.
    sender.close();
    receiver.close();
    // print('THIS IS THE  packets send $packetsSent and this is the pakcets recieved $packetsRecieved');

    if (packetsSent == 0) {
      print('no packets sent');
      exit(1);
    } else {
      packetLoss = (packetsReceived / packetsSent).toInt();
      // print('packet loss calculated as $packetLoss');
    }
  }

  //Upload incoming json encoded data
  uploadTest(var incomingMap) async {
    //create a POST request and anticipate a json object
    var response = await http.post(Uri.parse(Constants.SERVER_UPLOAD_URL_TEXT),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: incomingMap);
    //store the body in a variable
    var holder = response.body;

    //TODO increase error checking
    //check to ensure the server gave us a response
    if (holder == null) {
      print(
          "there was a problem connecting with the server.  Please try again");
    } else if (holder == "200 Error") {
    } else {
      //print the server response from upload
      print('\n This is the response from the server: $holder\n');
    }
  }

  void DownloadAndUploadSpeed() {}

  void calcLatencyUDPPacketLoss(String desiredServer) {}

  void createSocketAndTest() async {
    phone_ID = await utils.getDeviceID();
    test_ID = utils.getTestID(phone_ID);

    //socket initialization
    // print("Socket initialized.");
    await Socket.connect(Constants.SERVER_IP, Constants.PORT).then((socket) {
      // print("we have connected");
      // print('Connected to: ' '${socket.remoteAddress.address}:${socket
      //     .remotePort}');

      //*****************************************************************LATENCY
      //
      //integers to keep track of the beginning and end of the time in the event
      //
      int timeIndexHolderBegin = -10;
      int timeIndexHolderEnd = -10;

      //holders for the entire event as a string, and the substring containing the time
      String eventStringHolder;
      String timeStringExtracted;
      String serverString = 'SERVER PLACEHOLDER';

      //start with the lowest ping of zero
      int lowestPing = 0;
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
      setState(() {
        latency = lowestPing;
      });

      //************************************************************************

      //******************************************************************JITTER
      //TODO make sequence number generator(8 byte), timestamp(8 byte), data condenser
      //datetime class
      //sequence generator incrment by one up to max packets to send

      setState(() {
        jitter = 22;
      });
      //************************************************************************

      //*************************************************************PACKET LOSS
      setState(() {
        packetLoss = 4;
      });
      //************************************************************************

      socket.destroy();
    });

    var downloadUploadTargets = await getTargets();
    setState(() async {
      downloadSpeed = await doDownloadTest(downloadUploadTargets);
      uploadSpeed = await doUploadTest(downloadUploadTargets);
    });

    //take all the global vars and put them in the object so it can be sent to the server
    var testResults = TestResult(
        phone_ID: phone_ID,
        test_ID: test_ID.toString(),
        downloadSpeed: downloadSpeed,
        uploadSpeed: uploadSpeed,
        latency: latency,
        jitter: jitter,
        packetLoss: packetLoss);
    //encode the created object using defaults
    var jsonToServer = jsonEncode(testResults.toJSON());
    print('We are now uploading the following '
        'data to the server \n\n $jsonToServer\n\n');
    //upload the encoded message
    uploadTest(jsonToServer);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Run a Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Container(
          // color: Colors.grey[400],
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: (Colors.red[800])!, width: 7),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(15.0),
                  height: 250.0,
                  width: 350.0,
                  child: const Text(
                      'The map will go here when we have an api key')),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: (Colors.brown[800])!, width: 7),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(10),
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
                          const DataCell(Text('Download Speed')),
                          DataCell(Text('$downloadSpeed')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Upload Speed')),
                          DataCell(Text('$uploadSpeed')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Jitter')),
                          DataCell(Text('$jitter')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Latency')),
                          DataCell(Text('$latency')),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Packet Loss')),
                          DataCell(Text('$packetLoss')),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            phone_ID = await utils.getDeviceID();
            test_ID = utils.getTestID(phone_ID);
            createSocketAndTest();

            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoadingScreen()),
            );*/
          },
          backgroundColor: Colors.red[500],
          label: const Text('Begin Test'),
          icon: const Icon(Icons.compass_calibration_sharp),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );

  Future<List<NDT.Target>> getTargets() async {
    var locator = NDT.Client.newClient("PAgCASA-Flutter-App");
    var targets = await locator.nearest("ndt/ndt7");

    return targets;
  }

  Future<double> doDownloadTest(List<NDT.Target> targets) async {
    var downloadLocation = targets[0].URLs['ws:///ndt/v7/download'] ?? "";
    var dc = NDT.DownloadTest(downloadLocation);

    dc.outputStream.forEach((element) {
      print("download-${element.bps * 8 / 1000 / 1000}mbps-${element.done}");
    });

    print("Starting download test");
    var finalStatus = await dc.startTest();

    return utils.bitsPerSecToMegaBitsPerSec(finalStatus.bps);
  }

  Future<double> doUploadTest(List<NDT.Target> targets) async {
    //TODO add this once I get it working
    return 0;
  }
}
