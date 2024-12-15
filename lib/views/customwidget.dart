import 'dart:io';

import 'package:babysitterapp/components/button.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/messages.dart';
import '../models/user_model.dart';
import '../services/firestore.dart';
import '../styles/colors.dart';

//floating button for profile page
class CustomWidget {
  final FirestoreService firestoreService = FirestoreService();
  Widget floatingBtn(
    Function() onPressed,
    Color backgroundColor,
    Color borderColor,
    Icon icon,
    String label,
    Color txtColor,
  ) =>
      ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: borderColor,
              ),
            )),
        icon: icon,
        label: Text(
          label,
          style: TextStyle(color: txtColor),
        ),
      );

//carousel item for feedback header
  // Widget carouselItem(BuildContext context, String? img, String name,
  //     int rating, String feedback, List? images) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       if (img != null)
  //         CircleAvatar(
  //           backgroundImage: AssetImage(img),
  //           radius: 40,
  //         ),
  //       Text(
  //         name,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //         ),
  //       ),
  //       ratingStar(rating, 30, primaryColor),
  //       Text(
  //         feedback,
  //         textAlign: TextAlign.center,
  //         maxLines: 2,
  //         overflow: TextOverflow.ellipsis,
  //       ),
  //       Wrap(
  //           children: (images != null)
  //               ? images.map((image) {
  //                   return Padding(
  //                     padding: const EdgeInsets.all(3),
  //                     child: InkWell(
  //                       onTap: () {
  //                         showDialog(
  //                           context: context,
  //                           builder: (context) => Dialog(
  //                             backgroundColor: backgroundColor.withOpacity(0),
  //                             child: Stack(
  //                               alignment: Alignment.center,
  //                               children: [
  //                                 Image.asset(
  //                                   image,
  //                                   fit: BoxFit.contain,
  //                                 ),
  //                                 Positioned(
  //                                   top: 1.0,
  //                                   left: 1.0,
  //                                   child: IconButton(
  //                                     icon: const Icon(
  //                                       Icons.clear,
  //                                       color: backgroundColor,
  //                                       size: 30,
  //                                     ),
  //                                     onPressed: () {
  //                                       Navigator.of(context).pop();
  //                                     },
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       child: Image.asset(
  //                         image,
  //                         height: (images.length == 1) ? 250 : 120,
  //                         width: (images.length == 1) ? 250 : 120,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   );
  //                 }).toList()
  //               : []),
  //     ],
  //   );
  // }

  //divider for profile page
  Widget myDivider() => const Divider(
        color: Color.fromARGB(255, 216, 216, 216),
      );

  //main header for profile page
  Widget mainHeader(
    String name,
    String email,
    String? img,
    String address,
    DateTime birtdate,
    String gender,
    double rate,
    double rating,
    int reviewsNo,
    List? availability,
  ) {
    DateTime currentDate = DateTime.now();
    TextStyle whiteTextColor() => const TextStyle(color: backgroundColor);
    int age = currentDate.year - birtdate.year;

    if (birtdate.month > currentDate.month ||
        (birtdate.month == currentDate.month &&
            birtdate.day > currentDate.day)) {
      age--;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: textColor.withOpacity(.5),
            blurRadius: 12,
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: img != ""
                    ? AssetImage(img!)
                    : const AssetImage('assets/images/default_user.png'),
              ),
              const SizedBox(height: 20),
              Text(
                '$name, $age',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: backgroundColor,
                ),
              ),
              Text(
                gender,
                style: whiteTextColor(),
              ),
              Text(
                address,
                style: whiteTextColor(),
              ),
              const SizedBox(height: 20),
              (rating != 0)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ratingStar(rating.toInt(), 30, Colors.amber),
                        Text(
                          rating.toString(),
                          style: whiteTextColor(),
                        ),
                      ],
                    )
                  : Container(),
              TextButton(
                onPressed: () {
                  //go to reviews list
                },
                child: Text(
                  (reviewsNo > 1)
                      ? '$reviewsNo reviews'
                      : (reviewsNo == 1)
                          ? '$reviewsNo review'
                          : 'No reviews yet',
                  style: const TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Availabilty',
                        style: whiteTextColor(),
                      ),
                      Row(
                        children: availability!
                            .map((a) => Text(
                                  a,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                    color: backgroundColor,
                                  ),
                                ))
                            .toList(),
                      ),
                      if (availability == [] || availability.isEmpty)
                        const Text(
                          'No availability yet',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: backgroundColor,
                          ),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Hourly rate',
                        style: whiteTextColor(),
                      ),
                      Text(
                        'PHP $rate/hr',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  //about header for profile page
  Widget aboutHeader(
    String userFirstName,
    String userAbout,
    bool isExpanded,
    Function() onPressed,
  ) =>
      Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About $userFirstName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                (userAbout != '') ? userAbout : 'No data yet.',
                textAlign: TextAlign.justify,
                maxLines: isExpanded ? null : 3,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onPressed,
                    icon: (userAbout != '')
                        ? (isExpanded)
                            ? const Icon(CupertinoIcons.chevron_up)
                            : const Icon(CupertinoIcons.chevron_down)
                        : Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  //experience header for profile page
  Widget experienceHeader(List experience) => Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Experience',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Column(
              children: experience.map((experience) {
                return Row(
                  children: [
                    const Icon(CupertinoIcons.checkmark_alt),
                    const SizedBox(width: 5),
                    Text(experience),
                  ],
                );
              }).toList(),
            ),
            if (experience.isEmpty) const Text('No experience yet'),
          ],
        ),
      );


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

  //Modal after submitting feedback
  Widget thankYouDialog(Function() onPressed) => SizedBox(
        height: 400,
        child: AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/success.gif'),
              const Text(
                'Thank You!',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Your review helps us maintain a high-quality babysitting experience.',
                textAlign: TextAlign.center,
              )
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('Ok'),
            ),
          ],
        ),
      );

  Widget rateAndReviewbottomModal(
    Widget leading1,
    String title1,
    Function() onTap1,
    Widget leading2,
    String title2,
    Function() onTap2,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: leading1,
            title: Text(title1),
            onTap: onTap1,
          ),
          ListTile(
            leading: leading2,
            title: Text(title2),
            onTap: onTap2,
          ),
        ],
      );

  Widget showImageDialog(BuildContext context, File image) => Dialog(
        backgroundColor: primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.file(
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
          ],
        ),
      );

  Widget rateAndReviewAlertDialog(
          String img, String content, List<Widget>? actions) =>
      AlertDialog(
        title: Image.asset(img),
        content: Text(content),
        actions: actions,
      );

  Widget alertDialogBtn(Widget child_, Color backgroundColor_,
          Color borderColor, Function() onPressed) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor_,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: borderColor,
                ),
              )),
          onPressed: onPressed,
          child: child_);

  //message container
  Widget messageContainer(bool isUser, Messages messages, Function() onTap_) =>
      InkWell(
        onTap: onTap_,
        child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isUser)
                  ? primaryColor
                  : const Color.fromARGB(255, 201, 201, 201),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            //check if the message is image or text
            child: Text(
              messages.msg,
              style: (isUser)
                  ? const TextStyle(color: primaryFgColor)
                  : const TextStyle(color: textColor),
            )),
      );

  //Line of each message
  Widget messageLine(bool isUser, Messages messages, UserModel? currentUser,
      UserModel? recipient, Function() onTap) {

    final DateTime currentDate = DateTime.now();
    final bool isYesterday = messages.timestamp.year < currentDate.year ||
        messages.timestamp.month < currentDate.month ||
        messages.timestamp.day < currentDate.day;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        //check if the message is from user or baby sitter
        crossAxisAlignment:
            (isUser) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Center(
            child: (messages.isClicked)
                ? (isYesterday)
                    ? Text(DateFormat('yyyy MMM dd, hh:mm a')
                        .format(messages.timestamp))
                    : Text(DateFormat('hh:mm a').format(messages.timestamp))
                : Container(),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment:
                (isUser) ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: (isUser)
                ? [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        (messages.isClicked)
                            ? Text(currentUser!.name.split(' ').first)
                            : Container(),
                        messageContainer(isUser, messages, onTap),
                      ],
                    ),
                    const SizedBox(width: 5),
                    CircleAvatar(
                      backgroundImage: const AssetImage(defaultImage),
                      foregroundImage:
                          AssetImage(currentUser!.img ?? defaultImage),

                      radius: 20,
                    ),
                  ]
                : [
                    CircleAvatar(
                      backgroundImage: const AssetImage(defaultImage),
                      foregroundImage:
                          AssetImage(recipient!.img ?? defaultImage),
                      radius: 20,
                    ),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (messages.isClicked)
                            ? Text(recipient.name.split(' ').first)
                            : Container(),
                        messageContainer(isUser, messages, onTap),
                      ],
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

class OfferModal extends StatelessWidget {
  final Function() iconOnPressed;
  final List<Widget> children;
  final Function() buttonOnPressed;
  const OfferModal({
    super.key,
    required this.iconOnPressed,
    required this.children,
    required this.buttonOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            title: const Text('Send offer'),
            leading: IconButton(
              onPressed: iconOnPressed,
              icon: const Icon(Icons.clear),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: children,
                ),
                AppButton(
                  onPressed: buttonOnPressed,
                  text: 'Send Offer',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListWithID {
  final String id;
  final List<Messages> data;
  const ListWithID({
    required this.id,
    required this.data,
  });
}
