import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/repositories/location_repository.dart';
import '../models/country_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  List<CountryModel> _countries = [];

  @override
  List<String> getCities(String countryName, String departmentName) {
    final country = _countries.firstWhere(
      (country) => country.name == countryName,
      orElse: () => const CountryModel(name: '', departments: []),
    );

    final department = country.departments.firstWhere(
      (dept) => dept.name == departmentName,
      orElse: () => const DepartmentModel(name: '', cities: []),
    );

    return department.cities;
  }

  @override
  List<String> getCountries() {
    return _countries.map((country) => country.name).toList();
  }

  @override
  List<String> getDepartments(String countryName) {
    final country = _countries.firstWhere(
      (country) => country.name == countryName,
      orElse: () => const CountryModel(name: '', departments: []),
    );
    return country.departments.map((dept) => dept.name).toList();
  }

  @override
  Future<void> loadLocations() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/location_data.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    _countries = (jsonData['countries'] as List)
        .map((countryJson) => CountryModel.fromJson(countryJson))
        .toList();
  }
}
