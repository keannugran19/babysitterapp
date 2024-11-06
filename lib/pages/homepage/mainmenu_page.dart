import 'package:flutter/material.dart';

class MainmenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile', style: Theme.of(context).textTheme.bodyLarge),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('User1'),
              accountEmail: const Text('Parent / Babysitter'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/female1.jpg'),
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
            ),
            ListTile(
              leading: Icon(Icons.home,
                  color: Theme.of(context).colorScheme.primary),
              title: Text('Homepage',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: Theme.of(context).colorScheme.primary),
              title: Text('Notification',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.schedule,
                  color: Theme.of(context).colorScheme.primary),
              title: Text('Schedules',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Theme.of(context).colorScheme.primary),
              title: Text('Settings',
                  style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help,
                  color: Theme.of(context).colorScheme.primary),
              title:
                  Text('Help', style: Theme.of(context).textTheme.bodyMedium),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title:
                  Text('Logout Account', style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
          child: Text('Profile Content Here',
              style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
