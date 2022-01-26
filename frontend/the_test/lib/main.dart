import 'package:flutter/material.dart';
import 'constants.dart' as Constants;
import 'package:dart_ping/dart_ping.dart';
import 'package:device_info/device_info.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';

void main() => runApp(MyApp());

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


class MyApp extends StatelessWidget {

  Future<void> createSocketAndTest() async {
    //TODO confirm format of OBJECT/JSON config -> keep as int
    //TODO discuss UUID for each test
    //TODO get IP of a single server containing a file for testing
    //TODO change this entire class to a stateful one


    //initialize holder variables for storing results from each of the sections
    //TODO change all nums to ints
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

    if(Platform.isAndroid){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      phone_ID = androidInfo.androidId.toString();
    }
    //TODO use a different identifier for iphones as there is no build in method for the library
    else if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      phone_ID = iosInfo.identifierForVendor.toString();
    }
    else{
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
      print('Connected to: ' '${socket.remoteAddress.address}:${socket.remotePort}');









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

      for(int i = 0; i < Constants.NUMBER_OF_SERVERS; i++) {
        //TODO iterate through the server list using the loop
        //serverString = serverlist[i];
        final ping = Ping(Constants.SERVER_IP,
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
      //TODO
      /*
      To measure Jitter, we take the difference between samples, then divide by the number of samples (minus 1).

Here's an example. We have collected 5 samples with the following latencies: 136, 184, 115, 148, 125 (in that order). The average latency is 142 - (add them, divide by 5). The 'Jitter' is calculated by taking the difference between samples.

136 to 184, diff = 48
184 to 115, diff = 69
115 to 148, diff = 33
148 to 125, diff = 23
(Notice how we have only 4 differences for 5 samples). The total difference is 173 - so the jitter is 173 / 4, or 43.25.
       */



      double currentJitter = 0;
      // var times = List(Constants.NUMBER_OF_PINGS_TO_SEND_JITTER);
      for(int i = 0; i < Constants.NUMBER_OF_PINGS_TO_SEND_JITTER; i++){
        //pig
        // times[i] =
      }
      //************************************************************************


      //*************************************************************PACKET LOSS
      //TODO this will be within dart TCP
      //************************************************************************


      socket.destroy();
    });




  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('PAgCASA Speed Test App'),
        ),
        body: Column(
          children: [
            ElevatedButton(child: Text('Start The Test'), onPressed: createSocketAndTest),
          ],
        )
      ),
    );
  }
}



