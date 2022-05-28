import 'dart:async';

import 'package:flutter/material.dart';
import 'package:the_test/utils.dart' as utils;
import 'package:udp/udp.dart';
import 'connectionScreens.dart';
import 'constants.dart' as Constants;
import 'connectionScreens.dart' as Screens;
import 'package:dart_ping/dart_ping.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:ndt_7_dart/exports.dart' as NDT;
import 'main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';

const position =
    CameraPosition(target: LatLng(37.444444, -122.431297), zoom: 11.5);

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
    if (holder.contains("OK") && response.statusCode == HttpStatus.ok) {
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
    await getLatencyAndJitter();

    if (!testRunning) {
      return;
    }

    await getPacketLoss();

    if (!testRunning) {
      return;
    }

    var downloadUploadTargets = await getTargets();
    downloadSpeed = await doDownloadTest(downloadUploadTargets);

    if (!testRunning) {
      return;
    }

    uploadSpeed = await doUploadTest(downloadUploadTargets);

    if (!testRunning) {
      return;
    }

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

  // var geoLocator = GeoLocator();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  // position =
  // CameraPosition(target: LatLng(37.444444, -122.431297), zoom: 11.5);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('This is the value of the hold $width');

    double height = MediaQuery.of(context).size.height;
    print('This is the value of the hold $width');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test Start a Test'),
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
        child: ListView(
          // shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [
            SizedBox(height: height * Constants.SPACER_BOX_HEIGHT),
            testRunning ? getAnimation(height, width) : getMap(height, width),
            SizedBox(height: height * Constants.SPACER_BOX_HEIGHT),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: (Colors.brown[800])!, width: 7),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                                    DataCell(
                                        Text(downloadSpeed.toStringAsFixed(2))),
                                  ],
                                )
                              : null,
                          uploadSpeed != -1
                              ? DataRow(
                                  cells: <DataCell>[
                                    const DataCell(Text('Upload Speed')),
                                    DataCell(
                                        Text(uploadSpeed.toStringAsFixed(2))),
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
                                    DataCell(Text('$packetLoss%')),
                                  ],
                                )
                              : null,
                        ].whereType<DataRow>().toList(),
                      )
                    : const Text("Results will appear here"),
              ),
            ),
            SizedBox(height: height * Constants.SPACER_BOX_HEIGHT),
          ],
        ),
      ),
      floatingActionButton: getActionButton(context, testRunning, haveData()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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

    return utils.bitsPerSecToMegaBitsPerSec(finalStatus.bps);
  }

  Future<double> doUploadTest(List<NDT.Target> targets) async {
    var uploadLocation = targets[0].URLs['ws:///ndt/v7/upload'] ?? "";
    var uc = NDT.UploadTest(uploadLocation);

    uc.outputStream.forEach((element) {
      print("upload-${element.bps * 8 / 1000 / 1000}mbps-${element.done}");
      setState(() {
        uploadSpeed = utils.bitsPerSecToMegaBitsPerSec(element.bps);
      });
    });

    print("Starting upload test");
    var finalStatus = await uc.startTest();

    return utils.bitsPerSecToMegaBitsPerSec(finalStatus.bps);
  }

  Container getMap(double height, double width) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.orange,
            border: Border.all(color: (Colors.brown[800])!, width: 7),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        padding: const EdgeInsets.all(15.0),
        height: height * .3,
        width: width * .8,

        //    CameraPosition(target: LatLng(37.444444, -122.431297), zoom: 11.5);

        // Position bob = 1;

        child: const GoogleMap(
          initialCameraPosition: position,
          myLocationButtonEnabled: false,
        ));
  }

  //
  // Future<Container> getMap(double height, double width) async {
  //
  //
  //   var position1 = await _determinePosition();
  //
  //   var positionHold = CameraPosition(target: LatLng(position1.latitude, position1.longitude), zoom: 11.5);
  //
  //   return Container(
  //       decoration: BoxDecoration(
  //           color: Colors.orange,
  //           border: Border.all(color: (Colors.brown[800])!, width: 7),
  //           borderRadius: const BorderRadius.all(Radius.circular(10))),
  //       padding: const EdgeInsets.all(15.0),
  //       height: height * .3,
  //       width: width * .8,
  //
  //       //    CameraPosition(target: LatLng(37.444444, -122.431297), zoom: 11.5);
  //
  //
  //     // Position bob = 1;
  //
  //       child: GoogleMap(
  //         initialCameraPosition: positionHold,
  //         myLocationButtonEnabled: false,
  //       ));
  // }

  Container getAnimation(double height, double width) {
    return Container(
      height: height * .4,
      width: width * .8,
      // color: Colors.grey[400],
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/hillfarmer.gif"),
      )),
    );
  }

  FloatingActionButton getActionButton(
      BuildContext context, bool running, bool haveData) {
    if (running) {
      return FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            testRunning = false;
            tabCallback(1);
          });
        },
        label: const Text("Cancel Test"),
        icon: const Icon(Icons.cancel),
      );
    } else if (haveData) {
      return FloatingActionButton.extended(
          foregroundColor: Colors.black,
          backgroundColor: Colors.green,
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

  Future getLatencyAndJitter() async {
    List<int> allPings = [];

    int lowestPing = Constants.MAX_INITIAL_PING;
    List<Future> futuresToResolve = [];

    for (int i = 0; i < Constants.PING_SERVER_LIST.length; i++) {
      var serverString = Constants.PING_SERVER_LIST[i];
      // print('this is the server string $serverString');
      final ping =
          Ping(serverString, count: Constants.NUMBER_OF_PINGS_TO_SEND_INITIAL);

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

        if (pt != Constants.MAX_INITIAL_PING) {
          allPings.add(pt);
        }
      });

      futuresToResolve.add(future);
    }

    await Future.wait(futuresToResolve);

    // callculate average Instantaneous packet delay variation
    if (allPings.length > 1) {
      List<int> PDV = [];
      for (int i = 1; i < allPings.length; i++) {
        int IPDV = (allPings[i] - allPings[i - 1]).abs();
        PDV.add(IPDV);
      }
      setState(() {
        jitter = (PDV.reduce((v1, v2) => v1 + v2) / PDV.length).round();
      });
    }
  }

  Future getPacketLoss() async {
    var destination = Endpoint.unicast(
        InternetAddress(Constants.BACKEND_SERVER),
        port: const Port(8372));

    var sender = await UDP.bind(Endpoint.any(port: const Port(65000)));

    //generate 16 char random id
    var id = utils.getRandomString(16);
    const packetsToSend = 100;

    for (int i = 0; i < packetsToSend; i++) {
      await sender.send(id.codeUnits, destination);
      //exit if test canceled
      if (!testRunning) {
        return;
      }
    }

    sender.close();

    var resp = await http.delete(Uri.parse(
        "http://${Constants.BACKEND_SERVER}:8080/api/v0/udpTest/$id"));
    var received = int.tryParse(resp.body) ?? 0;
    setState(() {
      packetLoss = ((received / packetsToSend) * 100).toInt();
    });
  }

  //See if phone is connected to cellular data, wifi, or neither
  Future<int> checkConnectivityState() async {
    int validConnection = 0;
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      validConnection = 1;
      print('Connected to a Wi-Fi network');
    } else if (result == ConnectivityResult.mobile) {
      validConnection = 2;
      print('Connected to a mobile network');
    } else {
      validConnection = 3;
      print('Not connected to any network');
    }

    return validConnection;
  }

  Future<bool> goodConnectionToStartTest() async {
    var connectionCode = await checkConnectivityState();

    // if we are connected to wifi, proceed normally
    if (connectionCode == 1) {
      return true;
    }

    //if we are connected to mobile data, the user will have to turn it off to proceed
    else if (connectionCode == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Screens.MobileConnectionScreen()),
      );
    }
    //if we don't have a connection, they will need to connect to a network
    else if (connectionCode == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const Screens.NoConnectionScreen()),
      );
    } else {
      print(
          "something went wrong with the connectivity method, here is the value of the connection $connectionCode");
    }

    return false;
  }
}
