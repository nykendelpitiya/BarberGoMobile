import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/booking_model.dart';
import 'package:intl/intl.dart';
import '../../screens/splash/splash_screen.dart';

class AdminScreen extends StatefulWidget {
  static String routeName = "/admin";

  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Track expanded booking items with a simple Map
  Map<String, bool> _expandedItems = {};
  bool _isVerifyingRole = true;

  @override
  void initState() {
    super.initState();
    _verifyAdminRole();
    _loadBookings();
  }

  // Verify that the current user is an admin
  Future<void> _verifyAdminRole() async {
    setState(() {
      _isVerifyingRole = true;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAdmin = await authProvider.verifyAdminRole();
      
      if (!isAdmin) {
        // If not admin, redirect to splash screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Access denied: Admin privileges required'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.of(context).pushReplacementNamed(SplashScreen.routeName);
        }
      }
      
      if (mounted) {
        setState(() {
          _isVerifyingRole = false;
        });
      }
    });
  }

  void _loadBookings() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BookingProvider>(context, listen: false);
      provider.listenToAllBookings();
    });
  }

  // Simple toggle function to expand/collapse booking details
  void _toggleExpanded(String bookingId) {
    setState(() {
      // If the booking is not in the map, default to false (collapsed)
      bool currentState = _expandedItems[bookingId] ?? false;
      // Toggle the state
      _expandedItems[bookingId] = !currentState;
    });
  }
  
  // Show logout confirmation dialog
  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Log Out"),
              onPressed: () {
                Navigator.of(context).pop();
                // Get reference to AuthProvider before starting logout
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                
                // Show loading indicator during logout
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
                
                // Call signOut method
                authProvider.signOut().then((_) {
                  // Close loading dialog
                  Navigator.of(context).pop();
                  
                  // Navigate to splash screen and clear the navigation stack
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SplashScreen.routeName,
                    (route) => false,
                  );
                }).catchError((error) {
                  // Close loading dialog
                  Navigator.of(context).pop();
                  
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing out: ${error.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, BookingModel booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Booking"),
          content: const Text(
            "Are you sure you want to delete this booking?",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text("Delete"),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBooking(context, booking.id);
              },
            ),
          ],
        );
      },
    );
  }

  // Delete booking
  void _deleteBooking(BuildContext context, String bookingId) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Call delete method from provider
    context.read<BookingProvider>().deleteBooking(bookingId).then((_) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking deleted successfully'),
          backgroundColor: Colors.red,
        ),
      );
    }).catchError((error) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting booking: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while verifying role
    if (_isVerifyingRole) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verifying admin privileges...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: authProvider.isLoading
                    ? null  // Disable when loading
                    : () {
                        showLogoutConfirmationDialog(context);
                      },
              );
            },
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          if (bookingProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = bookingProvider.allBookings;

          if (bookings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              // Get the expansion state from the map
              final isExpanded = _expandedItems[booking.id] ?? false;
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.blue),
                      title: Text('Booking #${booking.id}'),
                      subtitle: Text(
                        DateFormat('MM/dd/yyyy HH:mm').format(booking.timestamp),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(booking.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      onTap: () => _toggleExpanded(booking.id),
                    ),
                    // Always show the Actions section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Actions',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (booking.status.toLowerCase() == 'pending') ...[
                                ElevatedButton(
                                  onPressed: () async {
                                    final provider = Provider.of<BookingProvider>(context, listen: false);
                                    await provider.updateBookingStatus(booking.id, 'accepted');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text('Accept'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final provider = Provider.of<BookingProvider>(context, listen: false);
                                    await provider.updateBookingStatus(booking.id, 'cancelled');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ],
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Booking'),
                                      content: const Text('Are you sure you want to delete this booking?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final provider = Provider.of<BookingProvider>(context, listen: false);
                                            await provider.updateBookingStatus(booking.id, 'deleted');
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expandable details section
                    if (_expandedItems[booking.id] ?? false)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // User Information
                            _buildSectionHeader('User Information'),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              Icons.person_outline,
                              'User ID',
                              booking.userId,
                            ),
                            const SizedBox(height: 16),
                            
                            // Booking Details
                            _buildSectionHeader('Booking Details'),
                            const SizedBox(height: 8),
                            if (booking.details.isNotEmpty)
                              ...booking.details.entries.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          '${e.key}:',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          e.value?.toString() ?? 'N/A',
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ).toList()
                            else
                              const Text(
                                'No additional details available',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            const SizedBox(height: 16),
                            
                            // Booking History
                            _buildSectionHeader('Booking History'),
                            const SizedBox(height: 8),
                            _buildTimelineItem(
                              'Created',
                              booking.timestamp,
                              Colors.blue,
                              isFirst: true,
                              isLast: booking.status.toLowerCase() == 'pending',
                            ),
                            if (booking.status.toLowerCase() == 'accepted')
                              _buildTimelineItem(
                                'Accepted',
                                booking.timestamp.add(const Duration(hours: 1)), // Placeholder
                                Colors.green,
                                isFirst: false,
                                isLast: true,
                              )
                            else if (booking.status.toLowerCase() == 'cancelled')
                              _buildTimelineItem(
                                'Cancelled',
                                booking.timestamp.add(const Duration(hours: 1)), // Placeholder
                                Colors.red,
                                isFirst: false,
                                isLast: true,
                              )
                            else if (booking.status.toLowerCase() == 'deleted')
                              _buildTimelineItem(
                                'Deleted',
                                booking.timestamp.add(const Duration(hours: 2)), // Placeholder
                                Colors.grey[700]!,
                                isFirst: false,
                                isLast: true,
                              ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Accept booking
  void _acceptBooking(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    context.read<BookingProvider>().acceptBooking(bookingId).then((_) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking Accepted'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error accepting booking: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  // Cancel booking
  void _cancelBooking(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cancel Booking"),
          content: const Text("Are you sure you want to cancel this booking?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<BookingProvider>().updateBookingStatus(bookingId, 'cancelled');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Build action buttons based on booking status
  Widget _buildActionButtons(BuildContext context, BookingModel booking) {
    final status = booking.status.toLowerCase();
    
    if (status == 'pending') {
      // For pending bookings, show accept, cancel, and delete options
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => _showDeleteConfirmationDialog(context, booking),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[700]!),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _updateBookingStatus(context, booking.id, 'cancelled'),
                icon: const Icon(Icons.cancel_outlined),
                label: const Text('Cancel'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _updateBookingStatus(context, booking.id, 'accepted'),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Accept'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else if (status == 'accepted') {
      // For accepted bookings, show cancel and delete options
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmationDialog(context, booking),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[700]!),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () => _updateBookingStatus(context, booking.id, 'cancelled'),
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancel Booking'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      );
    } else if (status == 'cancelled') {
      // For cancelled bookings, show reactivate and delete options
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmationDialog(context, booking),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[700]!),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(context, booking.id, 'pending'),
            icon: const Icon(Icons.restore),
            label: const Text('Reactivate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      );
    } else if (status == 'deleted') {
      // For deleted bookings, show reactivate option
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () => _updateBookingStatus(context, booking.id, 'pending'),
            icon: const Icon(Icons.restore),
            label: const Text('Restore'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      );
    }
    
    // Fallback for unknown status
    return const SizedBox.shrink();
  }

  // Update booking status and handle UI state
  void _updateBookingStatus(BuildContext context, String bookingId, String newStatus) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Update status in Firestore
    context.read<BookingProvider>().updateBookingStatus(bookingId, newStatus).then((_) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking ${_getStatusActionText(newStatus)}'),
          backgroundColor: _getStatusColor(newStatus),
        ),
      );
    }).catchError((error) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  String _getStatusActionText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'reactivated';
      case 'accepted':
        return 'accepted';
      case 'cancelled':
        return 'cancelled';
      case 'deleted':
        return 'deleted';
      default:
        return 'updated';
    }
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String action,
    DateTime timestamp,
    Color color, {
    required bool isFirst,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!isFirst)
                Positioned(
                  top: 0,
                  bottom: 30,
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
              if (!isLast)
                Positioned(
                  top: 30,
                  bottom: 0,
                  child: Container(
                    width: 2,
                    color: Colors.grey[300],
                  ),
                ),
              Positioned(
                top: 20,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(timestamp);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'cancelled':
        return Colors.orange;
      case 'deleted':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}