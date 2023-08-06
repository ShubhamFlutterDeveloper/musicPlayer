import 'package:flutter/material.dart';
import 'package:musicplayer/audioPlayer.dart';
import 'package:permission_handler/permission_handler.dart';

import 'musicApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SongList(),
     //Music()
    );
  }
}

