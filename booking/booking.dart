import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class SalonBookingScreen extends StatefulWidget {
  static const String routeName = '/salon-booking';

  const SalonBookingScreen({super.key});

  @override
  State<SalonBookingScreen> createState() => _SalonBookingScreenState();
}

class _SalonBookingScreenState extends State<SalonBookingScreen> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Dropdown values
  String? _selectedCity;
  String? _selectedSalon;
  String? _selectedBarber;
  String? _selectedService;
  String? _selectedTimeSlot;

  // Sample data
  final List<String> _cities = [
    'Homagama',
    'Maharagama',
  ];
  final Map<String, List<String>> _salonsByCity = {
    'Homagama': ['Salon U', 'Isuru salon', 'Salon Highly',],
    'Maharagama': ['Looks Salon', 'Ruvoma SALON'],
  };
  final Map<String, List<String>> _barbersBySalon = {
    'Salon U': ['John Doe', 'Mike Smith'],
    'Isuru salon': ['David Johnson', 'Robert Brown'],
    'Salon Highly': ['James Wilson', 'Thomas Taylor'],
    'Looks Salon': ['William White', 'Christopher Lee'],
    'Ruvoma SALON': ['Daniel Clark', 'Matthew Lewis'],
  };
  final List<String> _services = [
    'Haircut',
    'Beard Trim',
    'Hair Coloring',
    'Shave',
    'Hair Treatment',
  ];

  final List<String> _timeSlots = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to book an appointment')),
        );
        return;
      }

      final bookingDetails = {
        'city': _selectedCity,
        'salon': _selectedSalon,
        'barber': _selectedBarber,
        'service': _selectedService,
        'date': _dateController.text,
        'timeSlot': _selectedTimeSlot,
      };

      try {
        await context.read<BookingProvider>().createBooking(userId, bookingDetails);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking created successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating booking: $e')),
          );
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: const InputDecoration(
                  labelText: 'Select City',
                  border: OutlineInputBorder(),
                ),
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                    _selectedSalon = null;
                    _selectedBarber = null;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSalon,
                decoration: const InputDecoration(
                  labelText: 'Select Salon',
                  border: OutlineInputBorder(),
                ),
                items: _selectedCity == null
                    ? []
                    : _salonsByCity[_selectedCity]!.map((String salon) {
                        return DropdownMenuItem<String>(
                          value: salon,
                          child: Text(salon),
                        );
                      }).toList(),
                onChanged: _selectedCity == null
                    ? null
                    : (String? newValue) {
                        setState(() {
                          _selectedSalon = newValue;
                          _selectedBarber = null;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a salon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedBarber,
                decoration: const InputDecoration(
                  labelText: 'Select Barber',
                  border: OutlineInputBorder(),
                ),
                items: _selectedSalon == null
                    ? []
                    : _barbersBySalon[_selectedSalon]!.map((String barber) {
                        return DropdownMenuItem<String>(
                          value: barber,
                          child: Text(barber),
                        );
                      }).toList(),
                onChanged: _selectedSalon == null
                    ? null
                    : (String? newValue) {
                        setState(() {
                          _selectedBarber = newValue;
                        });
                      },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a barber';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedService,
                decoration: const InputDecoration(
                  labelText: 'Select Service',
                  border: OutlineInputBorder(),
                ),
                items: _services.map((String service) {
                  return DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedService = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a service';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTimeSlot,
                decoration: const InputDecoration(
                  labelText: 'Select Time Slot',
                  border: OutlineInputBorder(),
                ),
                items: _timeSlots.map((String timeSlot) {
                  return DropdownMenuItem<String>(
                    value: timeSlot,
                    child: Text(timeSlot),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTimeSlot = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time slot';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
