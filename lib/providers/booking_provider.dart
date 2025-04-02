import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../models/booking_model.dart';

class BookingProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<BookingModel> _userBookings = [];
  List<BookingModel> _allBookings = [];
  bool _isLoading = false;

  List<BookingModel> get userBookings => _userBookings;
  List<BookingModel> get allBookings => _allBookings;
  bool get isLoading => _isLoading;

  void listenToUserBookings(String userId) {
    _firestoreService.getUserBookings(userId).listen((QuerySnapshot snapshot) {
      _userBookings = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    });
  }

  void listenToAllBookings() {
    _firestoreService.getAllBookings().listen((QuerySnapshot snapshot) {
      _allBookings = snapshot.docs
          .map((doc) => BookingModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners();
    });
  }

  Future<String> createBooking(String userId, Map<String, dynamic> details) async {
    try {
      _isLoading = true;
      notifyListeners();
      return await _firestoreService.createBooking(userId, details);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firestoreService.updateBookingStatus(bookingId, status);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Soft delete - just changes status to 'deleted'
  Future<void> deleteBooking(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Update status to 'deleted' rather than actually removing the document
      await _firestoreService.updateBookingStatus(bookingId, 'deleted');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Permanent delete - actually removes the document from Firestore
  Future<void> permanentlyDeleteBooking(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Actually delete the booking from Firestore
      await _firestoreService.deleteBooking(bookingId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptBooking(String bookingId) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _firestoreService.updateBookingStatus(bookingId, 'accepted');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}