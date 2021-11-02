import 'package:rxdart/rxdart.dart';
import 'package:vehicle_care_2/db/repository.dart';
import 'package:vehicle_care_2/models/payment_method_model.dart';
import 'package:vehicle_care_2/services/payment_service.dart';

class PaymentBloc {
  Repository _repository = Repository();
  PaymentService _companyService = PaymentService();
  final _paymentMethodData = PublishSubject<PaymentMethodModel>();
  Stream<PaymentMethodModel> get allCompanyData => _paymentMethodData.stream;

  fetchPaymentMethodData(String value) async {
    PaymentMethodModel _paymentMethodModel =
        await _repository.fetchPaymentMethodData(value);
    _paymentMethodData.sink.add(_paymentMethodModel);
  }

  dispose() {
    _paymentMethodData.close();
  }
}
