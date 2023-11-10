import 'package:app1/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:app1/Pages/signIn.dart';
import 'package:app1/Pages/home.dart';
import 'package:app1/Pages/Welcome.dart';
import 'package:app1/Pages/profile.dart';
import 'package:app1/Pages/category.dart';
import 'package:app1/Pages/addExpense.dart';
import 'package:app1/Pages/expenses.dart';
import 'package:app1/Pages/register.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => WelcomePage(),
      '/home': (context) => Home(),
      '/login': (context) => SignIn(),
      '/profile': (context) => Profile(),
      '/category': (context) => Category(),
      '/addexpense': (context) => AddExpense(),
      '/expenses': (context) => Expenses(),
      '/register': (context) => Register(),
    },
  ));
}
