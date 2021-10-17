import 'package:flutter/material.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class AddVehicleScreen extends StatefulWidget {
  AddVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _policeNumberController = TextEditingController();
  var _selectVehicleType;
  var _listVehicleType = [
    {'vehicle_id': '123123123123', 'vehicle_type': 'Test Name'},
    {}
  ];
  bool _loadData = false;
  ProfileService _profileService = ProfileService();

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
                            value: value['vehicle_id'],
                            child: Text(
                              value['vehicle_type'],
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
                            'police_number': _policeNumberController.text
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

  _checkData({Map? datas}) async {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      _saveData(datas!);
    } else {
      setState(() {});
    }
  }

  _saveData(Map? datas) async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.saveVehicle(datas!);
    setState(() {
      _loadData = false;
    });
    if (_result['result']) {
      _showSnackBar(_result['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } else {
      _showSnackBar(_result['message']);
      setState(() {
        _loadData = false;
      });
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(text, style: TextStyle(fontFamily: "NunitoSans")),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0));
  }
}
