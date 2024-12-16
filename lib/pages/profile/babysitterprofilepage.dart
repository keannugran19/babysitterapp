import 'package:babysitterapp/pages/booking/requestpage.dart';
import 'package:babysitterapp/pages/chat/chatboxpage.dart';
import 'package:babysitterapp/pages/rate/feedbacklistpage.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_model.dart';
import '../../services/babysitter_service.dart';
import '../../services/current_user_service.dart';
import '../../views/customwidget.dart';
import '/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BabysitterProfilePage extends StatefulWidget {
  final String babysitterID;
  final String currentUserID;
  const BabysitterProfilePage({
    super.key,
    required this.babysitterID,
    required this.currentUserID,
  });

  @override
  State<BabysitterProfilePage> createState() => _BabysitterProfilePageState();
}

class _BabysitterProfilePageState extends State<BabysitterProfilePage> {
  // Services
  CurrentUserService firestoreService = CurrentUserService();
  final BabysitterService babysitterService = BabysitterService();

  // Data Models
  UserModel? currentUser;
  UserModel? babysitter;
  List<Map<String, dynamic>> feedbackList = [];
  bool isLoadingFeedback = true;
  bool isExpanded = false;

  // Custom Widget
  final CustomWidget customWidget = CustomWidget();

  // Load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // Load babysitter data
  Future<void> loadBabysitter() async {
    final UserModel? fetchedBabysitter =
        await babysitterService.getBabysitterByEmail(widget.babysitterID);
    setState(() {
      babysitter = fetchedBabysitter;
    });

    if (fetchedBabysitter != null) {
      loadFeedbacks(fetchedBabysitter.name);
    }
  }

  // Load babysitter feedbacks
  Future<void> loadFeedbacks(String babysitterName) async {
    try {
      final feedbacks = await babysitterService
          .fetchFeedbacksByBabysitterName(babysitterName);
      setState(() {
        feedbackList = feedbacks;
      });
    } catch (e) {
      // Handle error (e.g., log it or show a snackbar)
    } finally {
      setState(() {
        isLoadingFeedback = false;
      });
    }
  }

  double calculateAverageRating() {
    if (feedbackList.isEmpty) {
      return 0.0; // Return 0.0 if the list is empty
    }

    // Extract all ratings from the feedbackList
    final ratings = feedbackList.map((feedback) => feedback['rating'] as int);

    // Calculate the sum of all ratings
    final int totalRating = ratings.fold(0, (sum, rating) => sum + rating);

    // Calculate the average and round to 1 decimal place
    double average = totalRating / feedbackList.length;
    return double.parse(average.toStringAsFixed(1));
  }
  // Initiate loading in initState
  @override
  void initState() {
    super.initState();
    loadUserData();
    loadBabysitter();
  }

  @override
  Widget build(BuildContext context) {
    return (babysitter != null)
        ? Scaffold(
            appBar: AppBar(
              title: Text(babysitter!.name),
              actions: [
                IconButton(
                  onPressed: () {
                    final Uri phoneUri =
                        Uri(scheme: 'tel', path: babysitter!.phone);
                    launchUrl(phoneUri);
                  },
                  icon: const Icon(Icons.phone),
                ),
              ],
            ),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                customWidget.floatingBtn(
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBoxPage(
                          recipientID: widget.babysitterID,
                          currentUserID: widget.currentUserID,
                        ),
                      ),
                    );
                  },
                  backgroundColor,
                  primaryColor,
                  const Icon(CupertinoIcons.chat_bubble_2, color: primaryColor),
                  'Message',
                  primaryColor,
                ),
                customWidget.floatingBtn(
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BookingRequestPage(
                          babysitterImage: babysitter!.img ?? '',
                          babysitterName: babysitter!.name,
                          babysitterEmail: babysitter!.email,
                          parentName: currentUser!.name,
                          babysitterRate: babysitter!.rate!,
                          babysitterAddress: babysitter!.address!,
                          babysitterGender: babysitter!.gender!,
                          babysitterBirthday: babysitter!.age!,
                        ),
                      ),
                    );
                  },
                  primaryColor,
                  primaryColor,
                  const Icon(CupertinoIcons.chevron_right_2, size: 15),
                  'Book Babysitter',
                  backgroundColor,
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: ListView(
              children: [
                customWidget.mainHeader(
                  babysitter!.name,
                  babysitter!.email,
                  babysitter!.img ?? '',
                  babysitter!.address ?? 'Unknown Address',
                  babysitter!.age!,
                  babysitter!.gender ?? 'Unknown Gender',
                  babysitter!.rate!,
                  calculateAverageRating(),
                  feedbackList.length,
                  babysitter!.availability ?? [],
                ),
                customWidget.aboutHeader(
                  babysitter!.name.split(' ')[0],
                  babysitter!.information ?? 'No information provided',
                  isExpanded,
                  () {
                    setState(() {
                      // Handle expand/collapse logic
                      isExpanded = !isExpanded;
                    });
                  },
                ),
                customWidget.myDivider(),
                customWidget.experienceHeader(babysitter!.experience!),
                customWidget.myDivider(),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                  child: Column(
                    children: [
                      const Text(
                        'Feedback',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      isLoadingFeedback
                          ? const CircularProgressIndicator()
                          : (feedbackList.isNotEmpty)
                              ? CarouselSlider(
                                  items: feedbackList.map((feedback) {
                                    return carouselItem(
                                      context,
                                      currentUser!.img ?? '',
                                      feedback['currentUserName'] ??
                                          'Anonymous',
                                      feedback['rating'] ?? 0,
                                      feedback['feedbackMessage'] ?? '',
                                      feedback['images'] ?? [],
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    viewportFraction: .9,
                                    height: 500,
                                    autoPlay: feedbackList.length > 1,
                                    enableInfiniteScroll:
                                        feedbackList.length > 1,
                                    enlargeCenterPage: true,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(40),
                                  child: Text('No feedback yet'),
                                ),
                      feedbackList.isNotEmpty
                          ? TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeedbackListPage(
                                          feedbackList_: feedbackList),
                                    ));
                              },
                              child: const Text('See all reviews'),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget carouselItem(BuildContext context, String? img, String name,
      int rating, String feedback, List? images) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (img != null)
          CircleAvatar(
            backgroundImage: const AssetImage(defaultImage),
            foregroundImage: AssetImage(img),
            radius: 40,
          ),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        ratingStar(rating, 30, primaryColor),
        Text(
          feedback,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Wrap(
            children: (images != null)
                ? images.map((image) {
                    return Padding(
                      padding: const EdgeInsets.all(3),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: backgroundColor.withOpacity(0),
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
                          height: (images.length == 1) ? 250 : 120,
                          width: (images.length == 1) ? 250 : 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList()
                : []),
      ],
    );
  }

  //rating star icon
  Widget ratingStar(i, double size_, Color starColor) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int x = 0; x < i; x++)
            Icon(
              Icons.star,
              color: starColor,
              size: size_,
            ),
          for (int y = 0; y < 5 - i; y++)
            Icon(
              Icons.star,
              color: Colors.grey,
              size: size_,
            ),
        ],
      );
}
