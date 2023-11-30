import 'package:celam/services/balanceAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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

  Future<void> _confirm(BuildContext context, double amount) async {

    String formatRupiah = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
    .format(amount);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Lanjutkan?',
            ),
            content: Container(
              width: 200,
              height: 20,
              child: Column(
                children: [
                  Text(
                    'Topup sebesar: $formatRupiah'
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Tidak'),
              ),
              TextButton(
                  onPressed: () {
                    _topUp(amount);
                    Navigator.pop(context);
                    _alertDialog('Success', 'Topup berhasil');
                  },
                  child: Text('Ya'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: lebar,
        height: tinggi,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background/bg2-icon.png'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Saldo aktif'),
                      FutureBuilder<double>(
                        future: _user != null
                            ? FirestoreService().getUserBalance(_user!.uid)
                            : null,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              strokeWidth: 2.0,
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error mendapatkan saldo');
                          } else {
                            double userBalance = snapshot.data ?? 0.0;
      
                            String formatRupiah = NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0)
                                .format(userBalance);
      
                            return Text(
                              formatRupiah,
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                  height: 20,
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      _confirm(context, 50000);
                    },
                    child: ListTile(
                      title: Text('Rp 50.000'),
                      // subtitle: Text('Subtitle'),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      _confirm(context, 100000);
                    },
                    child: ListTile(
                      title: Text('Rp 100.000'),
                      // subtitle: Text('Subtitle'),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      _confirm(context, 250000);
                    },
                    child: ListTile(
                      title: Text('Rp 250.000'),
                      // subtitle: Text('Subtitle'),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      _confirm(context, 500000);
                    },
                    child: ListTile(
                      title: Text('Rp 500.000'),
                      // subtitle: Text('Subtitle'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
