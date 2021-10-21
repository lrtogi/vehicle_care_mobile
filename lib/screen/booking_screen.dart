import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/services/profile_service.dart';
import 'package:vehicle_care_2/services/transaction_service.dart';

class BookingScreen extends StatefulWidget {
  String company_id;
  String company_name;
  DateTime date;
  String vehicle_id;
  BookingScreen(
      {Key? key,
      required this.company_id,
      required this.company_name,
      required this.date,
      required this.vehicle_id});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late DateTime _datePicker;
  TextEditingController _controllerDate = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  ProfileService _profileService = ProfileService();
  TransactionService _transactionService = TransactionService();
  var _hariIni = DateTime.now().day;
  var _bulanIni = DateTime.now().month;
  var _listVehicle = [];
  var _selectVehicle;
  var _listPackage = [];
  var _selectPackage;
  late Screen size;
  bool _loadData = false;
  var _jobList = [];
  String _messageEmpty = '';
  late List<Widget> widgets;

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

    _datePicker = _dateTime;
    var _formatter = DateFormat("dd-MM-yyyy");
    _controllerDate.text = _formatter.format(_dateTime);
    print(_controllerDate.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking ' + widget.company_name)),
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 13, right: 13, top: 16),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: Colors.blueAccent,
                    ),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      _selectStartDate(context);
                    }),
                labelText: 'Date',
                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
              onChanged: (newVal) {
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Please choose your vehicle',
                  labelStyle:
                      TextStyle(fontFamily: 'NunitoSans', color: Colors.black),
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
              onChanged: (newVal) {
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Please choose a package',
                  labelStyle:
                      TextStyle(fontFamily: 'NunitoSans', color: Colors.black),
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
                if (e!.isEmpty) {
                  return "Please fill name first";
                } else {
                  return null;
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      var formatter = new DateFormat('dd-MM-yyyy');
      print(formatter.format(picked));
      setState(() {
        _datePicker = picked;
        _controllerDate.text = formatter.format(picked);
      });
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
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
  }
}
