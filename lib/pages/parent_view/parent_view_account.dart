import 'package:flutter/material.dart';
import 'babysitter.dart'; // Import the Babysitter model

class ParentViewPage extends StatelessWidget {
  // Sample list of babysitters
  final List<Babysitter> babysitters = [
    Babysitter(name: "Jane Doe", profileImage: null, isVerified: true),
    Babysitter(name: "John Smith", profileImage: null, isVerified: false),
    Babysitter(name: "Alice Johnson", profileImage: null, isVerified: true),
  ];

  ParentViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Available Babysitters',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: babysitters.length,
        itemBuilder: (context, index) {
          final babysitter = babysitters[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: babysitter.profileImage != null
                  ? NetworkImage(babysitter.profileImage!)
                  : const AssetImage('assets/images/default_user.png')
                      as ImageProvider,
            ),
            title: Text(
              babysitter.name,
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            subtitle: Text(babysitter.isVerified ? 'Verified' : 'Not Verified'),
            trailing: Icon(
              Icons.check_circle,
              color: babysitter.isVerified ? Colors.green : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
