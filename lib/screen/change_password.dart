import 'package:flutter/material.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/services/profile_service.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  LeftBar leftBar = LeftBar();
  ProfileService _profileService = ProfileService();
  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmationPassword = TextEditingController();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late Screen size;
  bool _obscureText = true;
  bool _loadData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Change Password')),
        key: _scaffoldKey,
        body: _loadData
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: TextFormField(
                            obscureText: _obscureText,
                            enabled: true,
                            controller: _currentPassword,
                            decoration: new InputDecoration(
                                labelText: 'Current Password',
                                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please fill current password";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: TextFormField(
                            obscureText: _obscureText,
                            enabled: true,
                            controller: _newPassword,
                            decoration: new InputDecoration(
                                labelText: 'New Password',
                                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please fill new password";
                              } else {
                                if (e.length < 8) {
                                  return "Please input minimal 8 characters";
                                }
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: TextFormField(
                            obscureText: _obscureText,
                            enabled: true,
                            controller: _confirmationPassword,
                            decoration: new InputDecoration(
                                labelText: 'Confirmation Password',
                                labelStyle: TextStyle(fontFamily: "NunitoSans"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (e) {
                              if (e!.isEmpty) {
                                return "Please fill confirmation password";
                              } else {
                                if (e != _newPassword.text) {
                                  return 'Password does not match';
                                } else
                                  return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: RaisedButton(
                            onPressed: () {
                              Map data = {
                                'current_password': _currentPassword.text,
                                'new_password': _newPassword.text
                              };
                              FocusScope.of(context).unfocus();
                              _changePassword(creds: data);
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
                            color: Color(0xff0692CB),
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      ],
                    )),
              ),
        drawer: leftBar);
  }

  _changePassword({required Map creds}) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _loadData = true;
      });
      var _result = await _profileService.changePassword(creds);
      if (_result['result']) {
        setState(() {
          _loadData = false;
          _currentPassword.text = "";
          _newPassword.text = "";
          _confirmationPassword.text = "";
        });
        _showSnackBar(_result['message']);
      } else {
        setState(() {
          _loadData = false;
        });
        _showSnackBar(_result['message']);
      }
    } else {
      setState(() {});
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(text, style: TextStyle(fontFamily: "NunitoSans")),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0));
  }
}
