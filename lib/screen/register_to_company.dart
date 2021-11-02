// @dart = 2.9
import 'package:flutter/material.dart';
import 'package:vehicle_care_2/blocs/company_bloc.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/models/company_model.dart';
import 'package:vehicle_care_2/screen/home_screen.dart';
import 'package:vehicle_care_2/screen/left_bar.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:vehicle_care_2/services/company_service.dart';

class RegisterToCompany extends StatefulWidget {
  // RegisterToCompany({Key key}) : super(key: key);

  @override
  _RegisterToCompanyState createState() => _RegisterToCompanyState();
}

class _RegisterToCompanyState extends State<RegisterToCompany> {
  final _bloc = CompanyBloc();
  SearchBar _searchBar;
  LeftBar leftBar = LeftBar();
  CompanyService _companyService = CompanyService();
  Auth _auth = Auth();

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  var _companyData;
  var _workerData;

  Screen size;
  bool _obscureText = true;
  bool _loadData = false;
  bool _showList = true;

  @override
  void initState() {
    super.initState();
    _getWorkerData();
    _bloc.fetchLocationVisitTrackingData("");
  }

  _getWorkerData() async {
    setState(() {
      _loadData = false;
    });
    var _result = await _companyService.getWorkerData();
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _companyData = _result['company'];
        _workerData = _result['data'];
        _showList = false;
      });
    } else {
      setState(() {
        _loadData = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('List Company'),
        actions: [_searchBar.getSearchAction(context)]);
  }

  void onSearchValue(String value) {
    _bloc.fetchLocationVisitTrackingData(value);
  }

  _RegisterToCompanyState() {
    _searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: onSearchValue,
        onCleared: () {
          onSearchValue("");
        },
        onClosed: () {
          onSearchValue("");
        });
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
        key: _scaffoldKey,
        appBar: _showList
            ? _searchBar.build(context)
            : AppBar(title: Text("Registration to Company")),
        drawer: leftBar,
        body: _loadData
            ? Center(child: CircularProgressIndicator())
            : !_showList
                ? _haveApplication()
                : StreamBuilder(
                    stream: _bloc.allCompanyData,
                    builder: (context, AsyncSnapshot<CompanyModel> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.listDataItemList.length > 0) {
                          return _buildList(snapshot);
                        } else {
                          return Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    right: 20.0, left: 20.0, top: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                        visible: false,
                                        child: Text('List Company',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      SizedBox(
                                        height: size.hp(2),
                                      ),
                                      Text(
                                        "No data available",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: "NunitoSans"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      return Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Color(0xff000000))));
                    }));
  }

  Widget _buildList(AsyncSnapshot<CompanyModel> snapshot) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 20.0, left: 20.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                  visible: false,
                  child: Text('List Company',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(
                  left: size.wp(2),
                  right: size.wp(2),
                  top: size.hp(1),
                  bottom: size.hp(1.5)),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    var result = {
                      "companyId":
                          snapshot.data.listDataItemList[index].companyId,
                      "companyName":
                          snapshot.data.listDataItemList[index].companyName,
                      "picEmail":
                          snapshot.data.listDataItemList[index].picEmail,
                      "noTelp": snapshot.data.listDataItemList[index].noTelp
                    };
                    _onWillPop(result);
                  },
                  child: Container(
                      child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: size.wp(2.5), vertical: size.hp(1.3)),
                          borderOnForeground: true,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 16, bottom: 16, top: 16),
                            child: Text(
                              '${snapshot.data.listDataItemList[index].companyName}',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ))),
                );
              },
              itemCount: snapshot.data.listDataItemList.length),
        )
      ],
    );
  }

  Widget _haveApplication() {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: size.hp(2), vertical: size.hp(2)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text("Company Name",
                          style: TextStyle(
                              fontFamily: "NunitoSans", fontSize: 17))),
                  Expanded(
                      flex: 5,
                      child: Text(_companyData['company_name'],
                          style:
                              TextStyle(fontFamily: "NunitoSans", fontSize: 17),
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
                      child: Text("PIC Email",
                          style: TextStyle(
                              fontFamily: "NunitoSans", fontSize: 17))),
                  Expanded(
                      flex: 5,
                      child: Text(_companyData['pic_email'],
                          style:
                              TextStyle(fontFamily: "NunitoSans", fontSize: 17),
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
                      child: Text("Company Phone Number",
                          style: TextStyle(
                              fontFamily: "NunitoSans", fontSize: 17))),
                  Expanded(
                      flex: 5,
                      child: Text(_companyData['no_telp'],
                          style:
                              TextStyle(fontFamily: "NunitoSans", fontSize: 17),
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
                      child: Text("Alamat Perusahaan",
                          style: TextStyle(
                              fontFamily: "NunitoSans", fontSize: 17))),
                  Expanded(
                      flex: 5,
                      child: Text(_companyData['alamat_perusahaan'],
                          style:
                              TextStyle(fontFamily: "NunitoSans", fontSize: 17),
                          textAlign: TextAlign.end))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 0, right: 22, top: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        _removeApplication();
                      },
                      style: ElevatedButton.styleFrom(
                          onPrimary: const Color(0xffff0000),
                          shadowColor: const Color(0xffff0000),
                          elevation: 18,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xffff0000), Color(0xffff0000)]),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          width: 200,
                          height: 50,
                          alignment: Alignment.center,
                          child: const Text(
                            'Cancel Application',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ])),
      ],
    );
  }

  _removeApplication() async {
    setState(() {
      _loadData = true;
    });
    var _result =
        await _companyService.removeApplication(_workerData['worker_id']);
    if (_result['result']) {
      _showSnackBar(_result['message']);
      setState(() {
        _loadData = false;
      });
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RegisterToCompany()));
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  Future<bool> _onWillPop(result) async {
    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'Are you sure to register for company ' +
                    result['companyName'] +
                    ' ?\nPlease Contact their admin\nEmail : ' +
                    result['picEmail'] +
                    '\nPhone Number : ' +
                    result['noTelp'],
                style: TextStyle(fontFamily: "NunitoSans"),
              ),
              title: Text(
                "Confirmation",
                style: TextStyle(fontFamily: "NunitoSans"),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          fontFamily: "NunitoSansBold", color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop(
                        false); // Pops the confirmation dialog but not the page.
                  },
                ),
                FlatButton(
                  child: Text('REGISTER',
                      style: TextStyle(
                          fontFamily: "NunitoSans", color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _registerToCompany(result['companyId']);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  _registerToCompany(company_id) async {
    // setState(() {
    //   _loadData = true;
    // });
    var _result = await _companyService.registerToCompany(company_id);
    if (_result['result']) {
      _showSnackBar(_result['message']);
      setState(() {
        _loadData = false;
      });
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RegisterToCompany()));
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBar(_result['message']);
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(text, style: TextStyle(fontFamily: "NunitoSans")),
        behavior: SnackBarBehavior.floating,
        elevation: 5.0));
  }
}
