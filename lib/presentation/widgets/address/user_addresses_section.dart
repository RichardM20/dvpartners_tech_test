import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';
import 'address_card.dart';

class UserAddressesSectionWidget extends StatelessWidget {
  final User user;

  const UserAddressesSectionWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.addresses.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 12,
            children: [
              Icon(Icons.location_off, size: 48, color: Colors.grey[400]),

              Text(
                'No hay direcciones registradas',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'Direcciones',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        ...user.addresses.asMap().entries.map((entry) {
          final index = entry.key;
          final address = entry.value;
          return AddressCardWidget(number: index + 1, address: address);
        }),
      ],
    );
  }
}
