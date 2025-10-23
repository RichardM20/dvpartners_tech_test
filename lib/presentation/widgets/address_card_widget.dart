import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';

class AddressCardWidget extends StatelessWidget {
  final int number;
  final Address address;

  const AddressCardWidget({
    super.key,
    required this.number,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCardContainer(child: _buildCardContent(context));
  }

  Widget _buildAddressBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: _buildBadgeDecoration(context),
      child: _buildBadgeText(context),
    );
  }

  Widget _buildAddressHeader(BuildContext context) {
    return Row(children: [_buildAddressBadge(context)]);
  }

  Widget _buildAddressInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'No especificado' : value,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfoSection() {
    return Column(
      children: [
        _buildAddressInfoRow('País', address.country),
        _buildAddressInfoRow('Departamento', address.department),
        _buildAddressInfoRow('Municipio', address.municipality),
      ],
    );
  }

  BoxDecoration _buildBadgeDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
    );
  }

  Widget _buildBadgeText(BuildContext context) {
    return Text(
      'Dirección $number',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressHeader(context),
        const SizedBox(height: 12),
        _buildAddressInfoSection(),
      ],
    );
  }
}
