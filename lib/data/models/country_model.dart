class CountryModel {
  final String name;
  final List<DepartmentModel> departments;

  const CountryModel({required this.name, required this.departments});

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'],
      departments: (json['departments'] as List)
          .map((deptJson) => DepartmentModel.fromJson(deptJson))
          .toList(),
    );
  }
}

class DepartmentModel {
  final String name;
  final List<String> cities;

  const DepartmentModel({required this.name, required this.cities});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      name: json['name'],
      cities: List<String>.from(json['cities']),
    );
  }
}
