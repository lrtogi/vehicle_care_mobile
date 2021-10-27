// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/models/customer_vehicle_model.dart';
import 'package:vehicle_care_2/services/profile_service.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AddVehicleScreen extends StatefulWidget {
  final String customer_vehicle_id;
  const AddVehicleScreen({Key key, this.customer_vehicle_id});
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  List<int> imageBytes;
  File _fileAfterResize;
  File imageFile;
  String _imageUrl = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();
  final _vehicleNameController = TextEditingController();
  final _policeNumberController = TextEditingController();
  var _selectVehicleType;
  var _result;
  String _url = "${BaseUrl.imageUrl}";
  List<dynamic> _listVehicleType = List();
  bool _loadData = false;
  bool _processImage = false;
  ProfileService _profileService = ProfileService();
  var _customer_vehicle_id;

  @override
  void initState() {
    super.initState();
    setState(() {
      _imageUrl = "";
      imageFile = null;
    });
    _customer_vehicle_id = widget.customer_vehicle_id;
    _getVehicleType();
    if (widget.customer_vehicle_id != null) {
      _getData();
    }
  }

  _getData() async {
    setState(() {
      _loadData = true;
      _processImage = true;
    });
    var _result =
        await _profileService.getVehicleDetail(widget.customer_vehicle_id);
    if (_result['result']) {
      if (_result['data']['vehicle_photo_url'] != null) {
        final dir = await path_provider.getTemporaryDirectory();
        _fileAfterResize = File("${dir.absolute.path}/vehicle.png");
        final ByteData imageData = await NetworkAssetBundle(Uri.parse(
                "${BaseUrl.imageUrl}" + _result['data']['vehicle_photo_url']))
            .load("");
        final Uint8List bytes = imageData.buffer.asUint8List();
        _fileAfterResize.writeAsBytesSync(bytes);
        final targetPath = dir.absolute.path + "/vehicleTemp.jpg";
        final imgFile =
            await testCompressAndGetFile(_fileAfterResize, targetPath);
        setState(() {
          imageFile = imgFile;
        });
      }

      setState(() {
        _selectVehicleType = _result['data']['vehicle_id'];
        _vehicleNameController.text = _result['data']['vehicle_name'];
        _policeNumberController.text = _result['data']['police_number'];
        _imageUrl = _result['data']['vehicle_photo_url'];
        _processImage = false;
        _loadData = false;
      });
    } else {
      setState(() {
        _loadData = false;
        _processImage = true;
      });
      _showSnackBarFailed(_result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Vehicle"),
        ),
        body: _loadData
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _key,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: DropdownButtonFormField<String>(
                        value: _selectVehicleType,
                        onChanged: (newVal) {
                          setState(() {
                            _selectVehicleType = newVal;
                          });
                        },
                        validator: (e) {
                          if (e == null) {
                            return "Choose request";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Please choose vehicle type',
                            labelStyle: TextStyle(
                                fontFamily: 'NunitoSans', color: Colors.grey),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10)),
                        items: _listVehicleType.map((value) {
                          return DropdownMenuItem<String>(
                            value: value['vehicle_id'].toString(),
                            child: Text(
                              value['vehicle_type'].toString(),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 777),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        controller: _vehicleNameController,
                        decoration: new InputDecoration(
                          labelText: 'Vehicle Name',
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
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 777),
                    Container(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: TextFormField(
                        controller: _policeNumberController,
                        decoration: new InputDecoration(
                          labelText: 'Police Number',
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
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                        margin: EdgeInsets.only(right: 16, left: 16, top: 16),
                        child: Text("Vehicle Picture",
                            style: TextStyle(
                                fontFamily: "NunitoSans", fontSize: 18))),
                    SizedBox(height: 8),
                    imageFile == null
                        ? Container(
                            margin:
                                EdgeInsets.only(right: 16, left: 16, top: 16),
                            child: RaisedButton(
                              onPressed: () {
                                _showPicker(context);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Take a picture',
                                      style: TextStyle(
                                          fontFamily: "NunitoSansBold",
                                          color: Color(0xffffffff),
                                          fontSize: 19)),
                                ],
                              ),
                              color: Color(0xffa3a3a3),
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                            ),
                          )
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
                                                BorderRadius.circular(8.0),
                                            child: Image.file(imageFile)),
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
                                                    icon: Icon(Icons.delete,
                                                        color: Colors.red),
                                                    onPressed: () {
                                                      setState(() {
                                                        imageFile = null;
                                                        imageCache.clear();
                                                        _fileAfterResize = null;
                                                      });
                                                    }),
                                            right: 4,
                                            top: 4)
                                      ],
                                    )),
                              ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 22, top: 16),
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
                        _customer_vehicle_id == null
                            ? SizedBox(height: 8)
                            : Container(
                                margin: const EdgeInsets.only(
                                    left: 20, right: 22, top: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _onWillPop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.red,
                                      shadowColor: Colors.red,
                                      elevation: 18,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Colors.red,
                                        Colors.red,
                                      ]),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Container(
                                      width: 80,
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Delete',
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
                  ],
                ))));
  }

  Future<bool> _onWillPop() async {
    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                'Are you sure to delete this vehicle?\nData will be lost\n',
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
                  child: Text('DELETE',
                      style: TextStyle(
                          fontFamily: "NunitoSans", color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteVehicle();
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  _getVehicleType() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.getVehicleType();
    if (_result['result']) {
      setState(() {
        _listVehicleType = _result['data']['data'];
        _loadData = false;
      });
    } else {
      setState(() {
        _loadData = false;
      });
      _showSnackBarFailed(_result['message']);
    }
  }

  _deleteVehicle() async {
    setState(() {
      _loadData = true;
    });
    var _result = await _profileService.deleteVehicle(_customer_vehicle_id);
    if (_result['result']) {
      _showSnackBarSuccess(_result['message']);
      _vehicleNameController.text = "";
      _policeNumberController.text = "";
      _selectVehicleType = null;
      imageFile = null;
      setState(() {
        _loadData = false;
      });
    } else {
      _showSnackBarFailed(_result['message']);
      setState(() {
        _loadData = false;
      });
    }
  }

  _checkData() async {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      _saveData(_vehicleNameController.text, _policeNumberController.text,
          _selectVehicleType, imageFile);
    } else {
      setState(() {});
    }
  }

  _saveData(String vehicle_name, String police_number, String vehicle_id,
      File picture) async {
    setState(() {
      _loadData = true;
    });
    String base64Image = '';
    if (picture != null) {
      List<int> imageBytes = picture.readAsBytesSync();
      base64Image = base64.encode(imageBytes);
    }
    var _result = await _profileService.saveVehicle(
        _customer_vehicle_id, vehicle_name, police_number, vehicle_id, picture);
    setState(() {
      _loadData = false;
    });
    if (_result['result']) {
      _showSnackBarSuccess(_result['message']);
    } else {
      _showSnackBarFailed(_result['message']);
      setState(() {
        _loadData = false;
      });
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

      _fileAfterResize = File("${dir.absolute.path}/vehicle.png");
      _fileAfterResize.writeAsBytesSync(imageBytes);

      final targetPath = dir.absolute.path + "/vehicleTemp.jpg";
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

      _fileAfterResize = File("${dir.absolute.path}/vehicle.png");
      _fileAfterResize.writeAsBytesSync(imageBytes);

      final targetPath = dir.absolute.path + "/vehicleTemp.jpg";
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
    setState(() {
      _policeNumberController.text = "";
      _vehicleNameController.text = "";
      _selectVehicleType = null;
    });
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }
}
