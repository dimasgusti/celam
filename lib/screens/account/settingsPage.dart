import 'package:celam/screens/introduction_screen/intro.dart';
import 'package:celam/services/balanceAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? _user;

  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  void gantiUsername() async {
    String username = _usernameController.text.trim();

    if (username.isEmpty) {
      _alertDialog('Error', 'Username kosong');
    } else {
      try {
        String uid = _user != null ? _user!.uid ?? 'Tamu' : 'Tamu';

        bool usernameExists =
            await FirestoreService().isUsernameExists(username);

        if (usernameExists) {
          _alertDialog('Error', 'Username sudah digunakan');
        } else {
          await FirestoreService().updateUser(uid, username);
          _usernameController.clear();
          Navigator.pop(context);
        }
      } catch (error) {
        print('Error: $error');
        _alertDialog('Error', 'Terjadi kesalahan saat mengganti username');
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

  @override
  Widget build(BuildContext context) {
    var lebar = MediaQuery.of(context).size.width;
    var tinggi = MediaQuery.of(context).size.height;
    String uid = _user != null ? _user!.uid ?? 'Tamu' : 'Tamu';
    return Scaffold(
      body: Container(
        width: lebar,
        height: tinggi,
        padding: EdgeInsets.only(left: 8, right: 8),
         decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/bg2-icon.png'),
            fit: BoxFit.cover)
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xFF255e36),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Profil",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(height: 20.0),
                  FutureBuilder<String>(
                    future: FirestoreService().getUsername(uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(strokeWidth: 2.0,);
                      } else {
                        return Text(
                          snapshot.data ?? 'No username',
                        );
                      }
                    },
                  ),
                  Text(
                    _user != null ? _user!.email ?? 'Tamu' : 'Tamu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    _user != null ? _user!.uid ?? 'Tamu' : 'Tamu',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10.0),
                  buildAccountOptionRow(
                      context, "Ganti Username", 'changeUsername'),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Color(0xFF255e36),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Umum",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Tema Aplikasi", 'changeTheme'),
            SizedBox(
              height: 40,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IntroductionScreen()));
                },
                child: Text(
                  "SIGN OUT",
                  style: TextStyle(
                      letterSpacing: 1.5, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildAccountOptionRow(
      BuildContext context, String title, String content) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (content == 'changeUsername')
                      AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25)
                              ],
                              decoration: InputDecoration(
                                hintText: 'Nama',
                                prefixIcon: Icon(Icons.person),
                                prefixIconColor: Color(0xFF255e36),
                              ),
                            )
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Batal')),
                          TextButton(
                              onPressed: () {
                                gantiUsername();
                              },
                              child: Text('Ubah')),
                        ],
                      )
                    else if (content == 'changeTheme')
                      Text('Menu ganti tema')
                    else
                      Text('Belum dipasang')
                  ],
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_back_outlined,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
