import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_care_2/screen/edit_profile.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';
import 'package:vehicle_care_2/screen/login_screen.dart';
import 'package:vehicle_care_2/screen/vehicle_screen.dart';
import 'package:vehicle_care_2/services/auth.dart';

class LeftBar extends StatefulWidget {
  LeftBar({Key? key}) : super(key: key);
  Auth auth = Auth();

  @override
  _LeftBarState createState() => _LeftBarState();
  leftBar() {
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
            ListTile(
                title: Text("Edit Profile"),
                leading: Icon(Icons.edit),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => EditProfile()));
                }),
            ListTile(
                title: Text("Your Vehicle"),
                leading: Icon(Icons.motorcycle),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => VehicleScreen()));
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

class _LeftBarState extends State<LeftBar> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
