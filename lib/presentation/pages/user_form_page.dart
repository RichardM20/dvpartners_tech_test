import 'package:dvpartners_tech_test/presentation/widgets/animation_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/injection/injection_container.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_locations_usecase.dart';
import '../cubit/user_cubit.dart';
import '../widgets/address/addresses_form_section.dart';
import '../widgets/buttons/button.dart';
import '../widgets/inputs/date_input.dart';
import '../widgets/inputs/text_input.dart';
import '../widgets/snackbar/snackbar_app.dart';

class UserFormPage extends StatefulWidget {
  final User? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  DateTime? _birthDate;
  final List<Address> _addresses = [];

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isLoading = state is UserLoading;

        return PopScope(
          canPop: !isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(isEditing ? 'Editar Usuario' : 'Crear Usuario'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              automaticallyImplyLeading: !isLoading,
            ),
            body: BlocListener<UserCubit, UserState>(
              listener: (context, state) {
                if (state is UserError) {
                  SnackBarApp.show(context, state.message, isError: true);
                } else if (state is UserLoaded) {
                  Navigator.of(context).pop();
                }
              },
              child: AbsorbPointer(
                absorbing: isLoading,
                child: Opacity(
                  opacity: isLoading ? 0.6 : 1.0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildNameFields(isLoading),

                          AnimationContainer.fromLeft(
                            child: _buildBirthDateField(isLoading),
                          ),
                          AnimationContainer.fromRight(
                            child: AddressesFormSectionWidget(
                              addresses: _addresses,
                              onAddressChanged: _updateAddress,
                              onAddressRemoved: _removeAddress,
                              onAddAddress: _addAddress,
                              isDisabled: isLoading,
                            ),
                          ),
                          const SizedBox(height: 32),
                          AnimationContainer.fromBottom(
                            child: _buildSaveButton(isEditing, isLoading),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _birthDate = user?.birthDate;
    _addresses.addAll(user?.addresses ?? []);
  }

  void _addAddress() {
    setState(() {
      _addresses.add(
        const Address(
          id: 0,
          userId: 0,
          country: '',
          department: '',
          municipality: '',
        ),
      );
    });
  }

  Widget _buildBirthDateField(bool isLoading) {
    return DateInputApp(
      label: 'Fecha de Nacimiento',
      value: _birthDate != null
          ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
          : null,
      initialDate:
          _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      onDateChanged: isLoading
          ? null
          : (date) {
              setState(() {
                _birthDate = date;
              });
            },
    );
  }

  Widget _buildNameFields(bool isLoading) {
    return Column(
      children: [
        AnimationContainer.fromTop(
          child: TextInputApp(
            label: 'Nombre',
            value: _firstNameController.text,
            onChanged: isLoading
                ? null
                : (value) {
                    _firstNameController.text = value;
                  },
          ),
        ),
        const SizedBox(height: 16),
        AnimationContainer.fromRight(
          child: TextInputApp(
            label: 'Apellido',
            value: _lastNameController.text,
            onChanged: isLoading
                ? null
                : (value) {
                    _lastNameController.text = value;
                  },
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isEditing, bool isLoading) {
    return Button.loading(
      initialText: isEditing ? 'Actualizar' : 'Crear',
      primaryText: isEditing ? 'Actualizando...' : 'Creando...',
      isLoading: isLoading,
      onTap: isLoading ? null : _saveUser,
    );
  }

  void _removeAddress(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  void _saveUser() {
    if (!_validateBasicFields()) {
      return;
    }

    if (!_validateBirthDate()) {
      return;
    }

    if (!_validateAddresses()) {
      return;
    }

    final user = User(
      id: widget.user?.id ?? 0,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthDate: _birthDate!,
      addresses: _addresses,
    );

    final cubit = context.read<UserCubit>();
    if (widget.user != null) {
      cubit.updateUser(user);
    } else {
      cubit.createUser(user);
    }
  }

  void _showError(String message) {
    SnackBarApp.show(context, message, isError: true);
  }

  void _updateAddress(int index, Address address) {
    setState(() {
      _addresses[index] = address;
    });
  }

  bool _validateAddresses() {
    if (_addresses.isEmpty) {
      _showError('Por favor agrega al menos una dirección');
      return false;
    }

    for (int i = 0; i < _addresses.length; i++) {
      final address = _addresses[i];

      if (address.country.trim().isEmpty) {
        _showError('El país es requerido en la dirección ${i + 1}');
        return false;
      }

      if (address.department.trim().isEmpty) {
        _showError('El departamento es requerido en la dirección ${i + 1}');
        return false;
      }

      if (address.municipality.trim().isEmpty) {
        _showError('El municipio es requerido en la dirección ${i + 1}');
        return false;
      }

      if (!_validateCountryExists(address.country)) {
        _showError('El país "${address.country}" no existe en la lista');
        return false;
      }

      if (!_validateDepartmentExists(address.country, address.department)) {
        _showError(
          'El departamento "${address.department}" no existe para ${address.country}',
        );
        return false;
      }

      if (!_validateCityExists(
        address.country,
        address.department,
        address.municipality,
      )) {
        _showError(
          'El municipio "${address.municipality}" no existe para ${address.department}',
        );
        return false;
      }
    }

    return true;
  }

  bool _validateBasicFields() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      _showError('Por favor completa todos los campos requeridos');
      return false;
    }

    return true;
  }

  bool _validateBirthDate() {
    if (_birthDate == null) {
      _showError('Por favor selecciona una fecha de nacimiento');
      return false;
    }

    final age = DateTime.now().difference(_birthDate!).inDays ~/ 365;
    if (age < 0) {
      _showError('La fecha no puede ser futura');
      return false;
    }
    if (age > 120) {
      _showError('La edad no puede ser mayor a 120 años');
      return false;
    }

    return true;
  }

  bool _validateCityExists(String country, String department, String city) {
    final cities = sl<GetLocationsUseCase>().getCities(country, department);
    return cities.any((c) => c.toLowerCase() == city.toLowerCase());
  }

  bool _validateCountryExists(String country) {
    final countries = sl<GetLocationsUseCase>().getCountries();
    return countries.any((c) => c.toLowerCase() == country.toLowerCase());
  }

  bool _validateDepartmentExists(String country, String department) {
    final departments = sl<GetLocationsUseCase>().getDepartments(country);
    return departments.any((d) => d.toLowerCase() == department.toLowerCase());
  }
}
