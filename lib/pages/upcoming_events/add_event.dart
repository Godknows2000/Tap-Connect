import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tapconnect/models/venues.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String? selectedVenueId;
  List<Venue> venues = [];

  @override
  void initState() {
    super.initState();
    _fetchVenues();
  }

  Future<void> _fetchVenues() async {
    final query = await FirebaseFirestore.instance.collection('venues').get();
    setState(() {
      venues = query.docs
          .map((doc) => Venue.fromJson(doc.data()..['id'] = doc.id))
          .toList();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        // Convert TimeOfDay to DateTime for consistent formatting
        final now = DateTime.now();
        final dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );
        timeController.text = DateFormat('hh:mm a').format(dateTime);
      });
    }
  }

  Future<void> _addEvent() async {
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        selectedVenueId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    try {
      print(
          'Date input: ${dateController.text}, Time input: ${timeController.text}'); // Debug log
      final dateFormat = DateFormat('yyyy-MM-dd');
      final date = dateFormat.parse(dateController.text);

      // Try parsing time with multiple formats
      DateTime time;
      try {
        time = DateFormat('hh:mm a').parse(timeController.text);
      } catch (e) {
        try {
          time = DateFormat('HH:mm')
              .parse(timeController.text); // Try 24-hour format
          // Convert to 12-hour AM/PM for consistency
          timeController.text = DateFormat('hh:mm a').format(time);
        } catch (e) {
          throw FormatException(
              'Invalid time format. Expected HH:MM AM/PM or HH:MM, got ${timeController.text}');
        }
      }

      final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );

      await FirebaseFirestore.instance.collection('events').add({
        'title': titleController.text,
        'date': dateController.text,
        'time': timeController.text,
        'timestamp': Timestamp.fromDate(dateTime),
        'venueId': selectedVenueId,
        'isGoing': false,
        'checkedIn': false,
        'checkedInBy': [],
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error adding event: $e'); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error adding event: Invalid date or time format. Use YYYY-MM-DD for date and HH:MM AM/PM for time. Details: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title:
            const Text('Add New Event', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title *',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD) *',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (HH:MM AM/PM) *',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                readOnly: true,
                onTap: () => _selectTime(context),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Venue *',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                value: selectedVenueId,
                items: venues
                    .map((venue) => DropdownMenuItem<String>(
                          value: venue.id,
                          child: Text(
                            venue.name ?? 'Unknown Venue',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVenueId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Add Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
