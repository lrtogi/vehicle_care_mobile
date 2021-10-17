import 'package:flutter/material.dart';

class AddVehicleScreen extends StatefulWidget {
  AddVehicleScreen({Key? key}) : super(key: key);

  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Vehicle"),
        ),
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 777),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: TextFormField(
                // controller: _controllerAddress,
                decoration: new InputDecoration(
                  labelText: 'Address',
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
                maxLines: 3,
              ),
            ),
          ],
        ));
  }
}
