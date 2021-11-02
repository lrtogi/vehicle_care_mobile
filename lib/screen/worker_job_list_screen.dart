import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/screen/worker_job_detail_screen.dart';
import 'package:vehicle_care_2/services/job_service.dart';

class WorkerJobListScreen extends StatefulWidget {
  WorkerJobListScreen({Key? key}) : super(key: key);

  @override
  _WorkerJobListScreenState createState() => _WorkerJobListScreenState();
}

class _WorkerJobListScreenState extends State<WorkerJobListScreen> {
  JobService _jobService = JobService();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  late Screen size;

  bool _loadData = false;
  String _messageEmpty = '';
  var _listJob = [];

  void initState() {
    super.initState();
    _getJobList();
  }

  _getJobList() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _jobService.getWorkerJobList();
    if (_result['result']) {
      setState(() {
        _listJob = _result['data'];
        _loadData = false;
        if (_listJob.isEmpty) {
          _messageEmpty = "No Job List";
        }
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Your Job List"),
      ),
      body: _loadData
          ? Center(child: CircularProgressIndicator())
          : _listJob.isEmpty
              ? Center(
                  child: Text(_messageEmpty,
                      style: TextStyle(
                          fontFamily: "NunitoSansBold", fontSize: 21)))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
                  Expanded(
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                              left: size.wp(2),
                              right: size.wp(2),
                              top: size.wp(3),
                              bottom: size.hp(1.5)),
                          itemBuilder: (context, index) {
                            return Container(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WorkerJobDetailScreen(
                                              transaction_id: _listJob[index]
                                                  ['transaction_id'],
                                            ))).then(onGoBack);
                                ;
                              },
                              child: ListTile(
                                  isThreeLine: true,
                                  title: Text(_listJob[index]['customer_name']),
                                  subtitle: Text(_listJob[index]
                                          ['vehicle_name'] +
                                      "\nStatus : " +
                                      _listJob[index]['status']),
                                  leading: Icon(Icons.payment),
                                  trailing: Icon(Icons.arrow_right)),
                            ));
                          },
                          itemCount: _listJob.length))
                ]),
    );
  }

  FutureOr onGoBack(dynamic value) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => WorkerJobListScreen()));
  }

  _showSnackBarFailed(String text) {
    _scaffoldKey.currentState!.showSnackBar(new SnackBar(
      content: new Text(text),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }
}
