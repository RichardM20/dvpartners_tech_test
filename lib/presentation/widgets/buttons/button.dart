import 'package:flutter/material.dart';

class Button extends _ButtonBase {
  static const double _borderRadius = 100;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? initialText;
  final String? primaryText;
  final bool isLoading;
  final Color? backgroundColor;

  factory Button.icon({required IconData icon, VoidCallback? onTap}) {
    return Button._(icon: icon, onTap: onTap);
  }

  factory Button.loading({
    required String initialText,
    required String primaryText,
    bool isLoading = false,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return Button._(
      initialText: initialText,
      primaryText: primaryText,
      isLoading: isLoading,
      onTap: onTap,
      backgroundColor: backgroundColor,
    );
  }

  const Button._({
    this.icon,
    this.onTap,
    this.initialText,
    this.primaryText,
    this.isLoading = false,
    this.backgroundColor,
  }) : super();
}

class _ButtonBase extends StatelessWidget {
  const _ButtonBase();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _getOnTap(),
        borderRadius: _getBorderRadius(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _getWidth(),
          height: _getHeight(),
          padding: _getPadding(),
          decoration: BoxDecoration(
            borderRadius: _getBorderRadius(),
            color: _getBackgroundColor(context),
            boxShadow: _getBoxShadow(context),
          ),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final button = this as Button;

    if (button.icon != null) {
      return Icon(button.icon!, color: Colors.white, size: 20);
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (button.isLoading) ...[
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 0.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Text(
            button.isLoading ? button.primaryText! : button.initialText!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    final button = this as Button;
    if (button.isLoading) {
      return Colors.grey;
    }
    return button.backgroundColor ?? Theme.of(context).colorScheme.primary;
  }

  BorderRadius _getBorderRadius() {
    return BorderRadius.circular(Button._borderRadius);
  }

  List<BoxShadow> _getBoxShadow(BuildContext context) {
    final button = this as Button;
    if (button.isLoading) {
      return [
        BoxShadow(
          color: Colors.grey.shade400.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  double _getHeight() {
    final button = this as Button;
    return button.icon != null ? 35 : 45;
  }

  VoidCallback? _getOnTap() {
    final button = this as Button;
    if (button.icon != null) {
      return button.onTap;
    } else {
      return button.isLoading ? null : button.onTap;
    }
  }

  EdgeInsets _getPadding() {
    final button = this as Button;
    return button.icon != null
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  }

  double _getWidth() {
    final button = this as Button;
    return button.icon != null ? 35 : double.infinity;
  }
}
