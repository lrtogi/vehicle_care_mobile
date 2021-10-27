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
    required this.index,
    required this.packageName,
    required this.status,
  });
  late final String customerName;
  late final int index;
  late final String packageName;
  late final String status;

  Data.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'];
    index = json['index'];
    packageName = json['package_name'];
    status = json['status'];
  }
}
