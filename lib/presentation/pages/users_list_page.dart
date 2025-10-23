import 'package:dvpartners_tech_test/presentation/widgets/animation_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../cubit/user_cubit.dart';
import '../widgets/snackbar/snackbar_app.dart';
import '../widgets/user_card/dropdown_user_action.dart';
import '../widgets/user_card/empty_state.dart';
import 'user_detail_page.dart';
import 'user_form_page.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => _showBulkDeleteDialog(context),
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Eliminación masiva',
          ),
        ],
      ),

      body: const UsersListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () => _navigateToCreateUser(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToCreateUser(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const UserFormPage()));
  }

  void _showBulkDeleteDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Eliminación total'),
        content: const Text('Se eliminaran todos los datos'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserCubit>().deleteAllUsers();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          SnackBarApp.show(context, 'Error: ${state.message}', isError: true);
        }
      },
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserError) {
            return EmptyState.error(message: state.message);
          } else if (state is UserLoaded) {
            if (state.users.isEmpty) {
              return EmptyState.noData(
                message: 'No hay usuarios disponibles',
                icon: Icons.data_array,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < state.users.length - 1 ? 8 : 0,
                  ),
                  child: AnimationContainer.fromBottom(
                    delay: Duration(milliseconds: index * 50),
                    child: UserCardWithActions(
                      user: user,
                      onTap: () => _navigateToUserDetail(context, user),
                      onEdit: () => _navigateToEditUser(context, user),
                      onDelete: () => _deleteUser(context, user.id),
                    ),
                  ),
                );
              },
            );
          } else {
            return EmptyState.loading();
          }
        },
      ),
    );
  }

  void _deleteUser(BuildContext context, int userId) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Eliminacion de usuario'),
        content: const Text('Se eliminara el usuario y sus direcciones'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<UserCubit>().deleteUser(userId);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _navigateToEditUser(BuildContext context, User user) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => UserFormPage(user: user)));
  }

  void _navigateToUserDetail(BuildContext context, user) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => UserDetailPage(user: user)));
  }
}
