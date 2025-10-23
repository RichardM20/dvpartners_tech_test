import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';
import 'address_form.dart';
import '../buttons/button.dart';

class AddressesFormSectionWidget extends StatelessWidget {
  final List<Address> addresses;
  final Function(int, Address) onAddressChanged;
  final Function(int) onAddressRemoved;
  final VoidCallback onAddAddress;
  final bool isDisabled;

  const AddressesFormSectionWidget({
    super.key,
    required this.addresses,
    required this.onAddressChanged,
    required this.onAddressRemoved,
    required this.onAddAddress,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Direcciones:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Button.icon(
              icon: Icons.add,
              onTap: isDisabled ? null : onAddAddress,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...addresses.asMap().entries.map((entry) {
          final index = entry.key;
          final address = entry.value;
          return AddressFormWidget(
            index: index,
            address: address,
            onChanged: isDisabled
                ? null
                : (updatedAddress) => onAddressChanged(index, updatedAddress),
            onRemove: isDisabled ? null : () => onAddressRemoved(index),
            isDisabled: isDisabled,
          );
        }),
      ],
    );
  }
}
