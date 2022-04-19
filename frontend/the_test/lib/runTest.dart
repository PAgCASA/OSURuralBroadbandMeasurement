import 'dart:async';

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
  final Function tabCallback;

  const RunTest(this.tabCallback, {Key? key}) : super(key: key);

  @override
  State<RunTest> createState() => _RunTestState(tabCallback);
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

  bool testRunning = false;

  //trackers for UDP
  int packetsSent = 0;
  int packetsReceived = 1;
  int errorPackets = 0;

  //function to call if we want to switch tabs
  Function tabCallback;

  _RunTestState(this.tabCallback);

  bool haveData() {
    return downloadSpeed != -1 ||
        uploadSpeed != -1 ||
        latency != -1 ||
        jitter != -1 ||
        packetLoss != -1;
  }

  //Upload incoming json encoded data
  uploadTest(BuildContext context, var incomingMap) async {
    //create a POST request and anticipate a json object
    var response = await http.post(Uri.parse(Constants.SERVER_UPLOAD_URL_TEXT),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: incomingMap);
    //store the body in a variable
    var holder = response.body;

    //TODO increase error checking
    print('This is the response from the server: $holder');

    var snackText = '';
    if (holder.contains("OK") && response.statusCode == HttpStatus.ok){
      snackText = "Successfully sent test to server";
    } else {
      snackText = "Could not submit test, error code: ${response.statusCode}";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackText),
      ),
    );
  }

  void createSocketAndTest(BuildContext context) async {
    phone_ID = await utils.getDeviceID();
    test_ID = utils.getTestID(phone_ID);

    // start running the test
    setState(() {
      testRunning = true;
    });

    //get latency (var is updated within the function so no need to set)
    await getLatency();

    await getPacketLoss();

    var downloadUploadTargets = await getTargets();
    downloadSpeed = await doDownloadTest(downloadUploadTargets);
    uploadSpeed = await doUploadTest(downloadUploadTargets);

    //we are now done running the test so update appropriately
    setState(() {
      testRunning = false;
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
    uploadTest(context, jsonToServer);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
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
              testRunning ? getAnimation() : getMap(),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: (Colors.brown[800])!, width: 7),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(10))),
                  padding: const EdgeInsets.all(10),
                  child: haveData()
                      ? DataTable(
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
                    rows: <DataRow?>[
                      downloadSpeed != -1
                          ? DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Download Speed')),
                          DataCell(Text('$downloadSpeed')),
                        ],
                      )
                          : null,
                      uploadSpeed != -1
                          ? DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Upload Speed')),
                          DataCell(Text('$uploadSpeed')),
                        ],
                      )
                          : null,
                      jitter != -1
                          ? DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Jitter')),
                          DataCell(Text('$jitter')),
                        ],
                      )
                          : null,
                      latency != -1
                          ? DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Latency')),
                          DataCell(Text('$latency')),
                        ],
                      )
                          : null,
                      packetLoss != -1
                          ? DataRow(
                        cells: <DataCell>[
                          const DataCell(Text('Packet Loss')),
                          DataCell(Text('$packetLoss')),
                        ],
                      )
                          : null,
                    ].whereType<DataRow>().toList(),
                  )
                      : const Text("Results will appear here"),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: getActionButton(context, testRunning, haveData()),
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
      setState(() {
        downloadSpeed = utils.bitsPerSecToMegaBitsPerSec(element.bps);
      });
    });

    print("Starting download test");
    var finalStatus = await dc.startTest();


    //just for testing
    //await Future.delayed(const Duration(seconds: 3));
    //var finalStatus = NDT.TestStatus(done: true, bps: 100000);

    return utils.bitsPerSecToMegaBitsPerSec(finalStatus.bps);
  }

  Future<double> doUploadTest(List<NDT.Target> targets) async {
    //TODO add this once I get it working
    return 5.8;
  }

  Container getMap() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(color: (Colors.red[800])!, width: 7),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(15.0),
        height: 250.0,
        width: 350.0,
        child: const Text('The map will go here when we have an api key'));
  }

  Container getAnimation() {
    return Container(
      height: 250.0,
      width: 350.0,
      // color: Colors.grey[400],
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/hillfarmer.gif"),
          )),
    );
  }

  //TODO figure out why this isn't updating properly
  FloatingActionButton getActionButton(BuildContext context, bool running,
      bool haveData) {
    if (running) {
      return FloatingActionButton.extended(
        onPressed: () {
          //TODO actually cancel test
          print("TESTING");
        },
        label: const Text("Cancel Test"),
        icon: const Icon(Icons.cancel),
      );
    } else if (haveData) {
      return FloatingActionButton.extended(
          onPressed: () {
            print("Switching to results page");
            tabCallback(2); //switch to results page
          },
          label: const Text("See all results"));
    } else {
      return FloatingActionButton.extended(
        onPressed: () async {
          phone_ID = await utils.getDeviceID();
          test_ID = utils.getTestID(phone_ID);
          createSocketAndTest(context);

          /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoadingScreen()),
            );*/
        },
        backgroundColor: Colors.red[500],
        label: const Text('Begin Test'),
        icon: const Icon(Icons.compass_calibration_sharp),
      );
    }
  }

  Future getLatency() async {
    int lowestPing = Constants.MAX_INITIAL_PING;
    List<Future> futuresToResolve = [];

    for (int i = 0; i < Constants.PING_SERVER_LIST.length; i++) {
      var serverString = Constants.PING_SERVER_LIST[i];
      // print('this is the server string $serverString');
      final ping = Ping(serverString,
          count: Constants.NUMBER_OF_PINGS_TO_SEND_INITIAL);

      var future = ping.stream.forEach((element) {
        var pt = element.response?.time?.inMilliseconds ??
            Constants.MAX_INITIAL_PING;

        // if it's faster, update UI
        if (pt < lowestPing) {
          lowestPing = pt;
          setState(() {
            latency = pt;
          });
        }
      });

      futuresToResolve.add(future);
    }

    await Future.wait(futuresToResolve);
  }

  Future getPacketLoss() async {
    var destination = Endpoint.unicast(InternetAddress(Constants.BACKEND_SERVER), port: const Port(8372));

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));

    //generate 16 char random id
    var id = utils.getRandomString(16);
    const packetsToSend = 100;

    for(int i = 0; i < packetsToSend; i++){
      await sender.send(id.codeUnits, destination);
    }

    sender.close();

    var resp = await http.delete(Uri.parse("http://${Constants.BACKEND_SERVER}:8080/api/v0/udpTest/$id"));
    var received = int.tryParse(resp.body) ?? 0;
    setState(() {
      packetLoss = ((received/packetsToSend) * 100).toInt();
    });
  }
}
