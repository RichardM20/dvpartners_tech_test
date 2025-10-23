import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/injection/injection_container.dart';
import 'domain/usecases/get_locations_usecase.dart';
import 'presentation/cubit/user_cubit.dart';
import 'presentation/pages/users_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await sl<GetLocationsUseCase>().call();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UserCubit>()..getUsers(),
      child: MaterialApp(
        title: 'Gestión de Usuarios',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: Colors.grey.shade100,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const UsersListPage(),
      ),
    );
  }
}
