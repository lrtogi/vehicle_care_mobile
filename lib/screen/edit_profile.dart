import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  ProfileService _profileService = ProfileService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _focusNodeEmail = FocusNode();
  final _focusNodeName = FocusNode();
  final _focusNodeAddress = FocusNode();
  final _focusNodePhone = FocusNode();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  var _result;
  LeftBar leftBar = LeftBar();
  bool _loadData = false;
  var primaryColor = const Color(0xff0692CB);

  @override
  void initState() {
    super.initState();
    _getData();
    readToken();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');
    var _result = await auth.tryToken(token: token);
    if (!_result['result']) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      Provider.of<Auth>(context, listen: false).tryToken(token: token);
      // SharedPreferences _preferences = await SharedPreferences.getInstance();
      setState(() {
        // _customerName = _preferences.getString("customer_name");
        // _customerEmail = _preferences.getString("email");
        _loadData = false;
      });
    }
  }

  _getData() async {
    setState(() {
      _loadData = true;
    });
    _result = await _profileService.getProfile();
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _emailController.text = _result['model']['email'];
        _nameController.text = _result['model']['customer_name'];
        _addressController.text = _result['model']['alamat'];
        _phoneController.text = _result['model']['no_telp'];
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: Container(
            child: Center(
                child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 37,
                vertical: MediaQuery.of(context).size.height / 27),
            child: _loadData
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 3.3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: TextFormField(
                                  controller: _emailController,
                                  decoration: new InputDecoration(
                                    labelText: 'Email',
                                    labelStyle:
                                        TextStyle(fontFamily: "NunitoSans"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Please fill name first";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 777),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: new InputDecoration(
                                    labelText: 'Name',
                                    labelStyle:
                                        TextStyle(fontFamily: "NunitoSans"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  focusNode: _focusNodeName,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Please fill name first";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 777),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: TextFormField(
                                  controller: _addressController,
                                  decoration: new InputDecoration(
                                    labelText: 'Address',
                                    labelStyle:
                                        TextStyle(fontFamily: "NunitoSans"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  keyboardType: TextInputType.text,
                                  focusNode: _focusNodeAddress,
                                  textInputAction: TextInputAction.next,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  validator: (e) {
                                    if (e!.isEmpty) {
                                      return "Please fill address first";
                                    } else {
                                      return null;
                                    }
                                  },
                                  maxLines: 3,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 777),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 16, right: 16, top: 16),
                                child: TextFormField(
                                  controller: _phoneController,
                                  decoration: new InputDecoration(
                                    labelText: 'Phone',
                                    labelStyle:
                                        TextStyle(fontFamily: "NunitoSans"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  focusNode: _focusNodePhone,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please input email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 27),
                              Container(
                                margin: EdgeInsets.only(right: 16, left: 16),
                                child: RaisedButton(
                                  onPressed: () {
                                    Map data = {
                                      'email': _emailController.text,
                                      'name': _nameController.text,
                                      'no_telp': _phoneController.text,
                                      'address': _addressController.text,
                                      'device_name': 'mobile'
                                    };
                                    FocusScope.of(context).unfocus();
                                    _check(data: data);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Save',
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              color: Colors.white,
                                              fontSize: 19)),
                                    ],
                                  ),
                                  color: Color(0xff313131),
                                  padding: EdgeInsets.all(8),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 27),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ))),
        drawer: leftBar);
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(text, style: TextStyle(fontFamily: "NunitoSans")),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0));
  }

  _check({Map? data}) {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      _saveProfile(data!);
    } else {
      setState(() {});
    }
  }

  _saveProfile(Map data) async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.saveProfile(data);
    setState(() {
      _loadData = false;
    });
    if (_result['result']) {
      _showSnackBar(_result['message']);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } else {
      _showSnackBar(_result['message']);
      setState(() {
        _loadData = false;
      });
    }
  }
}
