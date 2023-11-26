import 'package:celam/screens/introduction_screen/intro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _readAccount() async {
    String uid = _user!.uid;
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('tabungan');
      DocumentSnapshot userSnapshot = await users.doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        print('User: $userData');
      } else {
        print('User tidak ditemukan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(_user != null ? _user!.email ?? 'Tamu' : 'Tamu'),
            Text(
              ''
            ),
            ElevatedButton(
                onPressed: () {
                },
                child: Text('Ubah profil')),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IntroductionScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
