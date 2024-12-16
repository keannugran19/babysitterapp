import 'package:babysitterapp/authentication/terms_page.dart';
import 'package:babysitterapp/pages/account/account_page.dart';
import 'package:babysitterapp/pages/available/available_page.dart';
import 'package:babysitterapp/pages/help_and_support/help_and_support_page.dart';
import 'package:babysitterapp/pages/transaction/transaction_history_page.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/current_user_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // call firestore service
  CurrentUserService firestoreService = CurrentUserService();
  // get data from firestore using the model
  UserModel? currentUser;

  // load user data
  Future<void> _loadUserData() async {
    final user = await firestoreService.loadUserData();
    setState(() {
      currentUser = user;
    });
  }

  // initiate load
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 20, top: 10),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: currentUser!.img! != ""
                                    ? AssetImage(currentUser!.img!)
                                    : const AssetImage(
                                        'assets/images/default_user.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // display current user name, email and role
                            Text(currentUser!.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(
                              currentUser!.email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              currentUser!.role.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SettingsSection(
                    title: 'GENERAL',
                    items: [
                      SettingsItem(
                          icon: Icons.account_box,
                          label: 'View Profile',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const AccountPage()));
                          }),
                      SettingsItem(
                          icon: Icons.receipt_long,
                          label: 'Transaction History',
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionHistoryPage()));
                          }),

                      // settings item specifically for babysitters
                      currentUser != null &&
                              currentUser?.role.toLowerCase() != 'parent'
                          ? SettingsItem(
                              icon: Icons.event_available,
                              label: 'Availability',
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const AvailabilityPage()));
                              })
                          : Container()
                    ],
                  ),
                  SettingsSection(
                    title: 'SUPPORT & TERMS',
                    items: [
                      SettingsItem(
                        icon: Icons.devices,
                        label: 'Help and Support',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const HelpAndSupportPage()));
                        },
                      ),
                      SettingsItem(
                        icon: Icons.privacy_tip,
                        label: 'Terms and Conditions/Privacy Policy',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionPage()));
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Account',
                    items: [
                      // log out user
                      SettingsItem(
                        label: 'Log Out',
                        icon: Icons.logout,
                        onTap: () async {
                          bool? confirmLogout = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Log Out"),
                                content: const Text(
                                    "Are you sure you want to log out?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          false); // User canceled the logout
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(
                                          true); // User confirmed the logout
                                    },
                                    child: const Text("Log Out"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmLogout == true) {
                            await firestoreService.signOutUser();
                            Navigator.of(context).pushNamed("/login");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingsItem(
      {super.key,
      required this.icon,
      required this.label,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(label),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

class SettingsSwitchItem extends StatelessWidget {
  final String label;

  const SettingsSwitchItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: Switch(
        value: true,
        onChanged: (value) {},
        activeColor: Colors.purple,
      ),
    );
  }
}
