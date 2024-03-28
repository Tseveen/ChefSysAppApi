import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;

  // Fixing the constructor
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green,
      ),
      child: Text(
        widget.message, // Accessing the message through widget
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
