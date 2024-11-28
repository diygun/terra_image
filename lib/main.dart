import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terra Images',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Terra Images'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  String _response = '';
  List imageUrls = [];

  List imageTitles = [];

  int year = 2016;
  int month = 01;

  Uri imgUrl =
      Uri.parse('https://random-image-pepebigotes.vercel.app/api/random-image');

  String intInTwoDigit(int singleDigitInt) {
    if (singleDigitInt.toString().padLeft(2, '0').length > 2) {
      return singleDigitInt.toString();
    } else {
      return singleDigitInt.toString().padLeft(2, '0');
    }
  }

  void incrementDate() {
    if (month < 12 && month > 0) {
      setState(() {
        month++;
      });
    } else if (month >= 12) {
      setState(() {
        month = 1;
        year++;
      });
    }
  }

  void fetchData() {
    String dataUrl =
        'https://epic.gsfc.nasa.gov/api/enhanced/date/${year}-${intInTwoDigit(month)}-01';

    print(dataUrl);

    // enable to while - disabled for testing
    print(imageUrls.length);
    http.get(Uri.parse(dataUrl)).then((resp) {
      if (resp.statusCode == 200) {
        List<dynamic> data = jsonDecode(resp.body);
        // if (data.isEmpty) {
        //   // incrementDate();
        // } else
        if (data.isNotEmpty) {
          var random = Random();

          print(
              'Random img of 01/$month/$year ${data[random.nextInt(data.length)]['image']}');
          String imageTitle = data[0]['image'];
          imageTitles.add(imageTitle);
          imageUrls.add(
              'https://epic.gsfc.nasa.gov/archive/enhanced/${year}/${intInTwoDigit(month)}/01/png/${imageTitle}.png');
          incrementDate();
        }
      }
    }).catchError((err) {
      print("err : " + err.runtimeType.toString());
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      // _counter = 0;
    });
  }

  void resetData() {
    setState(() {
      imageUrls = [];
      _counter = 1;
      imageTitles = [];
      year = 2016;
      month = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                const Text(
                  'Terra image :',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Date : $month - $year',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(_response),
                Text('$imageUrls'),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: imageUrls.isNotEmpty && imageUrls[0] != null
                      ? Image.network(
                    imageUrls[0],
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ): Center(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: imageUrls.isNotEmpty && imageUrls[1] != null
                      ? Image.network(
                    imageUrls[1],
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ): Center(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: imageUrls.isNotEmpty && imageUrls[2] != null
                      ? Image.network(
                    imageUrls[2],
                    fit: BoxFit.fill,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ): Center(),
                ),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: incrementDate,
              tooltip: 'Increment Date',
              child: const Icon(Icons.auto_awesome_motion_sharp),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: fetchData,
              tooltip: 'Load data',
              child: const Icon(Icons.read_more),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: resetData,
              tooltip: 'Reset',
              child: const Icon(Icons.refresh),
            ),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
