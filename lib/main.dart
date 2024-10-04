import 'package:flutter/material.dart';
import '../pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import '../pages/recommend.dart';

void main()  async{

WidgetsFlutterBinding.ensureInitialized();

await  Firebase.initializeApp(
  options: const FirebaseOptions(
  apiKey:'AIzaSyD56j-AeIiXRGjJ9WZi56_r6zg5JkHXZh4',
  appId: '1:699606582027:android:22d31afab4b5901f79980e',
  messagingSenderId: '',
  projectId: 'fluttercookclick',
  )
);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const RecommendScreen(
      ),
    );
  }
}
