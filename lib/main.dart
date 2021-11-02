// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';

import 'services/auth.dart';

const storage = FlutterSecureStorage();
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Vehicle Care'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.3, 0.6, 0.8],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color(0xff0692CB),
                Color(0xff0692CB),
                Color(0xff0692CB),
              ],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                child: Center(
                  child: Image.asset('images/logo.png',
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 1.5),
                ),
              ),
              Positioned.fill(
                  child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 37),
                child: Align(
                  child: Text('Vehicle Care', style: TextStyle(fontSize: 14)),
                  alignment: Alignment.bottomCenter,
                ),
              ))
            ],
          )),
    );
  }

  _initDb() async {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }
}
