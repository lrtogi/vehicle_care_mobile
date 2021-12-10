class BookingModel {
  final String transaction_id;
  final String transaction_date;
  final String package_id;
  final String package_name;
  final String order_date;
  final String customer_vehicle_id;
  final String vehicle_name;
  final String total_price;
  final String status;

  BookingModel(
      this.transaction_id,
      this.transaction_date,
      this.package_id,
      this.package_name,
      this.order_date,
      this.customer_vehicle_id,
      this.vehicle_name,
      this.total_price,
      this.status);
}
