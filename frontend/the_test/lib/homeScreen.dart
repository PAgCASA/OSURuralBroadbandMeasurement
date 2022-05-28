//Homepage, the main page for the app
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'homeTutorialAndAbout.dart';
import 'constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    print('This is the value of the hold $width');

    double height = MediaQuery.of(context).size.height;
    print('This is the value of the hold $width');

    var padding = MediaQuery.of(context).viewPadding;
    double height2 = height - padding.top - kToolbarHeight;

    return Scaffold(
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
            child:
            SingleChildScrollView( child:
            Column(children: <Widget>[
              SizedBox(height: height * SPACER_BOX_HEIGHT),
              const Center(),
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: (Colors.brown[800])!, width: 7),
                      borderRadius: const BorderRadius.all(Radius.circular(10))),
                  margin: const EdgeInsets.all(10.0),
                  // color: Colors.grey[600],
                  // width: 319.0,
                  // height: 515.0,
                  width: width * .8,
                  height: height2 * .55,
                  child: const Image(
                      image: AssetImage('assets/HomepageImage.jpg'),
                      fit: BoxFit.fill
                  )),
              SizedBox(height: height * SPACER_BOX_HEIGHT),
              ElevatedButton(
                //width:width * .8, height: height2 * .02)
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size((width * .8),(height2 * .01)),
                    primary: Colors.green[400], // Background color
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutScreen()),
                    );
                  },
                  child:
                  SizedBox(
                      height: height * SPACER_BOX_HEIGHT,
                      width: width * .7,
                      child:const Center( child:
                      AutoSizeText(
                        'About Us',
                        style: TextStyle(fontSize: 20),
                        minFontSize: 18,
                        maxFontSize: 25,
                      )
                      )
                  )

                // Text('About Us'),
                // style: ElevatedButton.styleFrom(
                //   primary: Colors.green[500],
                // ),
              ),
              SizedBox(height: height * SPACER_BOX_HEIGHT),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[400], // Background color
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TutorialScreen()),
                    );
                  },
                  child:   SizedBox(
                      height: height * SPACER_BOX_HEIGHT,
                      width: width * .7,
                      child:const Center( child:
                      AutoSizeText(
                        'Start a Test!',
                        style: TextStyle(fontSize: 20),
                        minFontSize: 18,
                        maxFontSize: 25,
                      )
                      )
                  )
              ),
              SizedBox(height: height * SPACER_BOX_HEIGHT),
            ])
            )));
  }
}