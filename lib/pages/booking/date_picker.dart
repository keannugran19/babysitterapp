import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class DatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const DatePicker({super.key, required this.onDateSelected});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? selectedDate;

  // Helper function to find the next Monday or Tuesday
  DateTime getNextSelectableDate() {
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    // If today is Monday or Tuesday, use today
    if (currentDay == DateTime.monday || currentDay == DateTime.tuesday) {
      return now;
    }

    // Otherwise, find the next Monday or Tuesday
    DateTime nextDay = now;
    if (currentDay < DateTime.monday) {
      nextDay = now.add(Duration(days: DateTime.monday - currentDay));
    } else if (currentDay < DateTime.tuesday) {
      nextDay = now.add(Duration(days: DateTime.tuesday - currentDay));
    } else {
      nextDay = now.add(Duration(days: (7 - currentDay + DateTime.monday) % 7));
    }

    return nextDay;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: getNextSelectableDate(), // Set the next valid day
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      selectableDayPredicate: (DateTime date) {
        // Allow only Mondays and Tuesdays
        return date.weekday == DateTime.monday ||
            date.weekday == DateTime.wednesday||
            date.weekday == DateTime.friday;
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = selectedDate == null
        ? 'No date selected!'
        : DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!);

    return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selectedDate == null
                        ? Colors.grey
                        : Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Select Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
