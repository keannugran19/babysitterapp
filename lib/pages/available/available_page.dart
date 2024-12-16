import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({super.key});

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  final List<Map<String, String>> _availability =
      []; // List to store availability

  Future<void> _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final DateTime pickedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final String formattedDate =
        DateFormat('MMMM dd, yyyy').format(pickedDateTime);
    final String formattedTime = DateFormat('hh:mm a').format(pickedDateTime);

    setState(() {
      _availability.add({'date': formattedDate, 'time': formattedTime});
    });
  }

  // void _clearAvailability() {
  //   setState(() {
  //     _availability.clear();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Availability',
        ),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Schedule',
              style: TextStyle(
                fontSize: 22,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _pickDateTime,
              icon: const Icon(Icons.add, color: backgroundColor),
              label: const Text(
                'Pick a Schedule',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            const Text(
              'Your Availability',
              style: TextStyle(
                fontSize: 22,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),

            // Availability list display
            _availability.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _availability.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(_availability[index]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            _availability.removeAt(index);
                          });
                        },
                        child: Card(
                          color: tertiaryColor,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            title: Text(
                              _availability[index]['date']!,
                              style: const TextStyle(
                                fontSize: 18,
                                color: primaryColor,
                              ),
                            ),
                            subtitle: Text(
                              _availability[index]['time']!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: primaryColor),
                              onPressed: () {
                                setState(() {
                                  _availability.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No availability set yet!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
