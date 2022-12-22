import 'package:flutter/material.dart';
import 'package:fetch_internet/Album.dart';
import 'package:fetch_internet/CtrlAlbum.dart';

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
  Future<List<Album>>? myAlb;
  @override
  void initState() {
    myAlb = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<List<Album>>(
          future: myAlb,
          initialData: [const Album(userId: -1, id: -1, title: 'title')],
          builder: (context, snapshot) {
            List<Widget> chldrn;
            if (snapshot.hasData) {
              List<Widget> x = snapshot.data!.map((e) {
                return Card(
                  child: ListTile(
                    title: Text('${e.title}'),
                    subtitle: Text('${e.id}'),
                    trailing: Text('${e.userId}'),
                  ),
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
                children: chldrn,
              ),
            );
          },
        ));
  }
}




//--------------------------------------------------------------
// Future<List<Map<String, dynamic>>>? myAlb;
// title: Text('${e['title']}'),
// subtitle: Text('${e['id']}'),
// trailing: Text('${e['userId']}'),

// without future builder
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