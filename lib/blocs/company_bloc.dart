import 'package:rxdart/rxdart.dart';
import 'package:vehicle_care_2/db/repository.dart';
import 'package:vehicle_care_2/models/company_model.dart';
import 'package:vehicle_care_2/services/company_service.dart';

class CompanyBloc {
  Repository _repository = Repository();
  CompanyService _companyService = CompanyService();
  final _companyData = PublishSubject<CompanyModel>();
  Stream<CompanyModel> get allCompanyData => _companyData.stream;

  fetchLocationVisitTrackingData(String value) async {
    CompanyModel _companyModel =
        await _repository.fetchLocationVisitTrackingData(value);
    _companyData.sink.add(_companyModel);
  }

  dispose() {
    _companyData.close();
  }
}
