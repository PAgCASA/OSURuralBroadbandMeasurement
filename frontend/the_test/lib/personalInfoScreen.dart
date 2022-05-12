
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
import 'constants.dart' as Constants;

class personalInfoFormSubmit extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('PAgCASA: Submit Personal Information'),
      centerTitle: true,
      backgroundColor: Colors.lightGreen[700],
    ),
    body: Center(
      child: new ListView(
        // shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          children: [Center(child: new Text('PAg4 hold \n '))]),
    ),
  );
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String firstName = '-';
  String lastName = '-';
  String street = '-';
  String postalCode = '-';
  String city = '-';
  String state = '-';
  String internetPlan = '-';

  //this will store the image in cache
  File? image = null;

  final formKey = GlobalKey<FormState>();

  //Upload incoming json encoded data
  uploadPersonalInfo(var incomingMap) async {
    //create a POST request and anticipate a json object
    var response =
    await http.post(Uri.parse(Constants.PERSONAL_INFO_UPLOAD_URL),
        //    headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: incomingMap);
    //store the body in a variable
    var holder = response.body;
    print('sending data to server ');

    //TODO increase error checking
    //check to ensure the server gave us a response
    if (holder == null) {
      print(
          "there was a problem connecting with the server.  Please try again");
    } else if (holder == "200 Error") {
    } else {
      //print the server response from upload
      print(
          '\n This is the response from the server for personal info uploading: $holder\n');
    }
  }

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Enter your first name"
      ),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
          return "Please enter a valid first name";
        } else {
          firstName = value;
        }
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your last name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid last name";
          } else {
            lastName = value;
          }
        });
  }

  Widget _buildStreetName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Enter your street name"),
      validator: (value) {
        if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
          return "Please enter a valid last name";
        } else {
          street = value;
        }
      },
    );
  }

  Widget _buildPostal() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your postal code"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return "Please enter a valid postal code";
          } else {
            postalCode = value;
          }
        });
  }

  Widget _buildTown() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Enter your city or town name"),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid city or town name";
          } else {
            city = value;
          }
        });
  }

  Widget _buildState() {
    return TextFormField(

        decoration: InputDecoration(labelText: "Enter your state" ),
        validator: (value) {
          if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return "Please enter a valid state name";
          } else {
            state = value;
          }
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
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Upload Profile Information'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: ListView(
        addAutomaticKeepAlives: true,
      children: [
        Form(
          key: formKey,
          child: Container(
              color: Colors.yellow[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Please enter your personal information below.  All data is stored securely and will NEVER be sold or distributed.',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 10),
                  _buildFirstName(),
                  SizedBox(height: 10),
                  _buildLastName(),
                  SizedBox(height: 10),
                  _buildStreetName(),
                  SizedBox(height: 10),
                  _buildPostal(),
                  SizedBox(height: 10),
                  _buildTown(),
                  SizedBox(height: 10),
                  _buildState(),
// Use imagepicker for uploading image https://pub.dev/packages/image_picker/install
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text('Upload an image of your internet bill from Gallery'),
                      onPressed: () {
                        _buildImageGallery();
                        if (image != null) {
                          List<int> imageBytes =
                          image!.readAsBytesSync();
                          String base64Image =
                          base64.encode(imageBytes);
                          internetPlan = base64Image;
                        } else {
                          print('Something is wrong with the image');
                        }
                      }),
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text('Upload an image of your internet bill from Camera'),
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
                  SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        final isValid =
                        formKey.currentState?.validate();
                        if (formKey.currentState!.validate()) {
                          PersonalInformation person =
                          PersonalInformation(
                              firstName,
                              lastName,
                              street,
                              postalCode,
                              city,
                              state,
                              internetPlan);
//
                          print('sending data to method ');
                          print('this is the image $image ');
                          uploadPersonalInfo(person.toJSON());
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => dataUploadScreen()),
                          );
                        }
                      },
                      child: Text('Submit!'))
                ],
              )))])
      );
}

class dataUploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  height: 600,
                  width: 650,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/HomepageBackground.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                      child: Text(
                        "Thank you for uploading your personal data!",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(builder: (context) => dataUploadScreen()),
                );
              },
              child: Text("Go back"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[500],
              ),
            )
          ]),
    ),
  );
}