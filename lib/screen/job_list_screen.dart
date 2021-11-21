import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/models/job_list_model.dart';
import 'package:vehicle_care_2/screen/booking_screen.dart';
import 'package:vehicle_care_2/services/job_service.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class JobList extends StatefulWidget {
  String company_id;
  String company_name;
  JobList({Key? key, required this.company_id, required this.company_name});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late DateTime _datePicker;
  TextEditingController _controllerDate = TextEditingController();
  ProfileService _profileService = ProfileService();
  JobService _jobService = JobService();
  var _hariIni = DateTime.now().day;
  var _bulanIni = DateTime.now().month;
  var _listVehicleType = [];
  var _selectVehicleType;
  late Screen size;
  bool _loadData = false;
  var _jobList = [];
  String _messageEmpty = '';
  late List<Widget> widgets;

  @override
  void initState() {
    super.initState();
    _getVehicleType();
    var _dateTime = DateTime.now();
    _datePicker = _dateTime;
    var _formatter = DateFormat("dd-MM-yyyy");
    _controllerDate.text = _formatter.format(_dateTime);
  }

  Widget bodydata() => ChangeNotifierProvider<JobService>(
      create: (context) => JobService(),
      child: Consumer<JobService>(
        builder: (context, provider, child) {
          if (provider.jobListModel == null) {
            provider.searchJob(
                widget.company_id, _controllerDate.text, _selectVehicleType);
            return Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            // scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 25.0,
              columns: [
                DataColumn(label: Text('Index')),
                DataColumn(
                    label: Flexible(
                        child: Text(
                  'Customer Name',
                ))),
                DataColumn(label: Text('Package Name')),
                DataColumn(label: Text('Status'))
              ],
              rows: _jobService.jobListModel.data
                  .map((data) => DataRow(cells: [
                        DataCell(Flexible(
                            child: Text(
                          data.index.toString(),
                          overflow: TextOverflow.ellipsis,
                        ))),
                        DataCell(Flexible(child: Text(data.customerName))),
                        DataCell(Text(data.packageName)),
                        DataCell(Text(data.status))
                      ]))
                  .toList(),
            ),
          );
        },
      ));

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Job List "),
        ),
        body: Column(children: <Widget>[
          Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              child: Column(
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      controller: _controllerDate,
                      onTap: () {
                        _selectStartDate(context);
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: DropdownButtonFormField<String>(
                      value: _selectVehicleType,
                      onChanged: (newVal) {
                        setState(() {
                          _selectVehicleType = newVal;
                        });
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
                          labelText: 'Please choose vehicle type',
                          labelStyle: TextStyle(
                              fontFamily: 'NunitoSans', color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                      items: _listVehicleType.map((value) {
                        return DropdownMenuItem<String>(
                          value: value['vehicle_id'].toString(),
                          child: Text(
                            value['vehicle_type'].toString(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(left: 13, right: 13),
                    child: RaisedButton(
                        onPressed: () {
                          _searchData();
                        },
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        color: Color(0xff0377fc),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Find",
                                style: TextStyle(
                                    fontFamily: "NuntioSans",
                                    color: Colors.white)),
                          ],
                        )),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
          _jobList.isEmpty
              ? Center(
                  child: Text(_messageEmpty,
                      style: TextStyle(
                          fontFamily: "NunitoSansBold", fontSize: 21)))
              : bodydata(),
          Container(
            margin: EdgeInsets.only(left: 13, right: 13),
            child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookingScreen(
                                transaction_id: '',
                                company_id: widget.company_id,
                                company_name: widget.company_name,
                                date: _datePicker,
                                vehicle_id: '',
                              )));
                },
                padding: EdgeInsets.only(top: 12, bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Color(0xff0377fc),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Book Now",
                        style: TextStyle(
                            fontFamily: "NuntioSans", color: Colors.white)),
                  ],
                )),
          ),
        ]));
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1965, _bulanIni, _hariIni),
        lastDate: DateTime(2101));
    if (picked != null) {
      var formatter = new DateFormat('dd-MM-yyyy');
      setState(() {
        _datePicker = picked;
        _controllerDate.text = formatter.format(picked);
      });
    }
  }

  _searchData() async {
    setState(() {
      _loadData = true;
    });
    _loadData = true;
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      var _result = await _jobService.searchJob(
          widget.company_id, _controllerDate.text, _selectVehicleType);
      if (_result['result']) {
        if (_result['data'].isEmpty) {
          setState(() {
            _jobList = [];
            _loadData = false;
            _messageEmpty = "No data";
          });
        } else {
          setState(() {
            _loadData = false;
            _jobList = _result['data'];
            widgets = _jobList
                .map((name) => new Text(name['customer_name']))
                .toList();
          });
        }
      } else {
        setState(() {
          _loadData = false;
        });
        _showSnackBar(_result['message']);
      }
    } else {
      _loadData = false;
      setState(() {});
    }
  }

  _getVehicleType() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.getVehicleType();
    if (_result['result']) {
      setState(() {
        _listVehicleType = _result['data']['data'];
        _loadData = false;
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
  }
}
