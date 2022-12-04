import 'dart:developer';

// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:network_bound_resource/src/data/network_bound_resource.dart';

import 'data/remote_data_source.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final RemoteDataSource remoteDataSource;

  @override
  void initState() {
    remoteDataSource = RemoteDataSource(NetworkBoundResource(
      'https://jsonplaceholder.typicode.com/',
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  final posts = remoteDataSource.getPosts();
                  log(posts.toString());
                },
                child: const Text('Get posts'))
          ],
        ),
      ),
    );
  }
}
