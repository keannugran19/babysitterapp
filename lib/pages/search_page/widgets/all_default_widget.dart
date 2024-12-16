import 'package:babysitterapp/pages/profile/babysitterprofilepage.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import '../../../services/babysitter_service.dart';
import '../../../services/current_user_service.dart';
import '../../homepage/babysitter_card.dart';

class AllDefaultWidget extends StatefulWidget {
  const AllDefaultWidget({super.key});

  @override
  State<AllDefaultWidget> createState() => _AllDefaultWidgetState();
}

class _AllDefaultWidgetState extends State<AllDefaultWidget> {
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  final BabysitterService babysitterService = BabysitterService();
  // get data from firestore using the model
  UserModel? currentUser;
  // store babysitter list data
  List<UserModel> _babysitters = [];

  // load user data
  Future<void> loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // load babysitter data
  Future<void> loadBabysitters() async {
    final babysitters = await babysitterService.getBabysitters();
    setState(() {
      _babysitters = babysitters;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    loadUserData();
    loadBabysitters();
  }

  Widget _buildBabysitterSection(
      BuildContext context, List<UserModel> babysitters) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: babysitters.length,
        itemBuilder: (context, index) {
          final babysitter = babysitters[index];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BabysitterProfilePage(
                    babysitterID: babysitter.email,
                    currentUserID: currentUser!.email,
                  ),
                ),
              );
            },
            child: BabysitterCard(
              name: babysitter.name,
              rate: babysitter.rate!,
              rating: babysitter.rating!,
              gender: babysitter.gender!,
              birthdate: babysitter.age!,
              profileImage: babysitter.img ?? 'default_image_url',

              // TODO: implementation of favorite babysitter
              // heartIcon: IconButton(
              //   icon: Icon(
              //     Icons.favorite,
              //     color: babysitter.experience?.isNotEmpty == true
              //         (remove this)? Colors.red
              //         : Colors.grey,
              //   ),
              //   onPressed: () => _toggleLike(index),
              // ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBabysitterSection(context, _babysitters);
  }
}
