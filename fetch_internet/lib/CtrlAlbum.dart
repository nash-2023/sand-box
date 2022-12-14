import 'dart:io';

import 'package:fetch_internet/Album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

Future<List<Album>> fetchAlbum() async {
  var response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );
  if (response.statusCode == 200) {
    List<dynamic> x = convert.jsonDecode(response.body);
    List<Map<String, dynamic>> y = x.map((e) {
      Map<String, dynamic> y_ = Map.from(e);
      return y_;
    }).toList();
    List<Album> z = y.map((e) => Album.fromJson(e)).toList();
    return z;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return [
      const Album(userId: -1, id: -1, title: 'title'),
    ];
  }
}

Future<List<Album>> fetchAlbumPJ(http.Client client) async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
  );
  if (response.statusCode == 200) {
    List<Map<String, dynamic>> y =
        convert.jsonDecode(response.body).cast<Map<String, dynamic>>();
    // List<Album> z = y.map((e) => Album.fromJson(e)).toList();
    final z = y.map<Album>((e) => Album.fromJson(e)).toList();
    return z;
  } else {
    print('Request failed with status: ${response.statusCode}.');
    return [
      const Album(userId: -1, id: -1, title: 'title'),
    ];
  }
}
