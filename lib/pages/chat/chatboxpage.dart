import 'package:babysitterapp/controller/messages.dart';
import 'package:babysitterapp/pages/profile/babysitterprofilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../../controller/user.dart';
import '../../controller/userdata.dart';
import '../../services/firestore.dart';
import '../../views/customwidget.dart';

class ChatBoxPage extends StatefulWidget {
  final String recipientID;
  final String currentUserID;
  const ChatBoxPage({
    super.key,
    required this.recipientID,
    required this.currentUserID,
  });

  @override
  State<ChatBoxPage> createState() => _ChatBoxPageState();
}

class _ChatBoxPageState extends State<ChatBoxPage> {
  FirestoreService firestoreService = FirestoreService();
  late User? currentUser;
  late User? recipient;
  final UserData userData = UserData();
  final CustomWidget customWidget = CustomWidget();

  //fetch current user data
  late List<Messages> messageList;
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late String selectedOffer;

  @override
  void initState() {
    super.initState();
    currentUser = null;
    recipient = null;
    messageList = [
      Messages(id: '', msg: '', timestamp: DateTime(0, 0, 0), isClicked: false)
    ];
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    selectedOffer = userData.offerList.first;
  }

//fetch data based on id
  Future<void> fetchData() async {
    currentUser = await firestoreService.getUserData(widget.currentUserID);
    recipient = await firestoreService.getUserData(widget.recipientID);
    messageList = await firestoreService.getMessages(
        widget.currentUserID, widget.recipientID);
    setState(() {});
  }

  //fetch messages
  Widget fetchMessage() {
    messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return ListView(
      controller: scrollController,
      children: messageList.map((messages) {
        bool isUser = currentUser!.id == messages.id;

        onTap() {
          setState(() {
            //check if the message is clicked
            messages.isClicked = !messages.isClicked;
          });
        }

        return Column(
          children: [
            customWidget.messageLine(
                isUser, messages, currentUser, recipient, onTap),
          ],
        );
      }).toList(),
    );
  }

  //store current user new message
  addMessage(String message) async {
    Messages newMessage = Messages(
      id: currentUser!.id,
      msg: message,
      timestamp: DateTime.now(),
      isClicked: false,
    );
    setState(() {
      messageList.add(newMessage);
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    // Add the message to current user message collection
    await firestoreService.addMessageToFirestore(
      widget.currentUserID,
      widget.recipientID,
      newMessage,
    );

    // Add the message to recipient message collection
    await firestoreService.addMessageToFirestore(
      widget.recipientID,
      widget.currentUserID,
      newMessage,
    );
  }

  //scroll to most recent message
  scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (recipient != null || currentUser != null)
        ? Scaffold(
            appBar: AppBar(
              title: InkWell(
                onTap:
                    () => // Navigate to the chat box of the clicked babysitter
                        Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BabysitterProfilePage(
                    babysitterID: recipient!.id,
                    currentUserID: widget.currentUserID,
                  ),
                )),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(recipient!.img),
                    ),
                    const SizedBox(width: 10),
                    Text(recipient!.name),
                  ],
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    recipient!.isClicked = false;
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Expanded(child: fetchMessage()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    //message field
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: 'Message',
                        suffixIcon: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  //send offer function
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return OfferModal(
                                            iconOnPressed: () {
                                              setState(() {
                                                selectedOffer =
                                                    userData.offerList.first;
                                              });
                                              Navigator.pop(context);
                                            },
                                            children:
                                                userData.offerList.map((offer) {
                                              return RadioListTile<String>(
                                                title: Text('PHP $offer/hr'),
                                                value: offer,
                                                groupValue: selectedOffer,
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    selectedOffer = value!;
                                                  });
                                                },
                                              );
                                            }).toList(),
                                            buttonOnPressed: () {
                                              addMessage(
                                                  'Offer: PHP $selectedOffer/hr');
                                              setState(() {
                                                selectedOffer =
                                                    userData.offerList.first;
                                              });
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.local_offer),
                              ),
                              IconButton(
                                onPressed: () {
                                  //add message function
                                  if (messageController.text.isNotEmpty) {
                                    addMessage(messageController.text);
                                  }
                                  messageController.clear();
                                },
                                icon:
                                    const Icon(CupertinoIcons.paperplane_fill),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
