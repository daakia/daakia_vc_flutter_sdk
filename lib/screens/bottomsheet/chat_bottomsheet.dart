import 'package:daakia_vc_flutter_sdk/screens/customWidget/message_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBottomSheet extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }

}

class _ChatState extends State<ChatBottomSheet>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Use a specific color for no_video_background
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            // Toolbar
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // RecyclerView (use ListView in Flutter)
            Expanded(
              child: ListView.builder(
                itemCount: 20, // Placeholder item count
                itemBuilder: (context, index) {
                  return MessageBubble(userName: "Ashif", message: "hey how are you", time: "10:45 pm", isSender: (index%2 == 0));
                },
              ),
            ),

            // Message Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type here...",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    onPressed: () {
                      // Add send action here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}