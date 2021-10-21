import 'package:flutter/material.dart';
import 'package:vehicle_care_2/screen/booking_screen.dart';
import 'package:vehicle_care_2/screen/job_list_screen.dart';

class CompanyMenu extends StatefulWidget {
  String company_id;
  String company_name;
  CompanyMenu({Key? key, required this.company_id, required this.company_name});

  @override
  _CompanyMenuState createState() => _CompanyMenuState();
}

class _CompanyMenuState extends State<CompanyMenu> {
  var primaryColor = const Color(0xff0692CB);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.company_name),
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
                        builder: (context) => BookingScreen(
                              company_id: widget.company_id,
                              company_name: widget.company_name,
                              date: DateTime.now(),
                              vehicle_id: '',
                            )));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27),
                child: Card(
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
                          "Booking Transaction",
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
                        builder: (context) => JobList(
                              company_id: widget.company_id,
                              company_name: widget.company_name,
                            )));
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 27),
                child: Card(
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
                          "Check Job List",
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
