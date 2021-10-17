import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/animation/fade_animation.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  bool _loadCheckData = false;
  bool _autoValidate = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Auth _auth = Auth();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _confirmationPasswordController =
      TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                color: const Color(0xff0692CB),
                // color: const Color(0xFFC73800),
                width: wid,
                height: 120,
              ),
              // ! 0x00FFFFFF
              const Positioned(
                top: 50,
                left: 45,
                child: FadeAnimation(
                  2,
                  Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
                  ),
                ),
              )
            ],
          ),
          // ! Here input

          Expanded(
              child: Form(
            key: _formKey,
            child: Container(
              color: const Color(0xff0692CB),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FadeAnimation(
                      2,
                      Container(
                          width: double.infinity,
                          // height: 610,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: const BoxDecoration(
                              // border: Border.all(
                              //     color: const Color(0xff4f1ed2), width: 1),
                              // boxShadow: const [
                              //   BoxShadow(
                              //       color: Color(0xff4f1ed2),
                              //       blurRadius: 10,
                              //       offset: Offset(1, 1)),
                              // ],
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.person_outline),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input username';
                                          }
                                          if (value.contains(' ')) {
                                            return 'No space allowed';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Username"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.email),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: _emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input email';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("E-mail"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.text_format),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: _fullNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input full name';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Full Name"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.password_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        obscureText: _obscureText,
                                        maxLines: 1,
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input password';
                                          }
                                          if (value.length < 8) {
                                            return 'Password length minimal 8 chars';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Text(" Password ..."),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.password_outlined),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        obscureText: _obscureText,
                                        maxLines: 1,
                                        controller:
                                            _confirmationPasswordController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input confirmation password';
                                          }
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Password does not match';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Text(" Confirmation Password"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.text_fields),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: _addressController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input address';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Address"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.phone),
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input phone number';
                                          }
                                          if (num.tryParse(value) == null) {
                                            return 'Please input number only';
                                          }
                                          return null;
                                        },
                                        maxLines: 1,
                                        decoration: const InputDecoration(
                                          label: Text("Phone number"),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 5,
                                thickness: 3,
                                indent: 50,
                                endIndent: 50,
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      2,
                      Container(
                        margin: const EdgeInsets.only(left: 22, right: 22),
                        child: ElevatedButton(
                          onPressed: () {
                            Map creds = {
                              'username': _usernameController.text,
                              'email': _emailController.text,
                              'password': _passwordController.text,
                              'fullname': _fullNameController.text,
                              'cpassword': _confirmationPasswordController.text,
                              'address': _addressController.text,
                              'no_telp': _phoneController.text,
                              'device_name': 'mobile'
                            };
                            _register(creds: creds);
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
                              gradient: const LinearGradient(colors: [
                                Color(0xff4f1ed2),
                                Color(0xff4f1ed2)
                              ]),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: wid - 20,
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: new GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _register({required Map creds}) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _loadCheckData = true;
      });
      var _result = await _auth.registration(creds: creds);
      print(_result);
      if (_result['result']) {
        setState(() {
          _loadCheckData = false;
        });
        _showSnackBar(_result['message']);
        Future.delayed(Duration(seconds: 1), () {
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashboardPage(kpi: _result['kpi'], access: _result['pic'])), (Route <dynamic> route) => false);
          Navigator.pop(context, true);
        });
      } else {
        print(_result);
        setState(() {
          _loadCheckData = false;
        });
        _showSnackBar(_result['message']);
      }
    } else {
      setState(() {
        _autoValidate = true;
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
