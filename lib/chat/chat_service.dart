import 'package:chefsysproject/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  //hereglegch bolon firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  //Chat ilgeeh
  Future<void> sendMessage(String receiverId, String message) async {
    //nevtersen hereglegchiin medeelliig haruulah
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //shine message bichih
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message);
    //chat room uusgene
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); //id sort hiine
    String chatRoomId = ids.join("_"); //id-g single string bolgoj hosluulna
    //message database uusgeh
    await _firebase
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //message huleen avah
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //hereglegchiin id-d chat room uusgeh
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebase
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
