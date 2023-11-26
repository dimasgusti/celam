import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerBalance(
      String username, String uid, double initialBalance) async {
    await _firestore.collection('tabungan').doc(uid).set({
      'username': username,
      'saldo': initialBalance,
      'timestamp': FieldValue.serverTimestamp()
    }).catchError((e) {
      print('Error: $e');
    });
  }

  Future<double> getUserBalance(String uid) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('tabungan')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        var userBalance = snapshot.data();

        if (userBalance != null && userBalance.containsKey('saldo')) {
          return (userBalance['saldo'] as num).toDouble();
        }
      }

      return 0.0;
    } catch (e) {
      print("Error getting user balance: $e");
      return 0.0;
    }
  }

  Future<void> addBalanceHistory(String uid, double amount) async {
    await FirebaseFirestore.instance.collection('riwayatTabungan').add({
      'uid': uid,
      'amount': amount,
      'type': 'deposit',
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future<void> addTransferHistory(String uid, double amount) async {
    await FirebaseFirestore.instance.collection('riwayatTabungan').add({
      'uid': uid,
      'amount': amount,
      'type': 'withdraw',
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future<void> updateBalance(String uid, double newBalance) async {
    await FirebaseFirestore.instance
        .collection('tabungan')
        .doc(uid)
        .update({'saldo': newBalance});
  }

  Future<List<Map<String, dynamic>>> getBalanceHistory(String uid) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('riwayatTabungan')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
