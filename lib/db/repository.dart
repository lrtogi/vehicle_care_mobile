import 'package:vehicle_care_2/models/company_model.dart';
import 'package:vehicle_care_2/models/payment_method_model.dart';
import 'package:vehicle_care_2/services/company_service.dart';
import 'package:vehicle_care_2/services/payment_service.dart';

class Repository {
  final _companyService = CompanyService();
  final _paymentService = PaymentService();

  Future<CompanyModel> fetchLocationVisitTrackingData(String value) =>
      _companyService.getCompany(value);

  Future<PaymentMethodModel> fetchPaymentMethodData(String value) =>
      _paymentService.getPaymentMethod(value);
}
