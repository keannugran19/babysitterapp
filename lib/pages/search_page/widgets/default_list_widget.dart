import 'package:flutter/material.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/styles/size.dart';

class DefaultListWidget extends StatelessWidget {
  final List<String> searchHistory;
  final Function(String) onHistoryItemClick;
  final Function() onClearHistory;

  const DefaultListWidget({
    super.key,
    required this.searchHistory,
    required this.onHistoryItemClick,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: sizeConfig.widthSize(context) * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: textColor),
                onPressed: onClearHistory,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8.0,
            children: searchHistory.map((history) {
              return GestureDetector(
                onTap: () => onHistoryItemClick(history),
                child: Chip(
                  label: Text(
                    history,
                    style: const TextStyle(color: textColor),
                  ),
                  backgroundColor: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: secondaryColor,
                      width: 1.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
