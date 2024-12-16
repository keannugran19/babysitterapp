import 'package:babysitterapp/controller/messages.dart';
import 'package:babysitterapp/pages/profile/babysitterprofilepage.dart';
import 'package:babysitterapp/services/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import '../../controller/userdata.dart';
import '../../models/user_model.dart';
import '../../services/babysitter_service.dart';
import '../../services/current_user_service.dart';
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
  final CurrentUserService firestoreService = CurrentUserService();
  final BabysitterService babysitterService = BabysitterService();
  final ChatService chatService = ChatService();
  late UserModel? currentUser;
  late UserModel? recipient;
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
    currentUser = await firestoreService.loadUserData();
    recipient =
        await babysitterService.getBabysitterByEmail(widget.recipientID);
    messageList =
        await chatService.getMessages(widget.currentUserID, widget.recipientID);
    setState(() {});
  }

  //fetch messages
  Widget fetchMessage() {
    messageList.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return ListView(
      controller: scrollController,
      children: messageList.map((messages) {
        bool isUser = currentUser!.email == messages.id;

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
      id: currentUser!.email,
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
    await chatService.addMessageToFirestore(
      widget.currentUserID,
      widget.recipientID,
      newMessage,
    );

    // Add the message to recipient message collection
    await chatService.addMessageToFirestore(
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
                    babysitterID: recipient!.email,
                    currentUserID: widget.currentUserID,
                  ),
                )),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: const AssetImage(defaultImage),
                      foregroundImage:
                          AssetImage(recipient!.img ?? defaultImage),
                    ),
                    const SizedBox(width: 10),
                    Text(recipient!.name),
                  ],
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
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
