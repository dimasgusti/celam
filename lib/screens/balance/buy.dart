import 'package:celam/services/balanceAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Buy extends StatefulWidget {
  const Buy({Key? key}) : super(key: key);

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  User? _user;

  TextEditingController _tokoController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> transfer() async {
    String toko = _tokoController.text;
    String uid1 = _user!.uid;
    double saldo1 = await FirestoreService().getUserBalance(uid1);

    try {
      String barang = _namaController.value.text;
      String amount = _amountController.value.text;
      double jumlah = double.parse(amount);

      if (jumlah > saldo1) {
        _alertDialog('Error', 'Saldo anda kurang');
        return;
      }
      if (barang.isEmpty) {
        _alertDialog('Error', 'Masukkan nama barang dengan benar');
        return;
      }
      if (select == 0) {
        _alertDialog('Error', 'Masukkan tipe pembelian');
        return;
      }
      CollectionReference collection =
          FirebaseFirestore.instance.collection('tabungan');

      QuerySnapshot querySnapshot =
          await collection.where('username', isEqualTo: toko).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String uid2 = documentSnapshot.id;
        if (uid1 == uid2) {
          _alertDialog('Error', 'Masukkan nama toko dengan benar');
        } else {
          Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;

          String userPenerima = userData['username'];
          _confirm(context, uid1, saldo1, toko, barang, jumlah, select, uid2,
              userPenerima);
        }
      } else {
        _alertDialog('Error', 'Username tidak terdaftar');
      }
    } catch (e) {
      _alertDialog('Error', '$e');
    }
  }

  Future<void> _confirm(
      BuildContext context,
      String uid1,
      double saldo1,
      String toko,
      String barang,
      double jumlah,
      double select,
      String uid2,
      String userPenerima) async {
    String formatRupiah =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(jumlah);

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lanjutkan?'),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Toko: $toko'),
                  Text('Barang: $barang'),
                  Text('Jumlah: $formatRupiah'),
                  Text(select == 1.0 ? 'Tipe: Pembayaran' : 'Tipe: Langganan')
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
                        .updateBalance(uid2, saldo2 + jumlah);
                    await FirestoreService().addBalanceHistory(uid2, jumlah);

                    await FirestoreService()
                        .updateBalance(uid1, saldo1 - jumlah);

                    await FirestoreService().addTransferHistory(uid1, barang, jumlah,
                        select == 1.0 ? 'Pembayaran' : 'Langganan');

                    Navigator.pop(context);

                    _alertDialog('Success',
                        'Berhasil mengirimkan $formatRupiah kepada: $toko');

                    handleClear();
                  },
                  child: Text('Kirim'))
            ],
          );
        });
  }

  handleClear() {
    if (mounted) {
      _namaController.clear();
      _tokoController.clear();
      _amountController.clear();
    }
  }

  int selectedOption = -1;
  double select = 0;

  void _alertDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF255e36),
        title: Text(
          'CELAM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'KemasyuranJawa',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/bg2-icon.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Pembelian',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Nama Toko',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _tokoController,
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.store),
                          hintText: 'Toko',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Nama Barang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.shopping_bag),
                          hintText: 'Kaos kaki',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Jumlah Uang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(prefixText: 'Rp'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Tipe',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Card(
                    color: selectedOption == 0 ? Colors.blue : null,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedOption = 0;
                          select = 1;
                        });
                      },
                      child: ListTile(
                        title: Text(
                          'Pembayaran',
                          style: TextStyle(
                            color: selectedOption == 0 ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    color: selectedOption == 1 ? Colors.blue : null,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          selectedOption = 1;
                          select = 2;
                        });
                      },
                      child: ListTile(
                        title: Text(
                          'Langganan',
                          style: TextStyle(
                            color: selectedOption == 1 ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  transfer();
                },
                child: Text('Bayar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
