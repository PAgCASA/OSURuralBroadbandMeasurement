import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';

Future<String> getDeviceID() async{
  //uses discontinued library https://pub.dev/packages/device_info
  //TODO look into another device ID finding library as this one is out of date
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  var phoneID = "";

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    phoneID = androidInfo.androidId.toString();
  }
  //TODO use a different identifier for iphones as there is no build in method for the library
  else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    phoneID = iosInfo.identifierForVendor.toString();
  }
  else {
    print('error detecting device type');
  }
  //print("This is the phone ID $phoneID");

  return phoneID;
}

int getTestID(){
  //TODO get the test ID via the server
  //initially stick with UUID -> server later on
  Random testRand = Random();
  int testIDGenerate = testRand.nextInt(1000000000);
  // print("Test ID is $testIDGenerate");
  // test_ID = testIDGenerate;
  //hardcoded for demo
  return 155;
}