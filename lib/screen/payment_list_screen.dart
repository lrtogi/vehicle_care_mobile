import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/company_menu.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/screen/payment_screen.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';
import 'package:vehicle_care_2/services/payment_service.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class PaymentList extends StatefulWidget {
  String transaction_id;
  PaymentList({Key? key, required this.transaction_id});

  @override
  _PaymentListState createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {
  PaymentService _paymentService = PaymentService();
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  bool _loadData = false;
  var _listPayment = [];
  late Screen size;
  String _messageEmpty = "";
  var _choise = ["Pay"];

  void initState() {
    super.initState();
    _getPaymentList();
  }

  _getPaymentList() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _paymentService.getPaymentList(widget.transaction_id);
    if (_result['result']) {
      setState(() {
        _listPayment = _result['data'];
        _loadData = false;
        if (_listPayment.isEmpty) {
          _messageEmpty = "No Payment List";
        }
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
      appBar: AppBar(
        title: Text("Payment List"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8),
          Expanded(
              child: _loadData
                  ? Center(child: CircularProgressIndicator())
                  : _listPayment.isEmpty
                      ? Center(
                          child: Text(_messageEmpty,
                              style: TextStyle(
                                  fontFamily: "NunitoSansBold", fontSize: 21)))
                      : ListView.builder(
                          padding: EdgeInsets.only(
                              left: size.wp(2),
                              right: size.wp(2),
                              top: size.wp(3),
                              bottom: size.hp(1.5)),
                          itemBuilder: (context, index) {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                                payment_id: _listPayment[index]
                                                    ['payment_id'],
                                                transaction_id:
                                                    _listPayment[index]
                                                        ['transaction_id'])))
                                    .then(onGoBack);
                                ;
                              },
                              child: ListTile(
                                  isThreeLine: true,
                                  title:
                                      Text(_listPayment[index]['payment_date']),
                                  subtitle: Text(_listPayment[index]
                                          ['total_payment'] +
                                      "\nStatus : " +
                                      _listPayment[index]['approved']),
                                  leading: Icon(Icons.payment),
                                  trailing: Icon(Icons.arrow_right)),
                            ));
                          },
                          itemCount: _listPayment.length))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: _loadData
            ? Container(child: Center(child: CircularProgressIndicator()))
            : Padding(
                padding: EdgeInsets.only(
                    top: size.hp(2),
                    bottom: size.hp(2),
                    left: size.wp(2.5),
                    right: size.wp(2.5)),
                child: RaisedButton(
                    onPressed: () {
                      _goToPayment();
                    },
                    padding:
                        EdgeInsets.only(top: size.hp(2), bottom: size.hp(2)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Color(0xff0692CB),
                    child: Text("Add Payment",
                        style: TextStyle(
                            fontFamily: "NuntioSans", color: Colors.white))),
              ),
      ),
    );
  }

  _goToPayment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentScreen(
                payment_id: '',
                transaction_id: widget.transaction_id))).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PaymentList(transaction_id: widget.transaction_id)));
  }
}
