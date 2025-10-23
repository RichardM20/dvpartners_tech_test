import 'package:flutter/material.dart';

import '../../../core/injection/injection_container.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/get_locations_usecase.dart';
import '../inputs/suggestions/suggestions_input.dart';

class AddressFormWidget extends StatelessWidget {
  final int index;
  final Address address;
  final Function(Address)? onChanged;
  final VoidCallback? onRemove;
  final bool isDisabled;

  const AddressFormWidget({
    super.key,
    required this.index,
    required this.address,
    required this.onChanged,
    required this.onRemove,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dirección ${index + 1}',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              IconButton(
                onPressed: isDisabled ? null : onRemove,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          SuggestionsInputApp(
            label: 'País',
            value: address.country.isNotEmpty ? address.country : null,
            suggestions: sl<GetLocationsUseCase>().getCountries(),
            onChanged: isDisabled
                ? null
                : (value) {
                    onChanged?.call(
                      address.copyWith(
                        country: value,
                        department: '',
                        municipality: '',
                      ),
                    );
                  },
          ),
          SuggestionsInputApp(
            label: 'Departamento',
            value: address.department.isNotEmpty ? address.department : null,
            suggestions: sl<GetLocationsUseCase>().getDepartments(
              address.country,
            ),
            onChanged: isDisabled || address.country.isEmpty
                ? null
                : (value) {
                    onChanged?.call(
                      address.copyWith(department: value, municipality: ''),
                    );
                  },
          ),
          SuggestionsInputApp(
            label: 'Municipio',
            value: address.municipality.isNotEmpty
                ? address.municipality
                : null,
            suggestions: sl<GetLocationsUseCase>().getCities(
              address.country,
              address.department,
            ),
            onChanged: isDisabled || address.department.isEmpty
                ? null
                : (value) {
                    onChanged?.call(address.copyWith(municipality: value));
                  },
          ),
        ],
      ),
    );
  }
}
