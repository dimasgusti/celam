import 'package:flutter/material.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
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
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'Transfer'
              )
            ],
          ),
        ),
      )
    );
  }
}