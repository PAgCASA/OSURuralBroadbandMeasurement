import 'package:flutter/material.dart';

class MobileConnectionScreen extends StatelessWidget {
  const MobileConnectionScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    double height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(

      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Center(
        child: ListView(
          // shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: [
              Center(
                child:
                Center(
                    child:
                    Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: (Colors.brown), width: 7),
                      //     borderRadius: BorderRadius.all(Radius.circular(10))),
                        decoration: BoxDecoration(
                            border: Border.all(width: 3),
                            borderRadius: const BorderRadius.all(
                                Radius.circular(2)),
                            color: Colors.white
                        ),
                        height: height * .07,
                        width: width * .8,
                        //color: Colors.black, width:  10

                        // color: Colors.white,
                        child: const Center(child: Text(
                          "It appears that you are connected to a mobile network.  Please turn off your mobile data and connect to your wireless network to proceed.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                        )
                    )
                ),
              ),


              //
              // Container(
              //
              //   height: 600,
              //   width: 650,
              //   decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage("assets/HomepageBackground.jpg"),
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              //   child: Center(
              //       child: Text(
              //         "It appears that you are connected to a mobile network.  Please turn off your mobile data and connect to your wireless network to proceed.",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold, fontSize: 16),
              //       )),
              // )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MobileConnectionScreen()),
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



class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;

    double height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test'),
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
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/HomepageBackground.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child:

                    Center(
                        child:
                        Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: (Colors.brown), width: 7),
                          //     borderRadius: BorderRadius.all(Radius.circular(10))),
                            decoration: BoxDecoration(
                                border: Border.all(width: 3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(2)),
                                color: Colors.white
                            ),
                            height: height * .07,
                            width: width * .8,
                            //color: Colors.black, width:  10

                            // color: Colors.white,
                            child: const Center(child: Text(
                              "Thank you for uploading your personal data!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                            )
                        )
                    ),
                  )),


              //   Center(
              //       child: Text(
              //     "It appears that you do not have network connectivity..  Please turn off your mobile data and connect to your wireless network to proceed.",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              //   )),
              // )),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoConnectionScreen()),
                  );
                },
                child: const Text("It appears that you do not have network connectivity..  Please turn off your mobile data and connect to your wireless network to proceed."),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[500],
                ),
              )
            ]),
      ),
    );
  }
}
