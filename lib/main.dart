import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
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

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Album> albuns = [];
  void getAlbuns() async {
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        //print(data.toString());

        for (int i = 0; i < data.length; i++) {
          final urlAlbum = Uri.parse("${url}/${i}");
          var responseAlbum = await http.get(urlAlbum);
          if (responseAlbum.statusCode == 200) {
            final userId = jsonDecode(responseAlbum.body)['userId'];
            final id = jsonDecode(responseAlbum.body)['id'];
            final title = jsonDecode(responseAlbum.body)['title'];
            var album = await Album(userId: userId, id: id, title: title);
            setState(() {
              albuns.add(album);
            });
          }
        }
      }
    } catch (err) {
      print(err);
    }
  }

  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    getAlbuns();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Fetch Data Example'),
          ),
          body: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Text(albuns[index].id.toString()),
                  Text(albuns[index].title.toString()),
                  //Text(albuns[index].userId.toString()),
                  Divider(
                    thickness: 3,
                    color: Colors.black,
                  )
                ],
              );
            },
            itemCount: albuns.length,
          )),
    );
  }
}
