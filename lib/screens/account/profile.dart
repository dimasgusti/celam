import 'package:celam/screens/account/editprofile.dart';
import 'package:celam/screens/account/settingsPage.dart';
import 'package:celam/screens/introduction_screen/intro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;

  Future<void> _readAccount() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background/bg2-icon.png'),
                fit: BoxFit.cover)
          ),
          child: Column(
            children: [
              Spacer(),
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                  },
                  child: ListTile(
                    title: Text(
                      'Ubah Profile',
                      textAlign: TextAlign.center,
                    ),
                    // subtitle: Text('Subtitle'),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IntroductionScreen()));
                  },
                  child: ListTile(
                    title: Text(
                      'Logout',
                      textAlign: TextAlign.center,
                    ),
                    // subtitle: Text('Subtitle'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
