import 'package:flutter/material.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/add_vehicle_screen.dart';
import 'package:vehicle_care_2/screen/detail_vehicle_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class VehicleScreen extends StatefulWidget {
  VehicleScreen({Key? key}) : super(key: key);

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  ProfileService _profileService = ProfileService();
  LeftBar leftBar = LeftBar();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadData = false;
  var _listVehicle = [];
  late Screen size;
  String _messageEmpty = "";

  void initState() {
    super.initState();
    _getVehicleData();
  }

  _getVehicleData() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.getVehicle();
    if (_result['result']) {
      print(_result['data']['data']);
      setState(() {
        _listVehicle = _result['data']['data'];
        print(_listVehicle);
        _loadData = false;
      });
    } else {
      setState(() {
        _messageEmpty = _result['message'];
        _loadData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Vehicle Data"),
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
                  : _listVehicle.isEmpty
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
                                        builder: (context) => DetailVehicle(
                                            customer_vehicle_id:
                                                _listVehicle[index]
                                                    ['customer_vehicle_id'])));
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
                                                      '${_listVehicle[index]['vehicle_name']}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "NunitoSansBold",
                                                          fontSize: 20,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                              SizedBox(width: 0.0, height: 0.0),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                        top:
                                                            size.getWidthPx(16),
                                                        bottom:
                                                            size.getWidthPx(16),
                                                        left:
                                                            size.getWidthPx(8)),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios)),
                                              ),
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
                                                Text("Police Number : ",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            "NunitoSansBold",
                                                        fontSize: 16)),
                                                Text(
                                                    "${_listVehicle[index]['police_number']}",
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
                          itemCount: _listVehicle.length))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddVehicleScreen()));
        },
      ),
      drawer: leftBar.leftBar(),
    );
  }
}
