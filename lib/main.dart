import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home_page.dart';
import 'send_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DatabaseReference itemsRef =
      FirebaseDatabase.instance.reference().child('items');
  runApp(MyApp(itemsRef: itemsRef));
}

class MyApp extends StatelessWidget {
  final DatabaseReference itemsRef;

  const MyApp({Key? key, required this.itemsRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(itemsRef: itemsRef),
        '/send': (context) => SendPage(itemsRef: itemsRef),
      },
    );
  }
}
