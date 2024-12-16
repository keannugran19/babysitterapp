import 'package:babysitterapp/services/firestore.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../controller/user.dart';
import '/controller/userdata.dart';
import 'chatboxpage.dart';

class ChatPage extends StatefulWidget {
  final String currentUserID;
  const ChatPage({super.key, required this.currentUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FirestoreService firestoreService = FirestoreService();
  late List? chatList;
  UserData userData = UserData();
  late bool isLongPressed;
  List<String> selectedBabysitterId = [];

  @override
  void initState() {
    super.initState();
    isLongPressed = false;
    chatList = null;
    fetchChatList();
  }

  //fetch chat list of the current user
  Future<void> fetchChatList() async {
    chatList = await firestoreService.getChatListID(widget.currentUserID);
    setState(() {});
  }

  // Helper function to fetch each recipient’s data
  Future<List<Widget>> _fetchRecipients() async {
    List<Widget> recipientWidgets = [];

    for (String recipientID in chatList!) {
      // Fetch recipient data
      var recipient = await FirestoreService().getUserData(recipientID);

      // Add a widget to the list for each recipient
      if (recipient != null) recipientWidgets.add(babysitterList(recipient));
    }

    return recipientWidgets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  //list item of chat of the current user
  Widget babysitterList(User recipient) => InkWell(
        onTap: () {
          if (isLongPressed) {
            setState(() {
              //Add or remove babysitter id to the selected list
              if (selectedBabysitterId.contains(recipient.id)) {
                selectedBabysitterId.remove(recipient.id);
              } else {
                selectedBabysitterId.add(recipient.id);
              }
            });
          } else {
            // Navigate to the chat box of the clicked babysitter
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatBoxPage(
                recipientID: recipient.id,
                currentUserID: widget.currentUserID,
              ),
            ));
          }
        },
        onLongPress: () {
          setState(() {
            //Add babysitter id to the selected list
            selectedBabysitterId.add(recipient.id);
            isLongPressed = true;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          height: 60,
          child: Row(
            children: [
              //if longpressed is true diplay the checkbox
              if (isLongPressed)
                Checkbox(
                  value: selectedBabysitterId.contains(recipient.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        //Add babysitter id to the selected list
                        selectedBabysitterId.add(recipient.id);
                      } else {
                        //Remove babysitter id to the selected list
                        selectedBabysitterId.remove(recipient.id);
                      }
                    });
                  },
                ),
              CircleAvatar(
                radius: 30,
                backgroundImage: recipient.img != ""
                    ? AssetImage(recipient.img)
                    : const AssetImage('assets/images/default_user.png'),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(recipient.email),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Change Appbar content based on isLongPressed value
      appBar: (isLongPressed)
          ? AppBar(
              title: Text('${selectedBabysitterId.length} Selected'),
              //cancel button
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    isLongPressed = false;
                    selectedBabysitterId = [];
                  });
                },
                icon: const Icon(CupertinoIcons.clear),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      //delete function
                      print(selectedBabysitterId);
                      isLongPressed = false;
                      selectedBabysitterId = [];
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            )
          : AppBar(
              title: const Text('Messages'),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      isLongPressed = true;
                    });
                  },
                  child: const Text(
                    'Select',
                    style: TextStyle(color: primaryFgColor),
                  ),
                ),
              ],
            ),
      body: (chatList != null)
          ? FutureBuilder<List<Widget>>(
              future: _fetchRecipients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No recipients found.'));
                }

                // Display the list of recipients as widgets
                return ListView(
                  children: snapshot.data!,
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
