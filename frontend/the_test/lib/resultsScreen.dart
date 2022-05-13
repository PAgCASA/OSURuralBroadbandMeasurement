//Page for displaying past results
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:the_test/utils.dart';

import 'constants.dart';
import 'main.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  //future object for incoming data
  late Future<List<incomingTestResult>> testsToDisplay;

  //get the test with the specified ID
  Future<List<incomingTestResult>> fetchTests(Future<String> incomingID) async {
    //create the full url by appending ID to the base url stored in the constants file
    String fullURL = SERVER_RESULT_REQUEST_URL + await incomingID;

    //request the test at the full URL
    final response = await http.get(Uri.parse(fullURL));
    //if we recieved record with no error, print what we recieved
    if (response.statusCode == 200) {
      String body = response.body;
      // print('This is what we received from the server \n\n  $body   \n\n');

      var json = jsonDecode(response.body);
      var rows = json['Results'];
      // print('\n\n\n\n this is the incoming rows $rows \n\n\n\n\n\n');
      List<incomingTestResult> results = List.empty(growable: true);

      if (rows != null) {
        // this is a really ugly way of looping through the results array and
        // turning them into test results
        for (var i = 0; i < (rows as List).length; i++) {
          var result =
              incomingTestResult.fromJson(rows[i] as Map<String, dynamic>);
          results.insert(i, result);
          // print("$results");
        }
      }

      return results;
    } else {
      throw Exception('Failed to load record with id $incomingID ');
    }
  }

  //get the test with the specified ID first thing
  @override
  void initState() {
    super.initState();
    testsToDisplay = fetchTests(getDeviceID());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PAgCASA: Speed Test Results'),
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

          child: Center(
            child: Container(
              color: Colors.white,
              height: 500,
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder<List<incomingTestResult>>(
                          future: testsToDisplay,
                          builder: (context, snapshot) {
                            var data = snapshot.data;
                            if (snapshot.hasData && data != null) {
                              return buildTable(data);
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          }))),
            ),
          ),
        ),
      );

  Widget buildTable(List<incomingTestResult> results) {
    const columns = COLUMN_TITLES_RESULTS;
    return DataTable(
        columnSpacing: 10,
        columns: getColumns(columns),
        rows: results
            .map(
              (result) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(getDateFormat(result.date))),
                  DataCell(Text(result.downloadSpeed.toString())),
                  DataCell(Text(result.uploadSpeed.toString())),
                  DataCell(Text(result.jitter.toString())),
                  DataCell(Text(result.latency.toString())),
                  DataCell(Text(result.packetLoss.toString())),
                ],
              ),
            )
            .toList());
  }

  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

  String getDateFormat(String data) {
    var date = DateTime.parse(data).toLocal();
    return "${date.day}-${date.month}-${date.year - 2000} ${date.hour}:"
        "${date.minute.toString().length == 1 ? "0" + date.minute.toString() : date.minute.toString()}";
  }
}
