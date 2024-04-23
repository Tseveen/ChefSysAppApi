import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditChef extends StatefulWidget {
  final int chefId;

  EditChef({required this.chefId});

  @override
  _EditChefState createState() => _EditChefState();
}

class _EditChefState extends State<EditChef> {
  TextEditingController nameController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Мэдээлэл засах', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Нэр',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: specialityController,
              decoration: InputDecoration(
                labelText: 'Ажлын зэрэг',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _image != null
                ? Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(_image!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    _selectImage();
                  },
                  icon: Icon(Icons.add_photo_alternate),
                  iconSize: 50,
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _image = null;
                    });
                  },
                  icon: Icon(Icons.delete),
                  iconSize: 50,
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _updateChefDetails(widget.chefId);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                child: Text('Хадгалах'),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _updateChefDetails(int chefId) async {
    final String name = nameController.text;
    final String speciality = specialityController.text;

    final Uri uri =
        Uri.parse('http://10.0.2.2:8000/api/admin/updatefoodchef/$chefId');
    try {
      final request = http.MultipartRequest('POST', uri);
      request.fields['name'] = name;
      request.fields['speciality'] = speciality;

      if (_image != null) {
        request.files.add(http.MultipartFile(
          'image',
          _image!.readAsBytes().asStream(),
          _image!.lengthSync(),
          filename: _image!.path.split('/').last,
        ));
      }

      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Successfully updated
        Navigator.pop(context); // Navigate back to previous screen
      } else {
        // Handle error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('Амжилттай'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
