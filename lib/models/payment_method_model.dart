class PaymentMethodModel {
  List<PaymentMethodItem> _listDataItemList = [];

  PaymentMethodModel.fromJson(List<dynamic> parsedJson) {
    List<PaymentMethodItem> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      PaymentMethodItem result = PaymentMethodItem(parsedJson[i]);
      temp.add(result);
    }
    _listDataItemList = temp;
  }

  List<PaymentMethodItem> get listDataItemList => _listDataItemList;
}

class PaymentMethodItem {
  late String _method;
  late String _value;
  late String _on_behalf_of;
  bool _isExpanded = false;

  PaymentMethodItem(result) {
    _method = result['method'];
    _value = result['value'];
    _on_behalf_of = result['on_behalf_of'];
  }

  String get method => _method;

  String get value => _value;

  String get on_behalf_of => _on_behalf_of;

  bool get isExpanded => _isExpanded;
}
