import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final Function(double) onDurationChanged;

  const TimeSelector({
    super.key,
    required this.onDurationChanged,
  });

  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  double _selectedHours = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Duration (in hours)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Slider(
            value: _selectedHours,
            min: 1,
            max: 12,
            divisions: 11,
            label:
                "${_selectedHours.toInt()} hr${_selectedHours > 1 ? 's' : ''}",
            onChanged: (double value) {
              setState(() {
                _selectedHours = value;
                widget.onDurationChanged(
                    _selectedHours); // Pass the selected duration to the parent
              });
            },
          ),
          Text(
            "Selected duration: ${_selectedHours.toInt()} hour${_selectedHours > 1 ? 's' : ''}",
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
