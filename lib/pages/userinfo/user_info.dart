import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chefsysproject/reusables/reusables.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Хэрэглэгчийн мэдээлэл'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            SizedBox(height: 15),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Colors.blue,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/logo.png"),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          width: 4,
                          color: Colors.blue,
                        ),
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Implement changing profile picture
                        },
                        icon: Icon(Icons.add_a_photo),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            itemProfile(
              context,
              'Нэр',
              'Subtitle here',
              CupertinoIcons.person,
            ),
            SizedBox(height: 10),
            itemProfile(
              context,
              'Цахим хаяг',
              'Subtitle here',
              CupertinoIcons.mail,
            ),
            SizedBox(height: 10),
            reusableTextField(
              context,
              'Одоогийн нууц үг',
              Icons.password_outlined,
              true,
              currentPasswordController,
            ),
            SizedBox(height: 10),
            reusableTextField(
              context,
              'Нууц үг солих',
              Icons.password_outlined,
              true,
              newPasswordController,
            ),
            const SizedBox(height: 20),
            reusableTextField(
              context,
              'Нууц үг баталгаажуулах',
              Icons.password_outlined,
              true,
              confirmPasswordController,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget itemProfile(
    BuildContext context,
    String title,
    String subtitle,
    IconData iconData,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
      ),
    );
  }
}
