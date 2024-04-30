import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Assuming you have already initialized Firebase

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> updateProductStatus(String productId, String newStatus) async {
  final userRef = _firestore.collection('Users');

  // Transaction for data consistency
  await _firestore.runTransaction((transaction) async {
    // Document references
    final activeDocRef = userRef.doc(_auth.currentUser!.uid).collection('active').doc(productId);
    final reservedDocRef = userRef.doc(_auth.currentUser!.uid).collection('reserved').doc(productId);

    switch (newStatus) {
      case 'reserved':
        // Move data from active to reserved
        final activeData = await transaction.get(activeDocRef);
        if (activeData.exists) {
          transaction.set(reservedDocRef, activeData.data()!);
          transaction.delete(activeDocRef);
        }
        break;
      case 'active':
        // Move data from reserved to active
        final reservedData = await transaction.get(reservedDocRef);
        if (reservedData.exists) {
          transaction.set(activeDocRef, reservedData.data()!);
          transaction.delete(reservedDocRef);
        }
        break;
      default:
        throw Exception('Invalid status update for product.');
    }
  });
}