import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:the_test/utils.dart';

import 'main.dart';
import 'constants.dart' as Constants;

class PersonalInfoFormSubmit extends StatelessWidget {
  const PersonalInfoFormSubmit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Submit Personal Information'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Center(
          child: ListView(
              // shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: const [Center(child: Text('PAg4 hold \n '))]),
        ),
      );
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String firstName = '';
  String lastName = '';
  String street = '';
  String postalCode = '';
  String city = '';
  String state = '';
  String internetPlan = '';

  bool loadedFromServer = false;

  //this will store the image in cache
  File? image;

  final formKey = GlobalKey<FormState>();

  mapToQuery(Map<String, String> map, {Encoding? encoding}) {
    var pairs = <List<String>>[];
    map.forEach((key, value) => pairs.add([
          Uri.encodeQueryComponent(key, encoding: encoding ?? utf8),
          Uri.encodeQueryComponent(value, encoding: encoding ?? utf8)
        ]));
    return pairs.map((pair) => '${pair[0]}=${pair[1]}').join('&');
  }

  //Upload incoming json encoded data
  uploadPersonalInfo(var incomingMap) async {
    //create a POST request and anticipate a json object
    var response =
        await http.post(Uri.parse(Constants.PERSONAL_INFO_UPLOAD_URL),
            //    headers: {"Content-Type": "application/json; charset=UTF-8"},
            body: incomingMap);
    //store the body in a variable
    var holder = response.body;
    print('sending data to server');

    //TODO increase error checking

    //print the server response from upload
    print(
        '\n This is the response from the server for personal info uploading: $holder\n');
  }

  getDataFromServer() async {
    var deviceID = await getDeviceID();
    var response = await http
        .get(Uri.parse(Constants.PERSONAL_INFO_DOWNLOAD_URL + deviceID));
    var json = jsonDecode(response.body);
    var pd = PersonalInformation.fromJson(json);
    setState(() {
      firstName = pd.firstName;
      lastName = pd.lastName;
      street = pd.street;
      postalCode = pd.postalCode;
      city = pd.city;
      state = pd.state;
      loadedFromServer = true;
    });
  }

  Widget _buildFirstName() {
    return TextFormField(
      initialValue: firstName,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(labelText: "Enter your first name"),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[a-z A-Z\s]+$').hasMatch(value)) {
          return "Please enter a valid first name";
        } else {
          firstName = value;
        }
        return null;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
        initialValue: lastName,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(labelText: "Enter your last name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z\s]+$').hasMatch(value)) {
            return "Please enter a valid last name";
          } else {
            lastName = value;
          }
          return null;
        });
  }

  Widget _buildStreetName() {
    return TextFormField(
      initialValue: street,
      textAlign: TextAlign.center,
      decoration: const InputDecoration(labelText: "Enter your street name"),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[0-9 a-z A-Z\s]+$').hasMatch(value)) {
          return "Please enter a valid last name";
        } else {
          street = value;
        }
        return null;
      },
    );
  }

  Widget _buildPostal() {
    return TextFormField(
        initialValue: postalCode,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(labelText: "Enter your postal code"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[0-9]+\s?$').hasMatch(value)) {
            return "Please enter a valid postal code";
          } else {
            postalCode = value;
          }
          return null;
        });
  }

  Widget _buildTown() {
    return TextFormField(
        initialValue: city,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          labelText: "Enter your city or town name",
        ),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z\s]+$').hasMatch(value)) {
            return "Please enter a valid city or town name";
          } else {
            city = value;
          }
          return null;
        });
  }

  Widget _buildState() {
    return TextFormField(
        initialValue: state,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(labelText: "Enter your state"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z\s]+$').hasMatch(value)) {
            return "Please enter a valid state name";
          } else {
            state = value;
          }
          return null;
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('PAgCASA: Upload Profile Information'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/HomepageBackground.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: !loadedFromServer
                    ? const Text("Loading info from server")
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: (Colors.brown[800])!, width: 7),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        height: height * .75,
                        width: width * .9,
                        child: SingleChildScrollView(
                            child: Form(
                                key: formKey,
                                child: Container(
                                    padding: const EdgeInsets.all(20),
                                    color: Colors.yellow[200],
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        const AutoSizeText(
                                          'Please enter your personal information below.  All data is stored securely and will NEVER be sold or distributed.',
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                          minFontSize: 12,
                                          maxFontSize: 25,
                                        ),

                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        _buildFirstName(),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        Center(child: _buildLastName()),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        _buildStreetName(),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        _buildPostal(),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        _buildTown(),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        _buildState(),
// Use imagepicker for uploading image https://pub.dev/packages/image_picker/install
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            child: const Center(
                                                child: AutoSizeText(
                                              'Upload an image of your internet bill from Gallery',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                              minFontSize: 12,
                                              maxFontSize: 25,
                                            )),
                                            onPressed: () async {
                                              await _buildImageGallery();
                                              if (image != null) {
                                                List<int> imageBytes =
                                                    image!.readAsBytesSync();
                                                String base64Image =
                                                    base64.encode(imageBytes);
                                                internetPlan = base64Image;
                                              } else {
                                                print(
                                                    'Something is wrong with the image');
                                              }
                                            }),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            child: const Center(
                                                child: AutoSizeText(
                                              'Upload an image of your internet bill from Camera',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 16),
                                              minFontSize: 12,
                                              maxFontSize: 25,
                                            )),
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
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              PersonalInformation person =
                                                  PersonalInformation(
                                                      await getDeviceID(),
                                                      firstName,
                                                      lastName,
                                                      street,
                                                      postalCode,
                                                      city,
                                                      state,
                                                      internetPlan);
//
                                              print('sending data to method ');
                                              print(
                                                  'this is the image $image ');
                                              uploadPersonalInfo(
                                                  person.toJSON());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const DataUploadScreen()),
                                              );
                                            } else {
                                              print("Something isn't valid");
                                            }
                                          },
                                          child: const Center(
                                              child: AutoSizeText(
                                            'Submit',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                            minFontSize: 12,
                                            maxFontSize: 25,
                                          )),
                                        ),
                                        SizedBox(
                                            height: height *
                                                Constants.SPACER_BOX_HEIGHT),
                                      ],
                                    ))))))));
  }

  _SettingsState() {
    //load all the settings
    getDataFromServer();
  }
}

class DataUploadScreen extends StatelessWidget {
  const DataUploadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
                height: height * .7,
                width: width * .9,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/HomepageBackground.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Container(
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: (Colors.brown), width: 7),
                        //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2)),
                            color: Colors.white),
                        height: height * .07,
                        width: width * .8,
                        //color: Colors.black, width:  10

                        // color: Colors.white,
                        child: const Center(
                            child: Text(
                          "Thank you for uploading your personal data!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )))),
              )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DataUploadScreen()),
                  );
                },
                child: const Text("Go back"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[500],
                ),
              )
            ]),
      ),
    );
  }
}
