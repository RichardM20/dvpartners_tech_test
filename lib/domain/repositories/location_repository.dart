abstract class LocationRepository {
  List<String> getCities(String countryName, String departmentName);
  List<String> getCountries();
  List<String> getDepartments(String countryName);
  Future<void> loadLocations();
}
