import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/view_models/globalVariables_viewModel.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import 'package:ecommerce_app/utils/theme.dart';
import 'view_models/auth_viewModel.dart';
import 'package:ecommerce_app/utils/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await auth_viewModel(FirebaseAuth.instance).AnonymousOrCurrent();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<auth_viewModel>(
            create: (_) => auth_viewModel(FirebaseAuth.instance)),
        StreamProvider(
          initialData: 0,
          create: (context) => context.read<auth_viewModel>().authStateChanges,
        ),
        ChangeNotifierProvider(create: (context) => globalVars()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        theme: theme(),
        home: HomeScreen(),
        routes: routes,
      ),
    );
  }
}