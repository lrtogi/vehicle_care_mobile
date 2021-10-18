class CustomerVehicleModel {
  List<VehicleItem> _listDataItemList = [];

  CustomerVehicleModel.fromJson(List<dynamic> parsedJson) {
    List<VehicleItem> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      VehicleItem result = VehicleItem(parsedJson[i]);
      temp.add(result);
    }
    _listDataItemList = temp;
  }

  List<VehicleItem> get listDataItemList => _listDataItemList;
}

class VehicleItem {
  late String _customer_vehicle_id;
  late String _vehicle_id;
  late String _vehicle_name;
  late String _police_number;
  late String _vehicle_photo_url;

  VehicleItem(result) {
    _customer_vehicle_id = result['leave_id'];
    _vehicle_id = result['reason'];
    _vehicle_name = result['flag_approve'];
    _police_number = result['leave_type'];
    _vehicle_photo_url = result['start_hour'];
  }

  String get vehicle_photo_url => _vehicle_photo_url;

  String get customer_vehicle_id => _customer_vehicle_id;

  String get vehicle_id => _vehicle_id;

  String get vehicle_name => _vehicle_name;

  String get police_number => _police_number;
}
