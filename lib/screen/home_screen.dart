// @dart=2.9
import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  LeftBar leftBar = LeftBar();
  // String _customerName, _customerEmail, _customerId, _userId;
  bool _loadData = false;

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String token = await storage.read(key: 'token');
    var _result = await auth.tryToken(token: token);
    if (!_result['result']) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Provider.of<Auth>(context, listen: false).tryToken(token: token);
      // SharedPreferences _preferences = await SharedPreferences.getInstance();
      setState(() {
        // _customerName = _preferences.getString("customer_name");
        // _customerEmail = _preferences.getString("email");
        _loadData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Center(
        child: Text("Home Screen"),
      ),
      drawer: leftBar.leftBar(),
    );
  }
}
