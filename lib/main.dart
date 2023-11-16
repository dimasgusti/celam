import 'package:celam/screens/homescreen/home.dart';
import 'package:celam/screens/introduction_screen/intro.dart';
import 'package:celam/services/accountAuth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final Auth auth = Auth();
  final bool isLoggedIn = await auth.isUserLoggedIn();

  runApp(isLoggedIn ? Logged() : NotLogged());
}

class NotLogged extends StatelessWidget {
  const NotLogged({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
          fontFamily: 'OpenSans'),
      home: IntroductionScreen(),
    );
  }
}

class Logged extends StatelessWidget {
  const Logged({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
          useMaterial3: true,
          fontFamily: 'OpenSans'),
      home: HomeScreen(),
    );
  }
}
