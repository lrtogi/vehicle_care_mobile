class CompanyModel {
  List<CompanyItem> _listDataItemList = [];

  CompanyModel.fromJson(List<dynamic> parsedJson) {
    List<CompanyItem> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      CompanyItem result = CompanyItem(parsedJson[i]);
      temp.add(result);
    }
    _listDataItemList = temp;
  }

  List<CompanyItem> get listDataItemList => _listDataItemList;
}

class CompanyItem {
  late String _companyId;
  late String _companyName;
  late String _noTelp;
  late String _alamat;
  late String _picEmail;

  CompanyItem(result) {
    _companyId = result['company_id'];
    _companyName = result['company_name'];
    _noTelp = result['no_telp'];
    _alamat = result['alamat_perusahaan'];
    _picEmail = result['pic_email'];
  }

  String get companyId => _companyId;

  String get companyName => _companyName;

  String get picEmail => _picEmail;

  String get noTelp => _noTelp;

  String get alamat => _alamat;
}
