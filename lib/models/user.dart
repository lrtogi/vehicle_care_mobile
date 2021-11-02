// @dart=2.9
class User {
  String name;
  String username;
  String email;
  String user_id;
  String customer_id;
  String company_id;

  User(
      {this.name,
      this.username,
      this.email,
      this.customer_id,
      this.user_id,
      this.company_id});

  User.fromJson(Map<String, dynamic> json)
      : name = json['customer_name'],
        email = json['email'],
        username = json['username'],
        customer_id = json['customer_id'],
        user_id = json['user_id'],
        company_id = json['company_id'];
}
