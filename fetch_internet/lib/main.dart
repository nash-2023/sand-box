import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Fetch Demo Home Page'),
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
  Future<List<Map<String, dynamic>>>? myAlb;

  Future<List<Map<String, dynamic>>> fetchAlbum() async {
    var response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    if (response.statusCode == 200) {
      List<dynamic>? x;
      List<Map<String, dynamic>>? y;
      x = convert.jsonDecode(response.body);
      y = x!.map((e) {
        Map<String, dynamic> y = Map.from(e);
        return y;
      }).toList();

      return y;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return [
        {
          'title': "title",
          'id': -1,
          'userid': -1,
        }
      ];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    myAlb = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        // body: (y != null)
        //     ? ListView.builder(
        //         itemCount: y!.length,
        //         itemBuilder: (context, index) {
        //           return Text("${y![index]['title']}");
        //         })
        //     : CircularProgressIndicator(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       // Map y = convert.jsonDecode(x![1]) as Map;
        //       Map<String, dynamic>? y = Map<String, dynamic>();

        //       print(y.runtimeType);
        //     });
        //   },
        // ),
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: myAlb,
            builder: (context, snapshot) {
              List<Widget> chldrn;
              if (snapshot.hasData) {
                List<Widget> x = snapshot.data!.map((e) {
                  return ListTile(
                    title: Text('${e['title']}'),
                    subtitle: Text('${e['id']}'),
                    trailing: Text('${e['userId']}'),
                  );
                }).toList();
                chldrn = [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 50.0,
                  ),
                  ...x,
                ];
              } else if (snapshot.hasError) {
                chldrn = [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(' ERROR:- ${snapshot.error}'),
                  ),
                ];
              } else {
                chldrn = [
                  SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(' Loading ...'),
                  ),
                ];
              }
              return Center(
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: chldrn,
                ),
              );
            },
          ),
        ));
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}



/*
Factory constructors

Use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class. For example, a factory constructor might return an instance from a cache, or it might return an instance of a subtype. Another use case for factory constructors is initializing a final variable using logic that can’t be handled in the initializer list.

*/