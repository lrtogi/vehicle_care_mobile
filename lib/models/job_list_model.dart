class JobListModel {
  JobListModel({
    required this.result,
    required this.message,
    required this.data,
  });
  late final bool result;
  late final String message;
  late final List<Data> data;

  JobListModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    required this.customerName,
    required this.orderDate,
    required this.packageName,
  });
  late final String customerName;
  late final String orderDate;
  late final String packageName;

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    orderDate = json['order_date'];
    packageName = json['package_name'];
  }
}
