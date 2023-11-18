import 'package:celam/services/balanceAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Topup extends StatefulWidget {
  const Topup({Key? key}) : super(key: key);

  @override
  State<Topup> createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  User? _user;

  @override
  void initState() {
    super.initState();
    initializeUser();
  }

  Future<void> initializeUser() async {
    try {
      await Firebase.initializeApp();
      _user = FirebaseAuth.instance.currentUser;
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error fetching current user: $e');
    }
  }

  void _alertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              content,
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        }));
  }

  Future<void> _topUp(double amount) async {
    if (_user != null) {
      try {
        FirestoreService firestoreService = FirestoreService();
        String uid = _user!.uid;
        double saldo = await firestoreService.getUserBalance(uid);
        await firestoreService.updateBalance(uid, saldo + amount);
        await firestoreService.addBalanceHistory(uid, amount);
        List<Map<String, dynamic>> balanceHistory =
            await firestoreService.getBalanceHistory(uid);
        print('$balanceHistory[1]');
      } catch (e) {
        _alertDialog('Error', '$e');
      }
    }
  }

  Future<void> _pinInput(BuildContext context) async {
    String pin = '';

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Masukkan PIN',
            ),
            content: Container(
              width: 200,
              height: 100,
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      pin = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'PIN',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: true,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Batal'),
              ),
              TextButton(onPressed: () {}, child: Text('Kirim'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Top Up',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: (_user != null)
                    ? () {
                        _pinInput(context);
                        _topUp(50000);
                      }
                    : null,
                child: Text('IDR 50.000'),
              ),
              ElevatedButton(
                onPressed: (_user != null)
                    ? () {
                        _topUp(100000);
                      }
                    : null,
                child: Text('IDR 100.000'),
              ),
              ElevatedButton(
                onPressed: (_user != null)
                    ? () {
                        _topUp(150000);
                      }
                    : null,
                child: Text('IDR 150.000'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
