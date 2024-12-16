import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class FilterBarWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterBarWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['Babysitters', 'Near you'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: filters.map((filter) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: selectedFilter == filter ? primaryColor : Colors.white,
                  border: Border.all(
                    color: secondaryColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    onFilterChanged(filter);
                  },
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: selectedFilter == filter
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
