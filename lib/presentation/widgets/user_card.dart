import 'package:flutter/material.dart';

import '../../domain/entities/user.dart';
import 'helpers/user_helpers.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return _buildCardContainer(child: _buildCardContent(context));
  }

  Widget _buildAddressInfo() {
    return _buildInfoRow(
      icon: Icons.location_on_outlined,
      text: UserHelpers.formatAddressCount(user.addresses.length),
      iconSize: 18,
    );
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

  Widget _buildBirthDateInfo() {
    return _buildInfoRow(
      icon: Icons.cake_outlined,
      text: 'Nacido: ${UserHelpers.formatBirthDate(user.birthDate)}',
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Row(
      children: [
        _buildUserAvatar(context),
        const SizedBox(width: 16),
        _buildUserInfo(),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    double iconSize = 16,
  }) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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

  Widget _buildUserInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserName(),
          const SizedBox(height: 4),
          _buildAddressInfo(),
          const SizedBox(height: 2),
          _buildBirthDateInfo(),
        ],
      ),
    );
  }

  Widget _buildUserName() {
    return Text(
      user.fullName,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    );
  }
}
