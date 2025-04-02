import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // User Methods
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'role': user.role,
      'profile': user.profile,
    });
  }

  Future<UserModel> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return UserModel.fromMap(uid, doc.data()!);
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> profile) async {
    await _firestore.collection('users').doc(uid).update({'profile': profile});
  }

  // Booking Methods
  Future<String> createBooking(String userId, Map<String, dynamic> details) async {
    final docRef = await _firestore.collection('bookings').add({
      'userId': userId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
      'details': details,
    });
    return docRef.id;
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
    });
  }

  // Permanently delete a booking document from Firestore
  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }

  Stream<QuerySnapshot> getUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllBookings() {
    return _firestore
        .collection('bookings')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}