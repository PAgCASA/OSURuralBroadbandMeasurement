import 'package:flutter/material.dart';

class MobileConnectionScreen extends StatelessWidget {
  const MobileConnectionScreen({Key? key}) : super(key: key);

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
      body: Center(
        child: ListView(padding: const EdgeInsets.all(20.0), children: [
          Center(
            child: Center(
                child: Container(
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
                      "It appears that you are connected to a mobile network.  Please turn off your mobile data and connect to your wireless network to proceed.",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )))),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PAgCASA: Speed Test'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[700],
      ),
      body: Center(
        child: ListView(padding: const EdgeInsets.all(20.0), children: [
          Center(
            child: Center(
                child: Container(
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
                      "It appears that you are not connected to a network.  Please connect to your wireless network to proceed.",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )))),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
