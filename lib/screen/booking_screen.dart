// @dart = 2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/services/profile_service.dart';
import 'package:vehicle_care_2/services/transaction_service.dart';

class BookingScreen extends StatefulWidget {
  String transaction_id;
  String company_id;
  String company_name;
  DateTime date;
  String vehicle_id;
  BookingScreen(
      {Key key,
      this.transaction_id,
      this.company_id,
      this.company_name,
      this.date,
      this.vehicle_id});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _datePicker;
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  ProfileService _profileService = ProfileService();
  TransactionService _transactionService = TransactionService();
  bool _editable = true;
  var _hariIni = DateTime.now().day;
  var _bulanIni = DateTime.now().month;
  var _listVehicle = [];
  var _selectVehicle;
  var _listPackage = [];
  var _selectPackage;
  Screen size;
  bool _loadData = false;
  var _jobList = [];
  String _messageEmpty = '';
  List<Widget> widgets;

  @override
  void initState() {
    super.initState();
    _getVehicleList();
    var _dateTime = DateTime.now();
    if (widget.date.isBefore(DateTime.now())) {
      _dateTime = DateTime.now();
    } else {
      _dateTime = widget.date;
    }

    if (widget.transaction_id != '') {
      _getDetailTransaction();
    }

    _datePicker = _dateTime;
    var _formatter = DateFormat("dd-MM-yyyy");
    _controllerDate.text = _formatter.format(_dateTime);
  }

  _getDetailTransaction() async {
    var _result =
        await _transactionService.getDetailTransaction(widget.transaction_id);
    if (_result['result']) {
      setState(() {
        _editable = _result['editable'];
        _selectVehicle = _result['data']['customer_vehicle_id'];
        _getPackageList();
        _controllerDate.text = _result['data']['order_date'];
        _selectPackage = _result['data']['package_id'];
        _priceController.text = _result['data']['total_price'];
      });
    } else {
      _showSnackBar(_result['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking ' + widget.company_name)),
      key: _scaffoldKey,
      body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 13, right: 13, top: 16),
                child: TextFormField(
                  enabled: _editable,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          Icons.date_range_rounded,
                          color: Colors.blueAccent,
                        ),
                        splashColor: Colors.blueAccent,
                        onPressed: () {
                          if (_editable) _selectStartDate(context);
                        }),
                    labelText: 'Date',
                    labelStyle: TextStyle(fontFamily: "NunitoSans"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  controller: _controllerDate,
                  onTap: () {
                    _selectStartDate(context);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectVehicle,
                  onChanged: _editable == false
                      ? null
                      : (newVal) {
                          setState(() {
                            _selectVehicle = newVal;
                          });
                          _getPackageList();
                        },
                  validator: (e) {
                    if (e == null) {
                      return "Choose vehicle";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      enabled: _editable,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      labelText: 'Please choose your vehicle',
                      labelStyle: TextStyle(
                          fontFamily: 'NunitoSans', color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  items: _listVehicle.map((value) {
                    return DropdownMenuItem<String>(
                      value: value['customer_vehicle_id'].toString(),
                      child: Text(
                        value['vehicle_name'].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: DropdownButtonFormField<String>(
                  value: _selectPackage,
                  onChanged: _editable == false
                      ? null
                      : (newVal) {
                          setState(() {
                            _selectPackage = newVal;
                            _getPrice();
                          });
                        },
                  validator: (e) {
                    if (e == null) {
                      return "Choose package";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      enabled: _editable,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      labelText: 'Please choose a package',
                      labelStyle: TextStyle(
                          fontFamily: 'NunitoSans', color: Colors.black),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                  items: _listPackage.map((value) {
                    return DropdownMenuItem<String>(
                      value: value['package_id'].toString(),
                      child: Text(
                        value['package_name'].toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: TextFormField(
                  enabled: false,
                  controller: _priceController,
                  decoration: new InputDecoration(
                      labelText: 'Price',
                      labelStyle: TextStyle(fontFamily: "NunitoSans"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (e) {
                    if (e.isEmpty) {
                      return "Please fill name first";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              SizedBox(height: 8),
              _editable == false
                  ? SizedBox(height: 0)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 22),
                            child: RaisedButton(
                                onPressed: () {
                                  _validation();
                                },
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: Color(0xff0377fc),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Save",
                                        style: TextStyle(
                                            fontFamily: "NuntioSans",
                                            color: Colors.white)),
                                  ],
                                )),
                          ),
                          widget.transaction_id == ''
                              ? SizedBox(height: 0)
                              : Container(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 22),
                                  child: RaisedButton(
                                      onPressed: () {
                                        _onWillPop(
                                            "Are you sure to delete this vehicle?\nData will be lost\n",
                                            2);
                                      },
                                      padding:
                                          EdgeInsets.only(top: 12, bottom: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      color: Color(0xffff0000),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text("Delete",
                                              style: TextStyle(
                                                  fontFamily: "NuntioSans",
                                                  color: Colors.white)),
                                        ],
                                      )),
                                ),
                        ]),
            ],
          )),
    );
  }

  Future<bool> _onWillPop(String text, int index) async {
    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                text,
                style: TextStyle(fontFamily: "NunitoSans"),
              ),
              title: Text(
                "Confirmation",
                style: TextStyle(fontFamily: "NunitoSans"),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          fontFamily: "NunitoSansBold", color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // Pops the confirmation dialog but not the page.
                  },
                ),
                FlatButton(
                  child: Text('CONFIRM',
                      style: TextStyle(
                          fontFamily: "NunitoSans", color: Colors.black)),
                  onPressed: () {
                    if (index == 1) {
                      Navigator.of(context).pop();
                      _booking();
                    } else {
                      Navigator.of(context).pop();
                      _deleteData();
                    }
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      var formatter = new DateFormat('dd-MM-yyyy');
      setState(() {
        _datePicker = picked;
        _controllerDate.text = formatter.format(picked);
      });
    }
  }

  _validation() {
    setState(() {
      _loadData = true;
    });
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _loadData = false;
      });
      var _message = '';
      if (widget.transaction_id != '') {
        _message =
            "Make sure you submit the data correctly? Data will be saved\n";
      } else {
        _message =
            "Make sure you submit the data correctly? Data will be saved\n";
      }
      _onWillPop(_message, 1);
    } else {
      setState(() {
        _loadData = false;
      });
    }
  }

  _booking() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _transactionService.saveTransaction(
        widget.transaction_id,
        _selectVehicle,
        _selectPackage,
        _controllerDate.text,
        widget.company_id);
    if (_result['result']) {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  _deleteData() async {
    setState(() {
      _loadData = true;
    });
    var _result =
        await _transactionService.deleteTransaction(widget.transaction_id);
    if (_result['result']) {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  _getVehicleList() async {
    setState(() {
      _loadData = true;
    });

    var _result = await _profileService.getVehicle();
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _listVehicle = _result['data']['data'];
      });
    } else {
      setState(() {
        _loadData = false;
      });
      // _showSnackBar(_result['message']);
    }
  }

  _getPackageList() async {
    setState(() {
      _loadData = true;
      _listPackage = [];
      _selectPackage = null;
      _priceController.text = '';
    });

    var _result =
        await _transactionService.getPackage(widget.company_id, _selectVehicle);
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _listPackage = _result['data'];
      });
    } else {
      setState(() {
        _priceController.text = '';
        _listPackage = [];
        _loadData = false;
      });
      // _showSnackBar(_result['message']);
    }
  }

  _getPrice() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _transactionService.getDetailPackage(_selectPackage);
    if (_result['result']) {
      setState(() {
        _priceController.text = _result['data']['discounted_price'];
        _loadData = false;
      });
    } else {
      setState(() {
        _priceController.text = '';
        _loadData = false;
      });
    }
  }

  _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
  }
}
