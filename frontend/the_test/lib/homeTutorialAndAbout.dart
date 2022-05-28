//The tutorial screen
//Accessed when pressing "start a test" on main screen
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'constants.dart' as Constants;

class AboutScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body:
        Container(
          child:
          Center(
            child: ListView(
              // shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  Center(
                      child: Container(
                        height: height * .7,
                        width: width * .9,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/HomepageBackground.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:

                        Center(
                            child:
                            Container(
                                padding: EdgeInsets.all(5.0),
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: (Colors.brown), width: 7),
                                //     borderRadius: BorderRadius.all(Radius.circular(10))),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2)),
                                    color: Colors.white
                                ),
                                height: height * .6,
                                width: width * .8,
                                //color: Colors.black, width:  10

                                // color: Colors.white,
                                child:
                                Center( child:
                                AutoSizeText(
                                  "The Precision Ag Connectivity & Accuracy Stakeholder Alliance (PAgCASA) is a not-for-profit education foundation whose mission is to design, field test, and deploy technical and policy tools needed to ensure accurate broadband mapping and deployment across America to ignite smart agriculture and rural prosperity. \n\nConsistent with the Broadband DATA Act of 2020 and the recent findings of the FCC's Precision Ag Task Force, PAgCASA aims to drive transparent broadband mapping methodology specific to rural America by establishing a standards-based, open source toolkit for collecting accurate, granular, crowdsourced, and citizen-centric data. \n\nAccurate broadband maps are essential to inform wise infrastructure investments and effective broadband deployment for communities still left behind. ",
                                  style: TextStyle(fontSize: 20),
                                  minFontSize: 12,
                                  maxFontSize: 25,
                                )
                                )
                            )
                        ),

                      )),
                  SizedBox(
                    height: height * Constants.SPACER_BOX_HEIGHT,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[400], // Background color
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => AboutScreen()),
                        );
                      },
                      child:  Container(
                          height: height * .1,
                          width: width * .8,
                          child:Center( child:
                          AutoSizeText(
                            'Go Back',
                            style: TextStyle(fontSize: 20),
                            minFontSize: 18,
                            maxFontSize: 25,
                          )
                          )
                      )
                  )
                ]),
          ),
        )
    );
  }
}

//About us screen
//Accessed when hitting "about us" from the main screen
class TutorialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    double width = MediaQuery.of(context).size.width;
    print('This is the value of the hold $width');

    double height = MediaQuery.of(context).size.height;
    print('This is the value of the hold $width');


    return Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Tutorial'),
          centerTitle: true,
          backgroundColor: Colors.lightGreen[700],
        ),
        body:

        Container(
          child:
          Center(
            child: ListView(
              // shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: [
                  Center(
                      child: Container(
                        height: height * .7,
                        width: width * .9,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/HomepageBackground.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:

                        Center(
                            child:
                            Container(
                                padding: EdgeInsets.all(5.0),
                                // decoration: BoxDecoration(
                                //     border: Border.all(color: (Colors.brown), width: 7),
                                //     borderRadius: BorderRadius.all(Radius.circular(10))),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 3),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(2)),
                                    color: Colors.white
                                ),
                                height: height * .6,
                                width: width * .8,
                                //color: Colors.black, width:  10

                                // color: Colors.white,
                                child:
                                Center( child:
                                AutoSizeText(
                                  "Please read this brief tutorial on how to use our applicatiion \n\n1. You may begin a test by navigating to the \"run a test\" page.  Press the wifi icon on the bottom bar to reach this page. \n\n2. You will be greeted by a screen displaying your current approximate location and an empty field where the test results will appear.  Begin a test by hitting the red \"Begin Test\" button on the bottom bar.\n\n3. After the test is complete, results will be displayed and recorded.  You may now view your previous test history by navigating to the \"Results\" page.  You can navigate to this page by hitting the rewinding clock icon on the bottom bar.  \n\n4.  Finally, we ask that you upload some personal information to help us accomplish our goals.  You may view and modify this information by navigating to the \"Profile Settings\" page.  You may navigate to this page by hitting the person icon on the bottom bar. \n\nFor additional support, please email holder@holder.com or contact us at 111-222-3333.  Thank you! ",
                                  style: TextStyle(fontSize: 20),
                                  minFontSize: 12,
                                  maxFontSize: 25,
                                )
                                )
                            )
                        ),

                      )),
                  SizedBox(
                    height: height * Constants.SPACER_BOX_HEIGHT,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[400], // Background color
                      ),
                      onPressed: () {

                        Navigator.pop(
                          context,
                          MaterialPageRoute(builder: (context) => AboutScreen()),
                        );
                      },
                      child:  Container(
                          height: height * .1,
                          width: width * .8,
                          child:Center( child:
                          AutoSizeText(
                            "Run a Test!",
                            style: TextStyle(fontSize: 20),
                            minFontSize: 18,
                            maxFontSize: 25,
                          )
                          )
                      )
                  )
                ]),
          ),
        )
    );
  }
}
