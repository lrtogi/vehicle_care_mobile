import 'package:flutter/material.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/screen/qr_scanner_submit_vehicle.dart';
import 'package:vehicle_care_2/screen/qr_scanner_take_job.dart';
import 'package:vehicle_care_2/screen/worker_job_list_screen.dart';

class JobMenu extends StatefulWidget {
  JobMenu({Key? key}) : super(key: key);

  @override
  _JobMenuState createState() => _JobMenuState();
}

class _JobMenuState extends State<JobMenu> {
  var primaryColor = const Color(0xff0692CB);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  LeftBar leftBar = LeftBar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: primaryColor,
        key: _scaffoldKey,
        drawer: leftBar,
        appBar: AppBar(
          title: Text('Job Menu'),
        ),
        body: Column(children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkerJobListScreen()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27),
                child: Card(
                  color: primaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 47,
                        vertical: MediaQuery.of(context).size.height / 37),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: MediaQuery.of(context).size.width / 37),
                        Text(
                          "Your Job List",
                          style: TextStyle(
                              fontFamily: "NunitoSansBold", fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRScannerTakeJob()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27),
                child: Card(
                  color: primaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 47,
                        vertical: MediaQuery.of(context).size.height / 37),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: MediaQuery.of(context).size.width / 37),
                        Text(
                          "Take Job",
                          style: TextStyle(
                              fontFamily: "NunitoSansBold", fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 25),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRScannerSubmitVehicle()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27),
                child: Card(
                  color: primaryColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 47,
                        vertical: MediaQuery.of(context).size.height / 37),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: MediaQuery.of(context).size.width / 37),
                        Text(
                          "Submit Vehicle",
                          style: TextStyle(
                              fontFamily: "NunitoSansBold", fontSize: 24),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
