import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import '../helpers/user_helpers.dart';

class UserInfoWidget extends StatelessWidget {
  final User user;

  const UserInfoWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _buildCardContainer(child: _buildCardContent(context));
  }

  Widget _buildAvatarContent() {
    return Center(
      child: Text(
        UserHelpers.getInitials(user.fullName),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  BoxDecoration _buildAvatarDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(100),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildUserHeader(context), _buildUserInfoSection()],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 18),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: _buildAvatarDecoration(context),
      child: _buildAvatarContent(),
    );
  }

  Widget _buildUserDetails() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildUserName(), const SizedBox(height: 4), _buildUserId()],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context) {
    return Row(
      spacing: 16,
      children: [_buildUserAvatar(context), _buildUserDetails()],
    );
  }

  Widget _buildUserId() {
    return Text(
      'ID: ${user.id}',
      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      spacing: 12,
      children: [
        _buildInfoRow(
          icon: Icons.cake_outlined,
          label: 'Fecha de Nacimiento',
          value: UserHelpers.formatBirthDate(user.birthDate),
        ),

        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Edad',
          value: '${UserHelpers.calculateAge(user.birthDate)} años',
        ),

        _buildInfoRow(
          icon: Icons.location_on_outlined,
          label: 'Direcciones',
          value: UserHelpers.formatAddressCount(user.addresses.length),
        ),
      ],
    );
  }

  Widget _buildUserName() {
    return Text(
      user.fullName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
        fontSize: 20,
      ),
    );
  }
}
