import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final bool isLoading;

  const EmptyState({
    super.key,
    this.message = 'No data found',
    this.icon = Icons.search,
    this.color = Colors.grey,
    this.isLoading = false,
  });

  factory EmptyState.error({
    String message = 'An error occurred',
    IconData icon = Icons.error_outline,
    Color color = Colors.red,
  }) {
    return EmptyState(message: message, icon: icon, color: color);
  }

  factory EmptyState.loading() {
    return const EmptyState(isLoading: true);
  }

  factory EmptyState.noData({
    String message = 'No data found',
    IconData icon = Icons.search,
    Color color = Colors.grey,
  }) {
    return EmptyState(message: message, icon: icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }
    return _buildEmptyState(context);
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator.adaptive(strokeWidth: 0.5),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Icon(icon, color: color),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
