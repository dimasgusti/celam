import 'package:celam/screens/homescreen/home.dart';
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

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _jumlahController = TextEditingController();

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
                    height: 320,
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
                          Text('Masukkan email penerima'),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'name@mail.com',
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
                            controller: _jumlahController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyInputFormatter()
                            ],
                            decoration: InputDecoration(
                              hintText: 'Rp10.000',
                              prefixIcon: Icon(Icons.attach_money),
                              prefixStyle: TextStyle(color: Color(0xFF255e36)),
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(onPressed: () {}, child: Text('Kirim'))
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

class CurrencyInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue value, TextEditingValue valueBaru) {
    if (valueBaru.text.isEmpty) {
      return valueBaru.copyWith(text: 'Rp');
    }

    final num = int.parse(valueBaru.text);
    final formattedValue =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0)
            .format(num);

    return valueBaru.copyWith(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length));
  }
}
