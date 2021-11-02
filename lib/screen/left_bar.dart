import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/screen/change_password.dart';
import 'package:vehicle_care_2/screen/edit_profile.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';
import 'package:vehicle_care_2/screen/job_menu.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';
import 'package:vehicle_care_2/screen/register_to_company.dart';
import 'package:vehicle_care_2/screen/transaction_screen.dart';
import 'package:vehicle_care_2/screen/vehicle_screen.dart';
import 'package:vehicle_care_2/services/auth.dart';

class LeftBar extends StatefulWidget {
  LeftBar({Key? key}) : super(key: key);

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar> {
  final storage = FlutterSecureStorage();
  Auth auth = Auth();
  bool isWorker = false;

  _checkWorker() async {
    String? token = await storage.read(key: 'token');
    var _result = await auth.tryToken(token: token);
    var _customerCompanyID = await storage.read(key: 'company_id');
    if (_customerCompanyID != null) {
      setState(() {
        isWorker = true;
      });
    } else {
      setState(() {
        isWorker = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkWorker();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(child: Consumer<Auth>(builder: (context, auth, child) {
      if (!auth.authenticated) {
        return ListView(
          children: [
            ListTile(
                title: Text("Login"),
                leading: Icon(Icons.login_rounded),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }),
          ],
        );
      } else {
        return ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(backgroundColor: Colors.white, radius: 40),
                  SizedBox(
                    height: 10,
                  ),
                  Text(auth.user.name, style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(auth.user.email, style: TextStyle(color: Colors.white)),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
                title: Text("Homepage"),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }),
            !isWorker
                ? ListTile(
                    title: Text("Register to Company"),
                    leading: Icon(Icons.app_registration),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterToCompany()));
                    })
                : ListTile(
                    title: Text("Jobs"),
                    leading: Icon(Icons.work),
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => JobMenu()));
                    }),
            ListTile(
                title: Text("Edit Profile"),
                leading: Icon(Icons.edit),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                }),
            ListTile(
                title: Text("Change Password"),
                leading: Icon(Icons.vpn_key),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                }),
            ListTile(
                title: Text("Your Vehicle"),
                leading: Icon(Icons.motorcycle),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => VehicleScreen()));
                }),
            ListTile(
                title: Text("List Transaction"),
                leading: Icon(Icons.book_online_rounded),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionScreen()));
                }),
            ListTile(
                title: Text("Logout"),
                leading: Icon(Icons.logout_rounded),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                })
          ],
        );
      }
    }));
  }
}
