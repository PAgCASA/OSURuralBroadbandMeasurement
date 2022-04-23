import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';

Future<String> getDeviceID() async{
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

int getTestID(String PhoneID){
  //TODO do we want to have me send a phone ID and backend
  //TODO returns a valid test ID to use, or would it be easier to return all the used test Ids and have frontend generate test ID
  Random testRand = Random();
  return 0;
}

double bitsPerSecToMegaBitsPerSec(int bps) {
  return bps * 8 / 1000 / 1000;
}