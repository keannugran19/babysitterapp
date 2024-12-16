import 'package:flutter/material.dart';

import '../../services/chat_service.dart';
import '../../styles/colors.dart';
import '../../views/customwidget.dart';

class FeedBackPage extends StatefulWidget {
  final String img;
  final String name;
  final int rating;
  final String feedback;
  final List images;
  const FeedBackPage({
    super.key,
    required this.img,
    required this.name,
    required this.rating,
    required this.feedback,
    required this.images,
  });

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  final CustomWidget customWidget = CustomWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: const AssetImage(defaultImage),
                foregroundImage: AssetImage(widget.img),
                radius: 60,
              ),
              const SizedBox(height: 30),
              Text(
                widget.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              customWidget.ratingStar(widget.rating, 30, primaryColor),
              Text(
                widget.feedback,
                textAlign: TextAlign.center,
              ),
              Wrap(
                  children: (widget.images.isNotEmpty)
                      ? widget.images.map((image) {
                          return Padding(
                            padding: const EdgeInsets.all(3),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor:
                                        backgroundColor.withOpacity(0),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          image,
                                          fit: BoxFit.contain,
                                        ),
                                        Positioned(
                                          top: 1.0,
                                          left: 1.0,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: backgroundColor,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                image,
                                height: (widget.images.length == 1) ? 250 : 120,
                                width: (widget.images.length == 1) ? 250 : 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList()
                      : []),
            ],
          ),
        ),
      ),
    );
  }
}
