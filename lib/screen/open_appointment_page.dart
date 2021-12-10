// @dart = 2.9
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_care_2/constant/url.dart';

import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_care_2/models/booking_model.dart';
import 'package:vehicle_care_2/screen/booking_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/screen/payment_list_screen.dart';
import 'package:vehicle_care_2/screen/transaction_screen.dart';
import 'package:vehicle_care_2/screen/transaction_screen_list.dart';
import 'package:vehicle_care_2/services/transaction_service.dart';

class OpenAppointmentPage extends StatefulWidget {
  @override
  _OpenAppointmentPageState createState() => _OpenAppointmentPageState();
}

class _OpenAppointmentPageState extends State<OpenAppointmentPage> {
  final double barHeight = 66.0;

  var _choise = ['Pay'];
  Screen size;
  LeftBar leftBar = LeftBar();
  var token, memberId;
  var _loadDataBooking = false;
  BookingModel _bookingModel;
  var _listTransaction = [];
  TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // token = preferences.getString("token");
    // memberId = preferences.getString("memberId");
    await getBooking();
  }

  getBooking() async {
    if (mounted) {
      setState(() {
        _loadDataBooking = true;
      });
    }
    try {
      var _result = await _transactionService.getListTransaction('0');
      // final response = await http.get("${BaseUrl.url}showBooking/0/$memberId");
      // final data = jsonDecode(response.body);
      // print(_result['data']);
      for (var e in _result['data']) {
        // print(e['transaction_id']);
        // _bookingModel = BookingModel(
        //     e['transaction_id'],
        //     e['transaction_date'],
        //     e['package_id'],
        //     e['package_name'],
        //     e['order_date'],
        //     e['customer_vehicle_id'],
        //     e['vehicle_name'],
        //     e['total_price'],
        //     e['status']);
        // print(_bookingModel);
        _listTransaction.add(e);
        print('test1');
      }
      print('test2');
      setState(() {
        _loadDataBooking = false;
      });
    } catch (e) {
//      setState(() {
      _loadDataBooking = false;
//      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);

    return Scaffold(
      drawer: leftBar,
      body: _loadDataBooking
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _listTransaction.isEmpty
              ? Center(
                  child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: size.hp(3), horizontal: size.hp(3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // Image.asset("img/complaint.webp",
                          //     height: size.hp(17), width: size.wp(32)),
                          Container(
                            margin: EdgeInsets.only(top: size.hp(2)),
                            child: Text(
                              "No Open Appointment",
                              style: TextStyle(
                                  fontFamily: "OpenSansBold", fontSize: 18),
                            ),
                          )
                        ],
                      )),
                )
              : Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width / 24,
                            right: MediaQuery.of(context).size.width / 18,
                          ),
                          child: ListView.builder(
                              padding: EdgeInsets.only(
                                  left: size.wp(2),
                                  right: size.wp(2),
                                  top: size.hp(1),
                                  bottom: size.hp(1.5)),
                              itemBuilder: (context, index) {
                                // _choise.remove('Show Job');
                                return Container(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BookingScreen(
                                                  transaction_id:
                                                      _listTransaction[index]
                                                          ['transaction_id'],
                                                  company_id:
                                                      _listTransaction[index]
                                                          ['company_id'],
                                                  company_name:
                                                      _listTransaction[index]
                                                          ['company_name'],
                                                  date: DateTime.parse(
                                                      _listTransaction[index]
                                                          ['order_date']),
                                                  vehicle_id: '',
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
                                                    topRight:
                                                        Radius.circular(8))),
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: size.wp(1),
                                                  right: size.wp(1.5)),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 8,
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: size
                                                                    .getWidthPx(
                                                                        16),
                                                                bottom: size
                                                                    .getWidthPx(
                                                                        16),
                                                                left: size
                                                                    .getWidthPx(
                                                                        8)),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                                '${DateFormat('dd-MM-yyyy').format(DateTime.parse(_listTransaction[index]['order_date']))}',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "NunitoSansBold",
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .black)),
                                                            _listTransaction[index][
                                                                            'status'] ==
                                                                        0 ||
                                                                    _listTransaction[index][
                                                                            'status'] ==
                                                                        4
                                                                ? Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    child: RaisedButton(
                                                                        onPressed: () {
                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                  builder: (context) => PaymentList(
                                                                                        transaction_id: _listTransaction[index]['transaction_id'],
                                                                                      )));
                                                                        },
                                                                        padding: EdgeInsets.only(top: 10, bottom: 10),
                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                        color: Color(0xff0377fc),
                                                                        child: Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: <
                                                                              Widget>[
                                                                            Text("Pay",
                                                                                style: TextStyle(fontFamily: "NuntioSans", color: Colors.white)),
                                                                          ],
                                                                        )),
                                                                  )
                                                                : Text(
                                                                    'Waiting Approval',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "NunitoSansBold",
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black)),
                                                          ],
                                                        )),
                                                  ),
                                                  SizedBox(
                                                      width: 0.0, height: 0.0),
                                                  // PopupMenuButton<String>(
                                                  //     onSelected: (item) =>
                                                  //         _onSelected(
                                                  //             item,
                                                  //             _listTransaction[
                                                  //                     index][
                                                  //                 'transaction_id']),
                                                  //     itemBuilder: (BuildContext
                                                  //         context) {
                                                  //       // _listTransaction[index]
                                                  //       //             ['status'] ==
                                                  //       //         2
                                                  //       //     ? _choise.contains(
                                                  //       //             'Show Job')
                                                  //       //         ? ''
                                                  //       //         : _choise
                                                  //       //             .add('Show Job')
                                                  //       //     : _choise.removeWhere(
                                                  //       //         (item) =>
                                                  //       //             item ==
                                                  //       //             'Show Job');
                                                  //       return _choise.map(
                                                  //           (String choise) {
                                                  //         return PopupMenuItem<
                                                  //                 String>(
                                                  //             value: choise,
                                                  //             child:
                                                  //                 Text(choise));
                                                  //       }).toList();
                                                  //     }),
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
                                                    Text("Company : ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "NunitoSansBold",
                                                            fontSize: 16)),
                                                    Text(
                                                        "${_listTransaction[index]['company_name']}",
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
                                                    Text("Vehicle : ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "NunitoSansBold",
                                                            fontSize: 16)),
                                                    Text(
                                                        "${_listTransaction[index]['vehicle_name']}",
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
                                                    Text("Package : ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "NunitoSansBold",
                                                            fontSize: 16)),
                                                    Flexible(
                                                        child: Text(
                                                            "${_listTransaction[index]['package_name']}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "NunitoSans",
                                                                fontSize: 16))),
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
                              itemCount: _listTransaction.length)),
                    ),
                  ],
                ),

//      backgroundColor: Colors.white,
//      body: ListView(
//        padding: EdgeInsets.only(top: size.hp(1)),
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(
//                left: size.wp(2),
//                right: size.wp(2),
//                bottom: size.hp(1),
//            ),
//            child: Card(
//              elevation: 5.0,
//              child: Container(
//                margin: EdgeInsets.only(top: size.hp(1),bottom: size.hp(1)),
//                child: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Container(
//                        child: CircleAvatar(
//                          child: Image.asset('img/man.webp'),
//                          radius: 30,
//                        ),
//                      ),flex: 3,
//                    ),
//                    Expanded(
//                      child: Container(
//                        margin: EdgeInsets.only(
////                                  left: size.wp(3),
//                            top: size.hp(1),
//                            bottom: size.hp(1)
//                        ),
//                        child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text(
//                                "Dr.Agus Sentosa",
//                                style: TextStyle(
//                                    fontFamily: "OpenSansBold",
//                                    fontSize: 18
//                                ),
//                                overflow: TextOverflow.ellipsis
//                            ),
//                            Text(
//                                "General Practitioners",
//                                style: TextStyle(
//                                    fontFamily: "OpenSans",
//                                    fontSize: 15
//                                )
//                            ),
//                            Text(
//                                "2019-11-02 12:00",
//                                style: TextStyle(
//                                    fontFamily: "OpenSans",
//                                    fontSize: 15
//                                )
//                            ),
//                          ],
//                        ),
//                      ),flex: 7,
//                    ),
//                    Expanded(
//                      child: Container(
//                        margin: EdgeInsets.only(right: size.wp(3)),
//                        child: RaisedButton(
//                          onPressed: (){},
//                          child: Text(
//                              'Open',
//                              style: TextStyle(
//                                  fontFamily: 'OpenSans',
//                                  color: Colors.white
//                              )
//                          ),
//                          shape:  RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(25),
//                          ),
//                          color: Color(0xffFF9900),
//                        ),
//                      ),flex: 3,
//                    )
//                  ],
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => TransactionScreenList()));
  }

  _onSelected(String item, String transaction_id) {
    if (item == 'Pay') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentList(
                    transaction_id: transaction_id,
                  )));
    } else if (item == 'Show Job') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentList(
                    transaction_id: transaction_id,
                  )));
    }
  }
}

class FilterDialog extends StatefulWidget {
  @override
  final String salesID;
  final String booking;

  FilterDialogState createState() => new FilterDialogState();
  const FilterDialog({Key key, this.salesID, this.booking}) : super(key: key);
}

class FilterDialogState extends State<FilterDialog> {
  final formKey = GlobalKey<FormState>();
  var _autoValidate = false;

  var _loadData = false;
  var doctor,
      patient,
      bookingDate,
      bookingTime,
      room,
      keluhan,
      price,
      companyPhone;

  void initState() {
    super.initState();
    print("----");
    getDataBooking(widget.salesID, widget.booking);
    getCompany();
  }

  getDataBooking(String salesID, String booking) async {
    setState(() {
      _loadData = true;
    });
    try {
      final response =
          await http.get("${BaseUrl.url}showPaymentBooking/$salesID/$booking");
      final data = jsonDecode(response.body);
      setState(() {
        doctor = data['model']['username'];
        room = data['model']['room_number'];
        patient = data['booking']['customer_name'];
        bookingDate = data['booking']['date'];
        bookingTime = data['booking']['time'];
        keluhan = data['booking']['notes'];
        price = data['model']['price'];
        _loadData = false;
      });
    } catch (e) {
      setState(() {
        _loadData = false;
      });
      print(e);
    }
  }

  getCompany() async {
    try {
      final response = await http.get("${BaseUrl.url}getCompany");
      final data = jsonDecode(response.body);
      setState(() {
        companyPhone = data['phone'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // ConfirmationWA() async {
  //   String url = 'https://wa.me/$companyPhone';
  //   print(url);
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // Widget confirmButton() {
  //   return Container(
  //     margin: EdgeInsets.all(6.0),
  //     child: RaisedButton(
  //       padding: EdgeInsets.all(12.0),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(5.0),
  //       ),
  //       color: Color(0xff008ECC),
  //       onPressed: () {
  //         ConfirmationWA();
  //       },
  //       child: Row(
  //         mainAxisSize: MainAxisSize.max,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           Text("Confirmation",
  //               style: TextStyle(color: Colors.white, fontSize: 16)),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  LeftBar leftBar = LeftBar();
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      drawer: leftBar,
      backgroundColor: Colors.white,
      body: _loadData
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(top: statusBarHeight),
                  height: statusBarHeight + 66.0,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.clear, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              right: Screen(MediaQuery.of(context).size).wp(8)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Booked Confirmation",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [
                          const Color(0xFF008ECC),
                          const Color(0xFF2FACFE)
                        ],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(1, 0.0),
                        stops: [0.0, 0.5],
                        tileMode: TileMode.clamp),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 5, bottom: 10, top: 10),
                            child: Text("List Detail Booking",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff008ECC),
                                    fontWeight: FontWeight.bold))),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Doctor",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(doctor,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Patient",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(patient,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Date",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(bookingDate,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Time",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(bookingTime,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Room",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(room,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Main Complaint",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 0,
                                child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(" : ",
                                        style: TextStyle(fontSize: 16)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(keluhan,
                                        style: TextStyle(fontSize: 16)))),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 5, bottom: 10),
                            child: Text("Payment For Approved Booked",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff008ECC),
                                    fontWeight: FontWeight.bold))),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, right: 5, bottom: 5, left: 15),
                                    child: Text("Total",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)))),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text("Rp. " + price,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right))),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("*click bellow to confirmation",
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xffFF6633)))),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 5, bottom: 5),
                            child: Text("Payment Method",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff008ECC),
                                    fontWeight: FontWeight.bold))),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 5, right: 5, bottom: 5, left: 15),
                            //     child: Image.asset('img/atm.png',
                            //         width: 60, height: 60)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, left: 5),
                                        child: Text("BCA",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic))),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            top: 14, left: 5),
                                        child: Text("ORCA",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(top: 8, left: 5),
                                    child: Text("50658251",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        // child: confirmButton(),
        color: Colors.white,
      ),
    );
  }
}
