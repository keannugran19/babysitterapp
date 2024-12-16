import 'package:flutter/material.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/models/search_result.dart';
import 'package:babysitterapp/styles/responsive.dart';

class AutocompleteWidget extends StatelessWidget {
  final List<SearchResult> searchResults;
  final Function(SearchResult) onLabelClick;

  const AutocompleteWidget({
    super.key,
    required this.searchResults,
    required this.onLabelClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Responsive.getResponsivePadding(context),
      child: Wrap(
        spacing: Responsive.getTextFontSize(context) / 2,
        runSpacing: Responsive.getTextFontSize(context) / 3,
        children: searchResults.map((result) {
          return InputChip(
            label: Text(
              result.location,
              style: TextStyle(
                color: textColor,
                fontSize: Responsive.getTextFontSize(context),
              ),
            ),
            backgroundColor: backgroundColor,
            onPressed: () => onLabelClick(result),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: secondaryColor,
                width: Responsive.getBorderWidth(context),
              ),
              borderRadius: BorderRadius.circular(
                Responsive.getBorderRadius(context),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
