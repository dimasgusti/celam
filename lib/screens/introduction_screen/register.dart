import 'package:celam/screens/introduction_screen/intro.dart';
import 'package:celam/services/accountAuth.dart';
import 'package:celam/services/balanceAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Regis extends StatefulWidget {
  const Regis({super.key});

  @override
  State<Regis> createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  User? _user;

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pinController = TextEditingController();

  final TextEditingController _confirmPinController = TextEditingController();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final username = _usernameController.value.text;
    final email = _emailController.value.text;
    final pin = _pinController.value.text;
    final confirmPin = _confirmPinController.value.text;

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tabungan')
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _alertDialog('Error', 'Username sudah digunakan');
      } else if (username.isEmpty ||
          email.isEmpty ||
          pin.isEmpty ||
          confirmPin.isEmpty) {
        _alertDialog('Error', 'Isi data dengan benar!');
      } else if (pin.length < 6) {
        _alertDialog('Error', 'PIN harus 6 angka');
      } else if (pin != confirmPin) {
        _alertDialog('Error', 'Password tidak sama');
      } else {
        setState(() => _loading = true);
        try {
          await Auth().regis(email, pin);
          await _user?.sendEmailVerification();
          String uid = _user != null ? _user!.uid : '1';
          double initialBalance = 0.0;
          FirestoreService firestoreService = FirestoreService();
          firestoreService.registerBalance(username, uid, initialBalance);
          _alertDialog('Success', 'Akun berhasil dibuat, cek email untuk verifikasi!');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use') {
            _alertDialog('Error', 'Email sudah terdaftar!');
          } else {
            _alertDialog('Error', 'Gagal membuat akun. Silahkan coba lagi.');
          }
        } finally {
          setState(() {
            _loading = false;
            handleClear();
          });
        }
      }
    } catch (e) {
      _alertDialog('Error', '$e');
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

  handleClear() {
    _usernameController.clear();
    _emailController.clear();
    _pinController.clear();
    _confirmPinController.clear();
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
    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: lebar,
          height: tinggi,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background/bg3.png'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Daftar',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Container(
                        width: 240,
                        height: 500,
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
                                'Username',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                controller: _usernameController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(25)
                                ],
                                decoration: InputDecoration(
                                  hintText: 'Your Name',
                                  prefixIcon: Icon(Icons.person),
                                  prefixIconColor: Color(0xFF255e36),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                controller: _emailController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(30)
                                ],
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
                                'PIN',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                  controller: _pinController,
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: '******',
                                      prefixIcon: Icon(Icons.password),
                                      prefixIconColor: Color(0xFF255e36))),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Konfirmasi PIN',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              TextFormField(
                                  controller: _confirmPinController,
                                  obscureText: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(6)
                                  ],
                                  decoration: InputDecoration(
                                      hintText: '******',
                                      prefixIcon: Icon(Icons.password),
                                      prefixIconColor: Color(0xFF255e36))),
                              SizedBox(
                                height: 16,
                              ),
                              ElevatedButton(
                                  onPressed: () => handleSubmit(),
                                  child: _loading
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Icon(Icons.send)),
                              // SizedBox(height: 20,),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IntroductionScreen()));
                                },
                                child: Text(
                                  'Punya akun?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ));
  }
}
