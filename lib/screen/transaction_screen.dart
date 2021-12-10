import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/booking_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/screen/payment_list_screen.dart';
import 'package:vehicle_care_2/screen/payment_screen.dart';
import 'package:vehicle_care_2/services/transaction_service.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  LeftBar leftBar = LeftBar();
  bool _loadData = false;
  var _listTransaction = [];
  var _choise = ['Pay'];
  String _messageEmpty = '';
  late Screen size;
  TransactionService _transactionService = TransactionService();

  void initState() {
    super.initState();
    _getList();
  }

  _getList() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _transactionService.getListTransaction('1');
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _listTransaction = _result['data'];
        if (_listTransaction.isEmpty) {
          _messageEmpty = "No Transaction";
        }
      });
    } else {
      setState(() {
        _loadData = false;
        _messageEmpty = "No Transaction";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      appBar: AppBar(
        title: Text("List Transaction"),
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
                  : _listTransaction.isEmpty
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
                                                      '${DateFormat('dd-MM-yyyy').format(DateTime.parse(_listTransaction[index]['order_date']))}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              "NunitoSansBold",
                                                          fontSize: 20,
                                                          color: Colors.black)),
                                                ),
                                              ),
                                              SizedBox(width: 0.0, height: 0.0),
                                              PopupMenuButton<String>(
                                                  onSelected: (item) =>
                                                      _onSelected(
                                                          item,
                                                          _listTransaction[
                                                                  index][
                                                              'transaction_id']),
                                                  itemBuilder:
                                                      (BuildContext context) {
                                                    // _listTransaction[index]
                                                    //             ['status'] ==
                                                    //         2
                                                    //     ? _choise.contains(
                                                    //             'Show Job')
                                                    //         ? ''
                                                    //         : _choise
                                                    //             .add('Show Job')
                                                    //     : _choise.removeWhere(
                                                    //         (item) =>
                                                    //             item ==
                                                    //             'Show Job');
                                                    return _choise
                                                        .map((String choise) {
                                                      return PopupMenuItem<
                                                              String>(
                                                          value: choise,
                                                          child: Text(choise));
                                                    }).toList();
                                                  }),
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
                                                        overflow: TextOverflow
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
                          itemCount: _listTransaction.length))
        ],
      ),
      drawer: leftBar,
    );
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => TransactionScreen()));
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
