//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'
//NOTE: If you want to navigate to this page, it requires babysitter ID. Just put a temporary ID 'samplebabysitter01'

import 'package:babysitterapp/pages/booking/requestpage.dart';
import 'package:babysitterapp/pages/chat/chatboxpage.dart';
import 'package:babysitterapp/services/firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/feedback.dart';
import '../../models/user_model.dart';
import '../../services/babysitter_service.dart';
import '../../services/current_user_service.dart';
import '../../views/customwidget.dart';
import '/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/user.dart';
import '/controller/userdata.dart';

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
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  final BabysitterService babysitterService = BabysitterService();
  // get data from firestore using the model
  UserModel? currentUser;
  UserModel? babysitter;

  // custom widget
  final CustomWidget customWidget = CustomWidget();

  // load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // load babysitter data using email
  Future<void> loadBabysitter() async {
    final UserModel? fetchedBabysitter =
        await babysitterService.getBabysitterByEmail(widget.babysitterID);
    setState(() {
      babysitter = fetchedBabysitter;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
    loadBabysitter();
  }

  // !!! Code below is dummy implementation of data, 11/25
  // final FirestoreService firestoreService = FirestoreService();
  // final UserData userData = UserData();
  // final CustomWidget customWidget = CustomWidget();
  // late User? babysitter;
  // late List<FeedBack>? feedbackList;
  // late double babysitterRating;
  // late int noOfReviews;
  // late bool isExpanded;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchUserData();
  //   babysitter = null;
  //   feedbackList = [];
  //   babysitterRating = 0;
  //   noOfReviews = 0;
  //   isExpanded = false;
  // }

  // //fetch babysitter data based on babysitterID
  // Future<void> fetchUserData() async {
  //   babysitter = await firestoreService.getUserData(widget.babysitterID);
  //   feedbackList = await firestoreService.getFeedbackList(widget.babysitterID);
  //   if (feedbackList != null && feedbackList!.isNotEmpty) {
  //     noOfReviews = feedbackList!.length;
  //     babysitterRating =
  //         (feedbackList!.fold(0, (sum, item) => sum + item.rating)) /
  //             feedbackList!.length;
  //   }
  //   setState(() {});
  // }
  // !!!

  @override
  void dispose() {
    super.dispose();
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
                  babysitter!.rating ?? 0.0,
                  10, // Replace with actual number of reviews,
                ),
                customWidget.aboutHeader(
                  babysitter!.name.split(' ')[0],
                  babysitter!.information ?? 'No information provided',
                  false,
                  () {
                    setState(() {
                      // Handle expand/collapse logic
                    });
                  },
                ),
                customWidget.myDivider(),
                customWidget.experienceHeader(babysitter!.experience ?? []),
                customWidget.myDivider(),
                customWidget.feedbackHeader(widget.babysitterID, []),
              ],
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
