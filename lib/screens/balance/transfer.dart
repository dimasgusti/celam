import 'package:celam/screens/homescreen/home.dart';
import 'package:celam/services/balanceAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  User? _user;

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  Future<void> transfer() async {
    String username = _usernameController.text;
    String uid1 = _user!.uid;
    double saldo1 = await FirestoreService().getUserBalance(uid1);

    try {
      String amount = _amountController.value.text;
      double jumlah = double.parse(amount);

      if (jumlah > saldo1) {
        _alertDialog('Error', 'Saldo anda kurang');
        return;
      }
      CollectionReference collection =
          FirebaseFirestore.instance.collection('tabungan');

      QuerySnapshot querySnapshot =
          await collection.where('username', isEqualTo: username).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String uid2 = documentSnapshot.id;
        if (uid1 == uid2) {
          _alertDialog('Error', 'Masukkan username pengguna lain!');
        } else {
          Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;

          String userPenerima = userData['username'];
          _confirm(context, uid2, userPenerima, jumlah, saldo1, uid1);
        }
      } else {
        _alertDialog('Error', 'Username tidak terdaftar');
      }
    } catch (e) {
      _alertDialog('Error', 'Error: $e');
    }
  }

  Future<void> _confirm(BuildContext context, String uid2, String userPenerima,
      double amount, double saldo1, String uid1) async {
    String formatRupiah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(amount);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lanjutkan?'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kirim: $formatRupiah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Kepada: $userPenerima',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Batal')),
              TextButton(
                  onPressed: () async {
                    double saldo2 =
                        await FirestoreService().getUserBalance(uid2);
                    await FirestoreService()
                        .updateBalance(uid2, saldo2 + amount);
                    await FirestoreService().addBalanceHistory(uid2, amount);

                    await FirestoreService()
                        .updateBalance(uid1, saldo1 - amount);
                    await FirestoreService().addTransferHistory(uid1, amount);
                    Navigator.pop(context);
                    _alertDialog('Success',
                        'Berhasil mengirimkan $formatRupiah kepada: $userPenerima');
                    handleClear();
                  },
                  child: Text('Kirim'))
            ],
          );
        });
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

  handleClear() {
    if (mounted) {
      _usernameController.clear();
      _amountController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF255e36),
          title: Text(
            'CELAM',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'KemasyuranJawa',
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background/bg1.png'),
                  fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 240,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Transfer',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text('Username penerima'),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: 'username',
                              prefixIcon: Icon(Icons.person),
                              prefixIconColor: Color(0xFF255e36),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Jumlah uang',
                          ),
                          TextFormField(
                            controller: _amountController,
                            decoration: InputDecoration(prefixText: 'Rp'),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                transfer();
                              },
                              child: Text('Kirim'))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      child: Icon(Icons.arrow_back))
                ],
              ),
            ),
          ),
        ));
  }
}
