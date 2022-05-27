//Homepage, the main page for the app
import 'package:flutter/material.dart';

import 'homeTutorialAndAbout.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test Homepage'),
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
          child: Column(children: <Widget>[
            const Center(),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: (Colors.brown[800])!, width: 7),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                margin: const EdgeInsets.all(10.0),
                // color: Colors.grey[600],
                width: 319.0,
                height: 515.0,
                child: const Image(
                  image: AssetImage('assets/HomepageImage.jpg'),
                )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: const Text('About Us'),
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
              child: const Text('Start a Test!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            )
          ])));
}
