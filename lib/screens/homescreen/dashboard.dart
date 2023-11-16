import 'package:celam/screens/balance/transfer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:celam/services/balanceAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  User? _user;

  final FirestoreService firestoreService = FirestoreService();

  void _showQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Code'),
          content: Container(
            height: 200,
            width: 200,
            child: Center(
              child: Image(image: AssetImage('assets/images/qr.jpeg')),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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

  double overallBalance(List<Map<String, dynamic>> history, String type) {
    double total = 0.0;
    for (var entry in history) {
      if (entry['type'] == type) {
        total += entry['amount'] as double;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background/bg2-icon.png'),
                fit: BoxFit.cover)),
        // color: Color(0xFFf9f7f7),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 72,
                  color: Color(0xFF255e36),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat datang,'),
                    Text(_user != null ? _user!.email ?? 'Tamu' : 'Tamu')
                  ],
                ),
                Spacer(),
                TextButton(
                    onPressed: () {
                      _showQR(context);
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 28,
                          color: Color(0xFF255e36),
                        ),
                        Text(
                          'Lihat QR',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ))
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            // Saldo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Saldo aktif: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                FutureBuilder<double>(
                  future: _user != null
                      ? FirestoreService().getUserBalance(_user!.uid)
                      : null,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(
                        strokeWidth: 2.0,
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error mendapatkan saldo');
                    } else {
                      double userBalance = snapshot.data ?? 0.0;

                      String formatRupiah = NumberFormat.currency(
                              locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
                          .format(userBalance);

                      return Text(
                        formatRupiah,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                )
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            // Aksi cepat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Transfer()));
                        },
                        child: Column(
                          children: [
                            Icon(
                              Icons.send,
                            ),
                            Text('Kirim')
                          ],
                        ))
                  ],
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                ),
                Column(
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Column(
                          children: [
                            Icon(
                              Icons.history,
                            ),
                            Text('Riwayat')
                          ],
                        ))
                  ],
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            // Saldo masuk dan keluar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Saldo masuk',
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _user != null
                          ? firestoreService.getBalanceHistory(_user!.uid)
                          : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            strokeWidth: 2,
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child:
                                Text('Error mengambil data: ${snapshot.error}'),
                          );
                        } else {
                          double totalDeposit =
                              overallBalance(snapshot.data ?? [], 'deposit');
                          return Text(
                            '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(totalDeposit)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Saldo keluar',
                    ),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _user != null
                          ? firestoreService.getBalanceHistory(_user!.uid)
                          : null,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            strokeWidth: 2,
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child:
                                Text('Error mengambil data: ${snapshot.error}'),
                          );
                        } else {
                          double totalDeposit =
                              overallBalance(snapshot.data ?? [], 'withdraw');
                          return Text(
                            '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(totalDeposit)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _user != null
                    ? firestoreService.getBalanceHistory(_user!.uid)
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(strokeWidth: 2.0));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error mengambil data: ${snapshot.error}'));
                  } else {
                    List<Map<String, dynamic>> history = snapshot.data ?? [];
                    return history.isEmpty
                        ? Center(
                            child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xFF255e36),
                            ),
                            child: Center(
                              child: Text(
                                'Tidak ada riwayat',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ))
                        : ListView.builder(
                            itemCount: history.length,
                            itemBuilder: (context, index) {
                              // Customize this part based on your data structure
                              String amount = NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(history[index]['amount'] as double);
                              String type = history[index]['type'] as String;
                              bool isDeposit = type == 'deposit';
                              DateTime timestamp =
                                  (history[index]['timestamp'] as Timestamp)
                                      .toDate();
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors
                                      .white70, // Set your desired background color
                                  child: ListTile(
                                    title: Text(
                                      amount,
                                      style: TextStyle(
                                        color: isDeposit
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      DateFormat('yyyy-MM-dd HH:mm:ss')
                                          .format(timestamp),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
