import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../cubit/user_cubit.dart';
import '../widgets/dropdown_user_action.dart';
import '../widgets/empty_state.dart';
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
}

class UsersListView extends StatelessWidget {
  const UsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
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

            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserCardWithActions(
                  user: user,
                  onTap: () => _navigateToUserDetail(context, user),
                  onEdit: () => _navigateToEditUser(context, user),
                  onDelete: () => _deleteUser(context, user.id),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Usuario'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar este usuario?',
        ),
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
            child: const Text('Eliminar'),
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
