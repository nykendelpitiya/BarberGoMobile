import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String status;
  final DateTime timestamp;
  final Map<String, dynamic> details;

  BookingModel({
    required this.id,
    required this.userId,
    required this.status,
    required this.timestamp,
    required this.details,
  });

  factory BookingModel.fromMap(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'pending',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      details: data['details'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'status': status,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
    };
  }
}