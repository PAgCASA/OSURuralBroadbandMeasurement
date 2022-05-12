
//Homepage, the main page for the app
import 'package:flutter/material.dart';

import 'homeTutorialAndAbout.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test Homepage'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Container(
        // color: Colors.grey[400],
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/HomepageBackground.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: <Widget>[
            Center(),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: (Colors.brown[800])!, width: 7),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.all(10.0),
                // color: Colors.grey[600],
                width: 319.0,
                height: 515.0,
                child: Image(
                  image: AssetImage('assets/HomepageImage.jpg'),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: Text('About Us'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green[500],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TutorialScreen()),
                );
              },
              child: Text('Start a Test!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            )
          ])));
}