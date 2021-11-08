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
  late int _status;
  late String _police_number;
  late String _customer_name;
  late String _order_date;

  var _jobData = [];
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  bool _loadData = false;

  late List<int> imageBytes;
  late File _fileAfterResize;
  File? imageFile;

  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.getJobDetail(widget.transaction_id);
    if (_result['result']) {
      if (this.mounted) {
        setState(() {
          _order_date = _result['data']['order_date'];
          _vehicle_name = _result['data']['vehicle_name'];
          _customer_name = _result['data']['customer_name'];
          _police_number = _result['data']['police_number'];
          _package_name = _result['data']['package_name'];
          _status = _result['data']['status'];
        });
      }
      if (_result['data']['vehicle_photo_url'] != null) {
        final dir = await path_provider.getTemporaryDirectory();
        _fileAfterResize = File("${dir.absolute.path}/vehicleJob.png");
        final ByteData imageData = await NetworkAssetBundle(Uri.parse(
                "${BaseUrl.imageUrl}" + _result['data']['vehicle_photo_url']))
            .load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _fileAfterResize.writeAsBytesSync(bytes);
        final targetPath = dir.absolute.path + "/vehicleJob.jpg";
        final imgFile =
            await testCompressAndGetFile(_fileAfterResize, targetPath);
        if (this.mounted) {
          setState(() {
            imageFile = imgFile!;
          });
        }
      }
      if (this.mounted) {
        setState(() {
          _loadData = false;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          _loadData = false;
          _showSnackBarFailed(_result['message']);
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        appBar: AppBar(title: Text('Detail Job')),
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
                                        child: Text("Order Date",
                                            style: TextStyle(
                                                fontFamily: "NunitoSans",
                                                fontSize: 17))),
                                    Expanded(
                                        flex: 5,
                                        child: Text(_order_date,
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
                                                    child: Image.file(
                                                        imageFile!,
                                                        width: 250)),
                                              ],
                                            )),
                                      ),
                                SizedBox(height: 8),
                                _status == 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            Container(
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    _startJob();
                                                  },
                                                  padding: EdgeInsets.only(
                                                      top: 12, bottom: 12),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  color: Colors.blueAccent,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text("Start",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "NuntioSans",
                                                              color: Colors
                                                                  .white)),
                                                    ],
                                                  )),
                                            ),
                                          ])
                                    : _status == 3
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                                _status == 2
                                                    ? SizedBox(height: 0)
                                                    : Container(
                                                        child: RaisedButton(
                                                            onPressed: () {
                                                              _finishJob();
                                                            },
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 12,
                                                                    bottom: 12),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25)),
                                                            color: Colors.green,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text("Finish",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "NuntioSans",
                                                                        color: Colors
                                                                            .white)),
                                                              ],
                                                            )),
                                                      ),
                                                _status == 1
                                                    ? SizedBox(height: 0)
                                                    : Container(
                                                        child: RaisedButton(
                                                            onPressed: () {
                                                              _backToProcessJob();
                                                            },
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 20,
                                                                    left: 20,
                                                                    top: 12,
                                                                    bottom: 12),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25)),
                                                            color: Colors
                                                                .redAccent,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    "Rollback Process",
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "NuntioSans",
                                                                        color: Colors
                                                                            .white)),
                                                              ],
                                                            )),
                                                      ),
                                              ]),
                              ]))
                    ],
                  )));
  }

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 100);
    return result;
  }

  _finishJob() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.changeJobStatus(widget.transaction_id, 2);
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _showSnackBarSuccess(_result['message']);
        _refreshPage();
      });
    } else {
      setState(() {
        _loadData = false;
        _showSnackBarFailed(_result['message']);
      });
    }
  }

  _startJob() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.changeJobStatus(widget.transaction_id, 1);
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _showSnackBarSuccess(_result['message']);
        _refreshPage();
      });
    } else {
      setState(() {
        _loadData = false;
        _showSnackBarFailed(_result['message']);
      });
    }
  }

  _backToProcessJob() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.changeJobStatus(widget.transaction_id, 1);
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _showSnackBarSuccess(_result['message']);
        _refreshPage();
      });
    } else {
      setState(() {
        _loadData = false;
        _showSnackBarFailed(_result['message']);
      });
    }
  }

  _showSnackBarSuccess(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
    _refreshPage();
  }

  _refreshPage() {
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WorkerJobDetailScreen(
                  transaction_id: widget.transaction_id)));
    });
  }

  _showSnackBarFailed(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }
}
