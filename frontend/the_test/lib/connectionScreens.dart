import 'package:flutter/material.dart';

class MobileConnectionScreen extends StatelessWidget {
  const MobileConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  child: const Center(
                      child: Text(
                    "It appears that you are connected to a mobile network.  Please turn off your mobile data and connect to your wireless network to proceed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
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

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  child: const Center(
                      child: Text(
                    "It appears that you do not have network connectivity..  Please turn off your mobile data and connect to your wireless network to proceed.",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
                )),
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
                  child: const Text("Go back"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500],
                  ),
                )
              ]),
        ),
      );
}
