import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../cubit/user_cubit.dart';
import '../widgets/buttons/button.dart';
import '../widgets/user_addresses_section_widget.dart';
import '../widgets/user_info_widget.dart';
import 'user_form_page.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  const UserDetailPage({super.key, required this.user});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isLoading = state is UserLoading;

        return PopScope(
          canPop: !isLoading,
          child: BlocListener<UserCubit, UserState>(
            listener: _handleStateChanges,
            child: Scaffold(
              appBar: AppBar(
                title: Text(widget.user.fullName),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                automaticallyImplyLeading: !isLoading,
              ),
              body: AbsorbPointer(
                absorbing: isLoading,
                child: Opacity(
                  opacity: isLoading ? 0.6 : 1.0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserInfoWidget(user: widget.user),
                        const SizedBox(height: 24),
                        UserAddressesSectionWidget(user: widget.user),
                        const SizedBox(height: 32),
                        _buildActionButtons(context),
                      ],
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

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Button.loading(
            initialText: 'Editar',
            primaryText: 'Editando...',
            isLoading: false,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.5),
            onTap: () => _editUser(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildDeleteButton(context)),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isDeleting = state is UserLoading;

        return Button.loading(
          backgroundColor: Colors.red.withValues(alpha: 0.5),
          initialText: 'Eliminar',
          primaryText: 'Eliminando...',
          isLoading: isDeleting,
          onTap: isDeleting ? null : () => _deleteUser(context),
        );
      },
    );
  }

  void _deleteUser(BuildContext context) {
    final cubit = context.read<UserCubit>();
    cubit.deleteUser(widget.user.id);
  }

  void _editUser(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => UserFormPage(user: widget.user)),
    );
  }

  void _handleStateChanges(BuildContext context, UserState state) {
    if (state is UserError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (state is UserLoaded) {
      final userStillExists = state.users.any(
        (user) => user.id == widget.user.id,
      );
      if (!userStillExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }
}
