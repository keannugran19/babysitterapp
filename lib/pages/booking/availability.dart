import 'package:flutter/material.dart';

class AvailabilitySelector extends StatelessWidget {
  final Map<String, bool> selectedDays;

  const AvailabilitySelector({
    super.key,
    required this.selectedDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Days',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...selectedDays.keys.map((day) {
            return selectedDays[day] == true
                ? ListTile(
                    leading: const Icon(Icons.check, color: Colors.green),
                    title: Text(
                      day,
                      style: const TextStyle(color: Colors.black),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
