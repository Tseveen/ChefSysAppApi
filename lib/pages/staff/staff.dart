import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chefsysproject/pages/staff/staffdetailscreen.dart';

class StaffsScreen extends StatefulWidget {
  const StaffsScreen({Key? key}) : super(key: key);

  @override
  State<StaffsScreen> createState() => _StaffsScreenState();
}

class _StaffsScreenState extends State<StaffsScreen> {
  void _showDeleteConfirmationDialog(String staffId, String? userEmail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.lightBlue,
          title: Text('Устгах'),
          content: Text('Та энэ ажилтныг устгахдаа итгэлтэй байна уу?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Үгүй'),
            ),
            TextButton(
              onPressed: () {
                if (isValidStaffId(staffId) && isValidUserEmail(userEmail)) {
                  print(
                      'Deleting staff with ID: $staffId and user email: $userEmail');
                  _deleteStaffMember(staffId);
                } else {
                  // Handle the case where staffId or userEmail is invalid or null
                  print('Invalid staff ID: $staffId or user email: $userEmail');
                }
                Navigator.of(context).pop();
              },
              child: Text('Устгах'),
            ),
          ],
        );
      },
    );
  }

  bool isValidStaffId(String staffId) {
    return staffId.isNotEmpty;
  }

  bool isValidUserEmail(String? userEmail) {
    return userEmail != null && userEmail.isNotEmpty;
  }

  void _deleteStaffMember(String staffId) async {
    try {
      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection('staffs')
          .doc(staffId)
          .delete();
      print('Firestore: Амжилттай устгалаа');

      // Get the user email from Firestore
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('staffs')
          .doc(staffId)
          .get();
      String? userEmail = documentSnapshot.get('email');

      // Delete Authentication user using the obtained email and a dummy password
      if (userEmail != null) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: userEmail,
          password: 'some_dummy_password', // Provide a dummy password
        )
            .then((userCredential) {
          User? firebaseUser = userCredential.user;
          return firebaseUser?.delete();
        });
        print('Authentication: Амжилттай устгалаа');
      } else {
        print('Firestore: User email is null for staff ID: $staffId');
      }
    } catch (e) {
      print('Устгахад алдаа гарлаа: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ажилчид'),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('staffs').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('Мэдээлэл алга'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic>? data =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>?;

                if (data != null) {
                  final String staffId = snapshot.data!.docs[index].id;
                  final String? userEmail = data['email'];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text('${data['firstName']} ${data['lastName']}'),
                        subtitle: Text('Утасны дугаар: ${data['phone']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaffDetailsScreen(
                                      staffData: data,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    staffId, userEmail);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
