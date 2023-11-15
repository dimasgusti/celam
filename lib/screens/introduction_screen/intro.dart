import 'package:celam/screens/homescreen/home.dart';
import 'package:celam/screens/introduction_screen/register.dart';
import 'package:celam/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroductionScreen extends StatefulWidget {
  IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  bool _loading = false;

  final _pageController = PageController(initialPage: 0);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.value.text;
    final pin = _pinController.value.text;

    if (email.isEmpty || pin.isEmpty) {
      _alertDialog('Error', 'Isi data dengan benar!');
    } else {
      setState(() => _loading = true);
      try {
        await Auth().login(email, pin);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } catch (e) {
        _alertDialog('Error', '$e');
        print('$e');
      } finally {
        setState(() => _loading = false);
        handleClear();
      }
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
    _emailController.clear();
    _pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        children: [
          // Halaman pertama
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background/bg1.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/celam_logo.png'),
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  IconButton(
                    onPressed: () {
                      _pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          // Halaman kedua
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background/bg2.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CELAM',
                    style: TextStyle(
                        fontSize: 48,
                        color: Color(0xFF255e36),
                        fontFamily: 'KemasyuranJawa'),
                  ),
                  Text(
                    'Solusi Pintar Keuangan Anda',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF255e36),
                        fontFamily: 'OpenSans'),
                  ),
                  SizedBox(
                    height: 64,
                  ),
                  IconButton(
                    onPressed: () {
                      _pageController.animateToPage(2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                    color: Color(0xFF255e36),
                  )
                ],
              ),
            ),
          ),
          // Halaman ketiga
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background/bg3.png'),
                    fit: BoxFit.cover)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Masuk',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextFormField(
                            controller: _emailController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            decoration: InputDecoration(
                              hintText: 'Your name',
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
                          ElevatedButton(
                            onPressed: () => handleSubmit(),
                            child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.login
                                ),
                          ),
                          // SizedBox(height: 20,),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Regis()));
                            },
                            child: Text(
                              'Akun baru?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      )
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pageController.animateToPage(3,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        },
        child: Text(
          'Masuk',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
