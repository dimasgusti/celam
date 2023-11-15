import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color(0xFFf9f7f7),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 72,
                  color: Color(0xFF333333),
                ),
                Column(
                  children: [
                    Text('Selamat datang,'),
                    Text('{GET EMAIL}'),
                  ],
                )
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
                Text(
                  '{GET SALDO}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      onPressed: (){},
                      child: Column(
                        children: [
                          Icon(
                            Icons.send,
                          ),
                          Text(
                            'Kirim'
                          )
                        ],
                      )
                    )
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
                      onPressed: (){},
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                          ),
                          Text(
                            'Riwayat'
                          )
                        ],
                      )
                    )
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
                    Text(
                      '{GET saldo}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Saldo keluar',
                    ),
                    Text(
                      '{GET saldo}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}
