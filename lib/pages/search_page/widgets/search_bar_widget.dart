import 'package:babysitterapp/styles/responsive.dart';
import 'package:flutter/material.dart';
import 'package:babysitterapp/styles/colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final Function() onSearchSubmit;
  final VoidCallback onBackPressed;
  final VoidCallback onReset;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchSubmit,
    required this.onBackPressed,
    required this.onReset,
  });

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    widget.searchController.addListener(() {
      widget.onSearchChanged(widget.searchController.text);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.searchController.removeListener(() {
      widget.onSearchChanged(widget.searchController.text);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: Responsive.getTextFontSize(context) / 2,
          ),
          child: Row(
            children: [
              // IconButton(
              //   icon: const Icon(Icons.arrow_back, color: accentColor),
              //   onPressed: widget.onBackPressed,
              // ),
              Expanded(
                child: TextField(
                  controller: widget.searchController,
                  // focusNode: _focusNode,
                  cursorColor: accentColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: backgroundColor,
                    prefixIcon: const Icon(Icons.search, color: accentColor),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.searchController.text.isNotEmpty) ...[
                          IconButton(
                            icon: const Icon(Icons.clear, color: accentColor),
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onSearchChanged('');
                              widget.onReset();
                            },
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.mic, color: accentColor),
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onSearchChanged('');
                              widget.onReset();
                            },
                          ),
                        ],
                        const Text(
                          '|',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: widget.onSearchSubmit,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: Responsive.getTextFontSize(context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    hintStyle: TextStyle(
                      color: accentColor,
                      fontSize: Responsive.getTextFontSize(context),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: accentColor,
                        width: Responsive.getBorderWidth(context),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: accentColor,
                        width: Responsive.getBorderWidth(context),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: accentColor,
                        width: Responsive.getBorderWidth(context),
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color: accentColor,
                    fontSize: Responsive.getTextFontSize(context),
                  ),
                  onSubmitted: (value) => widget.onSearchSubmit(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
