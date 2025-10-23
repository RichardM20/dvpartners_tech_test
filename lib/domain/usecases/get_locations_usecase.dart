import '../repositories/location_repository.dart';

class GetLocationsUseCase {
  final LocationRepository _repository;

  GetLocationsUseCase(this._repository);

  Future<void> call() async {
    return await _repository.loadLocations();
  }

  List<String> getCities(String countryName, String departmentName) {
    return _repository.getCities(countryName, departmentName);
  }

  List<String> getCountries() {
    return _repository.getCountries();
  }

  List<String> getDepartments(String countryName) {
    return _repository.getDepartments(countryName);
  }
}
