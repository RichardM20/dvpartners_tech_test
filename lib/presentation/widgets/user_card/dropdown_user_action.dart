import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';
import 'user_card.dart';

class UserCardWithActions extends StatefulWidget {
  final User user;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const UserCardWithActions({
    super.key,
    required this.user,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<UserCardWithActions> createState() => _UserCardWithActionsState();
}

class _UserCardWithActionsState extends State<UserCardWithActions>
    with SingleTickerProviderStateMixin {
  static const double _buttonSize = 40.0;
  static const double _dropdownWidth = 140.0;
  static const double _dropdownOffset = 70.0;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isMenuOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return _buildCardWithActions(context);
  }

  @override
  void dispose() {
    _removeOverlay();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: _isMenuOpen
          ? Theme.of(context).primaryColor
          : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(_buttonSize / 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildButtonIcon() {
    return AnimatedRotation(
      turns: _isMenuOpen ? 0.25 : 0.0,
      duration: _animationDuration,
      child: Icon(
        _isMenuOpen ? Icons.close : Icons.more_vert,
        color: _isMenuOpen ? Colors.white : Colors.grey.shade600,
        size: 20,
      ),
    );
  }

  Widget _buildCardWithActions(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          UserCard(user: widget.user),
          _buildDropdownButton(),
        ],
      ),
    );
  }

  Widget _buildDropdownButton() {
    return Positioned(right: 24, top: 24, child: _buildDropdownMenu());
  }

  Widget _buildDropdownContainer() {
    return Container(
      width: _dropdownWidth,
      decoration: _buildDropdownDecoration(),
      child: _buildDropdownItems(),
    );
  }

  Widget _buildDropdownContent() {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildDropdownContainer(),
      ),
    );
  }

  BoxDecoration _buildDropdownDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildDropdownItems() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          icon: Icons.edit,
          label: 'editar',
          color: Theme.of(context).primaryColor,
          onTap: () => _handleEditAction(),
        ),
        const Divider(height: 1),
        _buildMenuItem(
          icon: Icons.delete,
          label: 'eliminar',
          color: Colors.red,
          onTap: () => _handleDeleteAction(),
        ),
      ],
    );
  }

  Widget _buildDropdownMenu() {
    return GestureDetector(
      onTap: _toggleMenu,
      child: Container(
        width: _buttonSize,
        height: _buttonSize,
        decoration: _buildButtonDecoration(),
        child: _buildButtonIcon(),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: _buildMenuItemContent(icon, label, color),
      ),
    );
  }

  Widget _buildMenuItemContent(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildMenuItemIcon(icon, color),
          const SizedBox(width: 12),
          _buildMenuItemText(label),
        ],
      ),
    );
  }

  Widget _buildMenuItemIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildMenuItemText(String label) {
    return Text(label, style: _getMenuItemTextStyle());
  }

  Offset? _calculateDropdownPosition() {
    try {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero);

      return Offset(
        offset.dx + renderBox.size.width - _dropdownWidth,
        offset.dy + _dropdownOffset,
      );
    } catch (e) {
      return null;
    }
  }

  void _closeMenu() {
    if (!mounted) return;

    setState(() {
      _isMenuOpen = false;
    });

    _removeOverlay();
    _animationController.reverse();
  }

  TextStyle _getMenuItemTextStyle() {
    return TextStyle(
      color: Colors.grey.shade800,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  void _handleDeleteAction() {
    _toggleMenu();
    widget.onDelete();
  }

  void _handleEditAction() {
    _toggleMenu();
    widget.onEdit();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();

    final position = _calculateDropdownPosition();
    if (position == null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _closeMenu,
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                top: position.dy,
                child: GestureDetector(
                  onTap: () {},
                  child: _buildDropdownContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _toggleMenu() {
    if (!mounted) return;

    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    if (_isMenuOpen) {
      _showOverlay();
      _animationController.forward();
    } else {
      _removeOverlay();
      _animationController.reverse();
    }
  }
}
