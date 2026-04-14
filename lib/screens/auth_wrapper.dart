import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/login_screen.dart';
import 'package:todo_app/services/database_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return LoginScreen();
    } else {
      return StreamProvider<List<TodoModel>>.value(
        value: Provider.of<DatabaseService>(context).todos,
        initialData: [],
        child: HomeScreen(),
      );
    }
  }
}
