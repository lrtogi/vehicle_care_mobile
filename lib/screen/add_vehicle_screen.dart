// @dart=2.9
import 'package:flutter/material.dart';
import 'package:vehicle_care_2/models/customer_vehicle_model.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class AddVehicleScreen extends StatefulWidget {
  // AddVehicleScreen({Key? key}) : super(key: key);
  final int idPage;
  final VehicleItem itemVehicle;
  const AddVehicleScreen({this.idPage, this.itemVehicle});
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _policeNumberController = TextEditingController();
  var _selectVehicleType;
  List<dynamic> _listVehicleType = List();
  bool _loadData = false;
  ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _getVehicleType();
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Vehicle"),
        ),
        body: _loadData
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            return "Choose request";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Please choose vehicle type',
                            labelStyle: TextStyle(
                                fontFamily: 'NunitoSans', color: Colors.grey),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
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
                    SizedBox(height: MediaQuery.of(context).size.height / 777),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        controller: _vehicleNameController,
                        decoration: new InputDecoration(
                          labelText: 'Vehicle Name',
                          labelStyle: TextStyle(fontFamily: "NunitoSans"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.text,
                        // focusNode: _focusNodeAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill address first";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 777),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        controller: _policeNumberController,
                        decoration: new InputDecoration(
                          labelText: 'Police Number',
                          labelStyle: TextStyle(fontFamily: "NunitoSans"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.text,
                        // focusNode: _focusNodeAddress,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please fill address first";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 20, right: 22, top: 16),
                      child: ElevatedButton(
                        onPressed: () {
                          Map datas = {
                            'vehicle_name': _vehicleNameController.text,
                            'police_number': _policeNumberController.text,
                            'vehicle_id': _selectVehicleType
                          };
                          _checkData(datas: datas);
                        },
                        style: ElevatedButton.styleFrom(
                            onPrimary: const Color(0xff4f1ed2),
                            shadowColor: const Color(0xff4f1ed2),
                            elevation: 18,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [Color(0xff4f1ed2), Color(0xff4f1ed2)]),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: 80,
                            height: 50,
                            alignment: Alignment.center,
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )));
  }

  _getVehicleType() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.getVehicleType();
    if (_result['result']) {
      setState(() {
        print(_result['data']);
        _listVehicleType = _result['data']['data'];
        _loadData = false;
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBarFailed(_result['message']);
    }
  }

  _checkData({Map datas}) async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      print(datas);
      _saveData(datas);
    } else {
      setState(() {});
    }
  }

  _saveData(Map datas) async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.saveVehicle(datas);
    setState(() {
      _loadData = false;
    });
    if (_result['result']) {
      _showSnackBarSuccess(_result['message']);
    } else {
      _showSnackBarFailed(_result['message']);
      setState(() {
        _loadData = false;
      });
    }
  }

  _showSnackBarSuccess(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
    _goBackTimer();
  }

  _showSnackBarFailed(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
  }

  _goBackTimer() {
    setState(() {
      _policeNumberController.text = "";
      _vehicleNameController.text = "";
      _selectVehicleType = null;
    });
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
