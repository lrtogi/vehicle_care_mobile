import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/company_menu.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProfileService _profileService = ProfileService();
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  LeftBar leftBar = LeftBar();
  // String _customerName, _customerEmail, _customerId, _userId;
  bool _loadData = false;
  var _listCompany = [];
  late Screen size;
  String _messageEmpty = "";
  var primaryColor = const Color(0xff0692CB);
  var _choise = ["Pay"];

  void initState() {
    super.initState();
    readToken();
    _getCompany();
  }

  _getCompany() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.getCompany();
    if (_result['result']) {
      setState(() {
        _listCompany = _result['data'];
        _loadData = false;
      });
    } else {
      setState(() {
        _messageEmpty = _result['message'];
        _loadData = false;
      });
    }
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
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
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 13, right: 13, top: 16, bottom: 16),
          ),
          SizedBox(height: 8),
          Expanded(
              child: _loadData
                  ? Center(child: CircularProgressIndicator())
                  : _listCompany.isEmpty
                      ? Center(
                          child: Text(_messageEmpty,
                              style: TextStyle(
                                  fontFamily: "NunitoSansBold", fontSize: 21)))
                      : ListView.builder(
                          padding: EdgeInsets.only(
                              left: size.wp(2),
                              right: size.wp(2),
                              top: size.hp(1),
                              bottom: size.hp(1.5)),
                          itemBuilder: (context, index) {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CompanyMenu(
                                              company_id: _listCompany[index]
                                                  ['company_id'],
                                              company_name: _listCompany[index]
                                                  ['company_name'],
                                            ))).then(onGoBack);
                                ;
                              },
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: size.wp(2.5),
                                    vertical: size.hp(1.3)),
                                borderOnForeground: true,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8))),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: size.wp(1),
                                              right: size.wp(1.5)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 8,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: size.getWidthPx(16),
                                                      bottom:
                                                          size.getWidthPx(16),
                                                      left: size.getWidthPx(8)),
                                                  child: Text(
                                                      '${_listCompany[index]['company_name']}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "NunitoSansBold",
                                                          fontSize: 20,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                              SizedBox(width: 0.0, height: 0.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("Alamat : ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSansBold",
                                                        fontSize: 16)),
                                                Text(
                                                    "${_listCompany[index]['alamat_perusahaan']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSans",
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text("No Telepon : ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSansBold",
                                                        fontSize: 16)),
                                                Text(
                                                    "${_listCompany[index]['no_telp']}",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSans",
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
                          itemCount: _listCompany.length))
        ],
      ),
      drawer: leftBar.leftBar(),
    );
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
