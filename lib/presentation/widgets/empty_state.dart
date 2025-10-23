import 'package:flutter/material.dart';

class EmptyState extends _EmptyStateBase {
  factory EmptyState.error({
    String message = 'An error occurred',
    IconData icon = Icons.error_outline,
    Color color = Colors.red,
  }) {
    return EmptyState._(message: message, icon: icon, color: color);
  }

  factory EmptyState.loading() {
    return const EmptyState._(isLoading: true);
  }

  factory EmptyState.noData({
    String message = 'No data found',
    IconData icon = Icons.search,
    Color color = Colors.grey,
  }) {
    return EmptyState._(message: message, icon: icon, color: color);
  }

  const EmptyState._({super.message, super.icon, super.color, super.isLoading})
    : super();
}

class _EmptyStateBase extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final bool isLoading;
  const _EmptyStateBase({
    this.message = '',
    this.icon = Icons.search,
    this.color = Colors.grey,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator.adaptive(strokeWidth: 0.5),
      );
    }
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
