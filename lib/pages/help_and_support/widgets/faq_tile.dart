import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({required this.question, required this.answer, super.key});

  @override
  _FAQTileState createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) {
              setState(() {
                _isHovered = true; //when mouse enters
              });
            },
            onExit: (_) {
              setState(() {
                _isHovered = false; //when mouse exits
              });
            },
            child: Container(
              color: _isHovered ? primaryColor : Colors.transparent,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                title: Text(
                  widget.question,
                  style: TextStyle(
                    color: _isHovered ? Colors.white : primaryColor,
                    fontSize: 16.0,
                  ),
                ),
                iconColor: _isHovered ? Colors.white : primaryColor,
                textColor: primaryColor,
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 4.0,
                        height: 60.0,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          widget.answer,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: _isHovered ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.purple[100],
            thickness: 1.0,
          ),
        ],
      ),
    );
  }
}
