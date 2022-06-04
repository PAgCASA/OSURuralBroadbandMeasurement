//Page for displaying past results
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart' as Constants;
import 'utils.dart' as utils;
import 'main.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  //future object for incoming data
  late Future<List<TestResult>> testsToDisplay;

  //get the test with the specified ID
  Future<List<TestResult>> fetchTests(Future<String> incomingID) async {
    //create the full url by appending ID to the base url stored in the constants file
    String fullURL = Constants.SERVER_RESULT_REQUEST_URL + await incomingID;

    //request the test at the full URL
    final response = await http.get(Uri.parse(fullURL));
    //if we received record with no error, print what we received
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var rows = json['Results'];
      // print('\n\n\n\n this is the incoming rows $rows \n\n\n\n\n\n');
      List<TestResult> results = List.empty(growable: true);

      if (rows != null) {
        // this is a really ugly way of looping through the results array and
        // turning them into test results
        for (var i = 0; i < (rows as List).length; i++) {
          var result = TestResult.fromJson(rows[i] as Map<String, dynamic>);
          results.insert(i, result);
          // print("$results");
        }
      }

      return results;
    } else {
      throw Exception(
          'Failed to load record because of error ${response.body}');
    }
  }

  //get the test with the specified ID first thing
  @override
  void initState() {
    super.initState();
    testsToDisplay = fetchTests(utils.getDeviceID());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
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
            decoration: BoxDecoration(
                border: Border.all(color: (Colors.brown[800])!, width: 7),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            // color: Colors.white,
            height: height * .7,
            width: width * .8,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<TestResult>>(
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
  }

  Widget buildTable(List<TestResult> results) {
    const columns = Constants.COLUMN_TITLES_RESULTS;
    return DataTable(
        columnSpacing: 10,
        columns: getColumns(columns),
        rows: results
            .map(
              (result) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(getDateFormat(result.testStartTime))),
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

  String getDateFormat(DateTime data) {
    var date = data.toLocal();
    return "${date.day}-${date.month}-${date.year - 2000} ${date.hour}:"
        "${date.minute.toString().length == 1 ? "0" + date.minute.toString() : date.minute.toString()}";
  }
}
