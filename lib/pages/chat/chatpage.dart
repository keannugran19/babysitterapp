import 'package:babysitterapp/models/user_model.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:babysitterapp/styles/colors.dart';
import 'package:babysitterapp/views/customwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/babysitter_service.dart';
import '/controller/userdata.dart';
import 'chatboxpage.dart';

class ChatPage extends StatefulWidget {
  final String currentUserID;
  const ChatPage({super.key, required this.currentUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService chatService = ChatService();
  final BabysitterService babysitterService = BabysitterService();
  final CustomWidget customWidget = CustomWidget();
  late List? chatList;
  final UserData userData = UserData();
  bool isLongPressed = false;
  List<String> selectedBabysitterId = [];

  @override
  void initState() {
    super.initState();
    chatList = null;
    fetchChatList();
  }

  //fetch chat list of the current user
  Future<void> fetchChatList() async {
    chatList = await chatService.getChatListID(widget.currentUserID);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    chatList!.clear();
  }

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
                    //delete function
                    if (selectedBabysitterId.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete'),
                          content: const Text(
                              'Are you sure you want to delete this conversation?'),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
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
                                  const Text(
                                    'Delete',
                                    style: TextStyle(color: backgroundColor),
                                  ),
                                  dangerColor,
                                  dangerColor,
                                  () async {
                                    for (String babysitterId
                                        in selectedBabysitterId) {
                                      await chatService.deleteChat(
                                          widget.currentUserID, babysitterId);
                                    }
                                    setState(() {
                                      fetchChatList();
                                      isLongPressed = false;
                                      selectedBabysitterId = [];
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        fetchChatList();
                        isLongPressed = false;
                        selectedBabysitterId = [];
                      });
                    }
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
          ? ListView(
              children: chatList!.map((l) {
                return FutureBuilder(
                  future: babysitterService.getBabysitterByEmail(l),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading data.'),
                      );
                    } else if (snapshot.hasData) {
                      UserModel recipientData = snapshot.data!;
                      return Card(
                        child: ListTile(
                          leading: (!isLongPressed)
                              ? CircleAvatar(
                                  backgroundImage:
                                      const AssetImage(defaultImage),
                                  foregroundImage: AssetImage(
                                      recipientData.img ?? defaultImage),
                                  radius: 30,
                                )
                              : //if longpressed is true diplay the checkbox

                              Checkbox(
                                  value: selectedBabysitterId
                                      .contains(recipientData.email),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        //Add babysitter id to the selected list
                                        selectedBabysitterId
                                            .add(recipientData.email);
                                      } else {
                                        //Remove babysitter id to the selected list
                                        selectedBabysitterId
                                            .remove(recipientData.email);
                                      }
                                    });
                                  },
                                ),
                          title: Text(
                            recipientData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            recipientData.email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          trailing: const Icon(CupertinoIcons.chevron_right),
                          onTap: () {
                            if (isLongPressed) {
                              setState(() {
                                //Add or remove babysitter id to the selected list
                                if (selectedBabysitterId
                                    .contains(recipientData.email)) {
                                  selectedBabysitterId
                                      .remove(recipientData.email);
                                } else {
                                  selectedBabysitterId.add(recipientData.email);
                                }
                              });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatBoxPage(
                                          recipientID: recipientData.email,
                                          currentUserID:
                                              widget.currentUserID)));
                            }
                          },
                          onLongPress: () {
                            setState(() {
                              //Add babysitter id to the selected list
                              selectedBabysitterId.add(recipientData.email);
                              isLongPressed = true;
                            });
                          },
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No messages yet'),
                      );
                    }
                  },
                );
              }).toList(),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
