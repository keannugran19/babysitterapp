import 'dart:io';

import 'package:babysitterapp/services/chat_service.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import '../../services/current_user_service.dart';
import '../../services/search_service.dart';
import '../homepage/home_page.dart';
import '/views/customwidget.dart';
import '/components/button.dart';
import '/styles/colors.dart';
import 'package:flutter/material.dart';

class RateAndReviewPage extends StatefulWidget {
  final String babysitterName;
  const RateAndReviewPage({super.key, required this.babysitterName});

  @override
  State<RateAndReviewPage> createState() => _RateAndReviewPageState();
}

class _RateAndReviewPageState extends State<RateAndReviewPage> {
  // custom widgets
  CustomWidget customWidget = CustomWidget();
  // call firestore services
  CurrentUserService firestoreService = CurrentUserService();
  SearchService searchService = SearchService();

  // get data from firestore using the model
  UserModel? currentUser;
  // selected babysitter
  Map<String, dynamic>? selectedBabysitter;

  // !
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;
  List<File> _images = []; // List to store selected images
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  // load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
    fetchSelectedBabysitterByName(widget.babysitterName);
  }

  // Fetch data from the selected babysitter
  Future<void> fetchSelectedBabysitterByName(String babysitterName) async {
    try {
      // Fetch babysitter details by name
      final babysitterData =
          await searchService.fetchBabysitterByName(babysitterName);

      // Update the selected babysitter state
      setState(() {
        selectedBabysitter = babysitterData;
      });
    } catch (e) {
      print('Error fetching selected babysitter by name: $e');
    }
  }

  // Function to pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= 4) return; // Limit to 4 images

    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // upload images to supabase and get the urls
  Future<List<String>> uploadImages() async {
    List<String> uploadedUrls = [];

    if (_images.isEmpty) return uploadedUrls;

    for (var image in _images) {
      try {
        // Generate a unique file name for each image
        final fileName = DateTime.now().microsecondsSinceEpoch.toString();
        final path = 'feedbacks/$fileName.jpg'; // Assuming all files are .jpg

        // Upload the image to Supabase
        final response = await Supabase.instance.client.storage
            .from('images')
            .upload(path, image);

        // Get the public URL of the uploaded image
        final publicUrl =
            Supabase.instance.client.storage.from('images').getPublicUrl(path);

        if (response.isNotEmpty) {
          uploadedUrls.add(publicUrl);
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }

    return uploadedUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Babysitter'),
      ),
      body: (selectedBabysitter != null)
          ? Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: const AssetImage(defaultImage),
                        foregroundImage: AssetImage(selectedBabysitter!['img']),
                        radius: 70,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        selectedBabysitter!['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'How was your experience with me?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: primaryColor,
                                size: 40,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      const Text(
                        'Add Photo:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 8.0,
                        children: [
                          // Display selected images
                          ..._images.mapIndexed((index, image) => InkWell(
                                onTap: () {
                                  //choose between view or remove selected photo
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        customWidget.rateAndReviewbottomModal(
                                      const Icon(
                                        Icons.remove_red_eye,
                                        color: primaryColor,
                                      ),
                                      'View photo',
                                      () {
                                        Navigator.of(context).pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              customWidget.showImageDialog(
                                            context,
                                            image,
                                          ),
                                        );
                                      },
                                      const Icon(
                                        Icons.delete,
                                        color: dangerColor,
                                      ),
                                      'Remove photo',
                                      () {
                                        setState(() {
                                          _images.removeAt(index);
                                          Navigator.of(context).pop();
                                        });
                                      },
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                          // Add photo button
                          if (_images.length < 4)
                            InkWell(
                              onTap: () async {
                                //choose from camera or gallery
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      customWidget.rateAndReviewbottomModal(
                                    const Icon(
                                      Icons.camera_alt,
                                      color: primaryColor,
                                    ),
                                    'Take a photo',
                                    () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.camera);
                                    },
                                    const Icon(
                                      Icons.photo,
                                      color: primaryColor,
                                    ),
                                    'Choose from gallery',
                                    () {
                                      Navigator.of(context).pop();
                                      _pickImage(ImageSource.gallery);
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 2),
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add, color: Colors.grey),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _feedbackController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Please share any additional feedback.',
                        ),
                      ),
                      const SizedBox(height: 15),
                      AppButton(
                        onPressed: () {
                          //display confirmation modal
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) =>
                                customWidget.rateAndReviewAlertDialog(
                              'assets/images/confirm.gif',
                              'Are you sure to submit your review?',
                              [
                                customWidget.alertDialogBtn(
                                  const Text(
                                    'Cancel',
                                    style: TextStyle(color: textColor),
                                  ),
                                  backgroundColor,
                                  primaryColor,
                                  () {
                                    Navigator.pop(context);
                                  },
                                ),
                                customWidget.alertDialogBtn(
                                  (!isLoading)
                                      ? const Text(
                                          'Submit',
                                          style:
                                              TextStyle(color: backgroundColor),
                                        )
                                      : const CircularProgressIndicator(),
                                  primaryColor,
                                  primaryColor,
                                  () async {
                                    if (_rating != 0 || currentUser != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      print(currentUser?.name);
                                      print(_images);

                                      List<String> imageURL =
                                          await uploadImages();

                                      print(imageURL);

                                      // add feedback to selectedbabysitter
                                      await firestoreService.addFeedback(
                                        currentUserName: currentUser!.name,
                                        babysitterName:
                                            selectedBabysitter!['name'],
                                        feedbackMessage:
                                            _feedbackController.text,
                                        rating: _rating,
                                        imageURL_: imageURL,
                                      );

                                      _feedbackController.clear();
                                      setState(() {
                                        _rating = 0;
                                        _images = [];
                                      });
                                      setState(() {
                                        isLoading = false;
                                      });

                                      //display thankyou modal
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: customWidget.thankYouDialog(
                                              () {
                                                //pop until landing page
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomePage(),
                                                    ));

                                              },
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      Navigator.pop(context);
                                      //display empty rating modal
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            customWidget
                                                .rateAndReviewAlertDialog(
                                          'assets/images/error.gif',
                                          'Please input rating.',
                                          [
                                            customWidget.alertDialogBtn(
                                              const Text(
                                                'Close',
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              backgroundColor,
                                              primaryColor,
                                              () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        text: 'Submit',
                      )
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
