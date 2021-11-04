import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/services/job_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class WorkerJobDetailScreen extends StatefulWidget {
  String transaction_id;
  WorkerJobDetailScreen({Key? key, required this.transaction_id});

  @override
  _WorkerJobDetailScreenState createState() => _WorkerJobDetailScreenState();
}

class _WorkerJobDetailScreenState extends State<WorkerJobDetailScreen> {
  JobService _jobService = JobService();
  late Screen size;
  late String _vehicle_name;
  late String _package_name;
  late bool _status;
  late String _police_number;
  late String _customer_name;

  var _jobData = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  bool _loadData = false;

  late List<int> imageBytes;
  late File _fileAfterResize;
  late File imageFile;

  void initState() {
    super.initState();
  }

  _getData() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.getJobDetail(widget.transaction_id);
    if (_result['result']) {
      setState(() async {
        _jobData = _result['data'];
        _vehicle_name = _result['data']['vehicle_name'];
        _customer_name = _result['data']['customer_name'];
        _police_number = _result['data']['police_number'];
        _status = _result['data']['status'];
        if (_result['data']['file'] != null) {
          final dir = await path_provider.getTemporaryDirectory();
          _fileAfterResize = File("${dir.absolute.path}/payment.png");
          final ByteData imageData = await NetworkAssetBundle(
                  Uri.parse("${BaseUrl.imageUrl}" + _result['data']['file']))
              .load("");
          final Uint8List bytes = imageData.buffer.asUint8List();
          _fileAfterResize.writeAsBytesSync(bytes);
          final targetPath = dir.absolute.path + "/payment.jpg";
          final imgFile =
              await testCompressAndGetFile(_fileAfterResize, targetPath);
          setState(() {
            imageFile = imgFile!;
          });
        }
        _loadData = false;
      });
    } else {
      setState(() {
        _loadData = false;
        _showSnackBarFailed(_result['message']);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        appBar: AppBar(title: Text('Payment')),
        key: _scaffoldKey,
        body: Form(
            key: _formKey,
            child: _loadData == true
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: <Widget>[
                      SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.hp(2), vertical: size.hp(2)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text("Customer Name",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(_customer_name,
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17),
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: size.hp(1.5)),
                                Divider(color: Colors.black, height: 1),
                                SizedBox(height: size.hp(1.5)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text("Vehicle Name",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(_vehicle_name,
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17),
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: size.hp(1.5)),
                                Divider(color: Colors.black, height: 1),
                                SizedBox(height: size.hp(1.5)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text("Police Number",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(_police_number,
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17),
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: size.hp(1.5)),
                                Divider(color: Colors.black, height: 1),
                                SizedBox(height: size.hp(1.5)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text("Package Type",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(_package_name,
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17),
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: size.hp(1.5)),
                                Divider(color: Colors.black, height: 1),
                                SizedBox(height: size.hp(1.5)),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text("Status",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(
                                            _status == 0
                                                ? 'Waiting to process'
                                                : _status == 1
                                                    ? 'On Process'
                                                    : _status == 2
                                                        ? 'Finished'
                                                        : 'Taken',
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17),
                                            textAlign: TextAlign.end))
                                  ],
                                ),
                                SizedBox(height: size.hp(1.5)),
                                imageFile == null
                                    ? SizedBox(height: 8)
                                    : Center(
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: 16, left: 16, top: 16),
                                            child: Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child:
                                                        Image.file(imageFile)),
                                              ],
                                            )),
                                      ),
                              ]))
                    ],
                  )));
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70, minHeight: 170, minWidth: 113);
    return result;
  }

  _showSnackBarSuccess(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
    _refreshPage();
  }

  _refreshPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkerJobDetailScreen(transaction_id: widget.transaction_id)));
  }

  _showSnackBarFailed(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }
}
