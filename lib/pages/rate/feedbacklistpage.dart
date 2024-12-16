import 'package:babysitterapp/pages/rate/feedbackpage.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:babysitterapp/views/customwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedbackListPage extends StatefulWidget {
  final List<Map<String, dynamic>> feedbackList_;
  const FeedbackListPage({super.key, required this.feedbackList_});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final CustomWidget customWidget = CustomWidget();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedbacks'),
      ),
      body: ListView(
        children: widget.feedbackList_
            .map((feedback) => Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage(defaultImage),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          feedback['currentUserName'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        customWidget.ratingStar(
                          feedback['rating'],
                          20,
                          Colors.amber,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      feedback['feedbackMessage'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    trailing: const Icon(CupertinoIcons.chevron_right),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeedBackPage(
                              img: defaultImage,
                              name: feedback['currentUserName'],
                              rating: feedback['rating'],
                              feedback: feedback['feedbackMessage'],
                              images: feedback['images'] ?? [],
                            ),
                          ));
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
