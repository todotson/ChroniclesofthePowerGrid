import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freedm_grid_game/interface.dart';
import 'package:freedm_grid_game/frontend/page.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GamePage(GameInterface())
    );
  }
}