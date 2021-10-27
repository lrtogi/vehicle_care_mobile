// @dart = 2.9

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_care_2/constant/responsive_screen.dart';
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/services/payment_service.dart';
import 'package:vehicle_care_2/services/profile_service.dart';
import 'package:vehicle_care_2/services/transaction_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class PaymentScreen extends StatefulWidget {
  String transaction_id;
  String payment_id;
  PaymentScreen({Key key, this.transaction_id, this.payment_id});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _date;
  String _price;
  String _vehicle;
  String _package;
  TextEditingController _paymentController = TextEditingController();
  PaymentService _paymentService = PaymentService();
  TransactionService _transactionService = TransactionService();
  Screen size;
  String _url = "${BaseUrl.imageUrl}";
  bool _loadData = false;
  bool _processImage = false;
  List<int> imageBytes;
  File _fileAfterResize;
  File imageFile;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _getDetailTransaction();
    if (widget.payment_id != '') {
      _getDetailPayment();
    }
  }

  _getDetailTransaction() async {
    setState(() {
      _loadData = true;
    });
    var _result =
        await _paymentService.getDetailTransaction(widget.transaction_id);
    print(_result);
    if (_result['result']) {
      setState(() {
        _loadData = false;
        _vehicle = _result['data']['vehicle_name'];
        _date = _result['data']['order_date'];
        _package = _result['data']['package_name'];
        _price = _result['data']['total_price'];
      });
    } else {
      setState(() {
        _loadData = false;
      });
    }
  }

  _getDetailPayment() async {
    setState(() {
      _loadData = true;
      _processImage = true;
    });
    var _result = await _paymentService.getDetailPayment(widget.payment_id);
    print(_result);
    if (_result['result']) {
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
          imageFile = imgFile;
        });
      }
      setState(() {
        _paymentController.text = _result['data']['total_payment'];
        _loadData = false;
        _processImage = false;
      });
    } else {
      setState(() {
        _loadData = false;
        _processImage = false;
      });
      _showSnackBarFailed(_result['message']);
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
                            children: [
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
                                      child: Text(_date,
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
                                      child: Text("Vehicle",
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontSize: 17))),
                                  Expanded(
                                      flex: 5,
                                      child: Text(_vehicle,
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
                                      child: Text("Package",
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontSize: 17))),
                                  Expanded(
                                      flex: 5,
                                      child: Text(_package,
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
                                      child: Text("Price to pay",
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontSize: 17))),
                                  Expanded(
                                      flex: 5,
                                      child: Text(_price,
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
                                      child: Text("Your payment : ",
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontSize: 17))),
                                  SizedBox(
                                      width: 130,
                                      height: 35,
                                      child: Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          controller: _paymentController,
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.all(10),
                                            labelStyle: TextStyle(
                                                fontFamily: "NunitoSans"),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          keyboardType: TextInputType.number,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                        ),
                                      )),
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
                                      child: Text("Payment Picture : ",
                                          style: TextStyle(
                                              fontFamily: "NunitoSans",
                                              fontSize: 17))),
                                  imageFile != null
                                      ? SizedBox(height: 35)
                                      : SizedBox(
                                          width: 130,
                                          height: 35,
                                          child: RaisedButton(
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                              _showPicker(context);
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Text('Take a picture',
                                                style: TextStyle(
                                                    fontFamily:
                                                        "NunitoSansBold",
                                                    color: Color(0xffffffff),
                                                    fontSize: 13)),
                                            color: Color(0xffa3a3a3),
                                            // padding:
                                            //     EdgeInsets.only(top: 16, bottom: 16),
                                          ),
                                        ),
                                ],
                              ),
                              SizedBox(height: size.hp(1.5)),
                              imageFile == null
                                  ? SizedBox(height: 8)
                                  : _processImage
                                      ? CircularProgressIndicator()
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
                                                          imageFile)),
                                                  Positioned(
                                                      child:
                                                          // InkWell(
                                                          //     child: Image.asset(
                                                          //         "images/close.webp",
                                                          //         width: 25,
                                                          //         height: 25),
                                                          //     onTap: () {
                                                          //       setState(() {
                                                          //         imageFile = null;
                                                          //         imageCache.clear();
                                                          //         _fileAfterResize = null;
                                                          //       });
                                                          //     }),
                                                          IconButton(
                                                              icon: Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              onPressed: () {
                                                                setState(() {
                                                                  imageFile =
                                                                      null;
                                                                  imageCache
                                                                      .clear();
                                                                  _fileAfterResize =
                                                                      null;
                                                                });
                                                              }),
                                                      right: 4,
                                                      top: 4),
                                                ],
                                              )),
                                        ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 0, right: 22, top: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _checkData();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          onPrimary: const Color(0xff4f1ed2),
                                          shadowColor: const Color(0xff4f1ed2),
                                          elevation: 18,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xff4f1ed2),
                                                Color(0xff4f1ed2)
                                              ]),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          width: 80,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Save',
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
                )),
    );
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Are you sure your payment is correct?",
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
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('CONFIRM',
                      style: TextStyle(
                          fontFamily: "NunitoSans", color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    _saveData();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  _checkData() {
    setState(() {
      _loadData = true;
    });
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _loadData = false;
      });
      var _message = '';
      if (_paymentController.text == '') {
        _showSnackBarFailed('Please input your paynent');
      } else if (imageFile == null) {
        _showSnackBarFailed("Please take a picture of your payment");
      } else
        _onWillPop();
    } else {
      setState(() {
        _loadData = false;
      });
    }
  }

  _saveData() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _paymentService.savePayment(widget.payment_id,
        widget.transaction_id, _paymentController.text, imageFile);
    if (_result['result']) {
      setState(() {
        _loadData = false;
      });
      _showSnackBarSuccess(_result['message']);
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBarFailed(_result['message']);
    }
  }

  _takePicture() async {
    setState(() {
      _processImage = true;
    });
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    if (image != null) {
      List<int> imageBytes = image.readAsBytesSync();
      final dir = await path_provider.getTemporaryDirectory();

      _fileAfterResize = File("${dir.absolute.path}/payment.png");
      _fileAfterResize.writeAsBytesSync(imageBytes);

      final targetPath = dir.absolute.path + "/payment.jpg";
      final imgFile =
          await testCompressAndGetFile(_fileAfterResize, targetPath);

      setState(() {
        imageFile = imgFile;
        _processImage = false;
      });
    } else {
      print("Tidak ada image dipilih");
    }
  }

  _galleryPicture() async {
    setState(() {
      _processImage = true;
    });
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    if (image != null) {
      imageBytes = image.readAsBytesSync();
      final dir = await path_provider.getTemporaryDirectory();

      _fileAfterResize = File("${dir.absolute.path}/payment.png");
      _fileAfterResize.writeAsBytesSync(imageBytes);

      final targetPath = dir.absolute.path + "/payment.jpg";
      final imgFile =
          await testCompressAndGetFile(_fileAfterResize, targetPath);

      setState(() {
        imageFile = imgFile;
        _processImage = false;
      });
    } else {
      print("Tidak ada image dipilih");
    }
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 70, minHeight: 170, minWidth: 113);
    return result;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _galleryPicture();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _takePicture();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showSnackBarSuccess(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
    _goBackTimer();
  }

  _showSnackBarFailed(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(text), behavior: SnackBarBehavior.floating));
  }

  _goBackTimer() {
    setState(() {});
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
