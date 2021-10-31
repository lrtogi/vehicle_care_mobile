import "package:flutter/material.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/animation/fade_animation.dart';
import 'package:vehicle_care_2/screen/register_screen.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  bool _loadCheckData = false;
  bool _autoValidate = false;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Auth _auth = Auth();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    _checkIsLoggedIn();
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
                height: 300,
                child: SvgPicture.asset(
                  "images/wave8.svg",
                  fit: BoxFit.fill,
                ),
              ),
              // ! 0x00FFFFFF
              const Positioned(
                top: 100,
                left: 45,
                child: FadeAnimation(
                  2,
                  Text(
                    "Vehicle Care",
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
                          height: 240,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          label: Text("Password ..."),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                              'email': _emailController.text,
                              'password': _passwordController.text,
                              'device_name': 'mobile'
                            };
                            _checkLogin(creds: creds);
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
                                'Login',
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                          },
                          child: new Text(
                            "SingUp if don't have account ",
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

  _checkLogin({required Map creds}) async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _loadCheckData = true;
      });
      var _result = await _auth.checkLogin(creds: creds);
      if (_result['result']) {
        setState(() {
          _loadCheckData = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
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

  _checkIsLoggedIn() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      var _result = await auth.tryToken(token: token);
      setState(() {
        _loadCheckData = true;
      });
      if (_result['result']) {
        setState(() {
          _loadCheckData = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        _loadCheckData = false;
      }
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(text, style: TextStyle(fontFamily: "NunitoSans")),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0));
  }
}
