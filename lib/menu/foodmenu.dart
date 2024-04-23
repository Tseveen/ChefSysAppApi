import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class FoodMenuPage extends StatefulWidget {
  @override
  _FoodMenuPageState createState() => _FoodMenuPageState();
}

class _FoodMenuPageState extends State<FoodMenuPage> {
  late List<Food> _foods = [];

  @override
  void initState() {
    super.initState();
    _fetchFoodMenu();
  }

  Future<void> _fetchFoodMenu() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin/foodmenu'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        _foods = (jsonData['foods'] as List)
            .map((item) => Food.fromJson(item))
            .toList();
      });
    } else {
      throw Exception('Амжилттай');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Цэс', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final food = _foods[index];
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              leading: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                        'http://10.0.2.2:8000/foodimage/${food.image}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                food.title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\₮${food.price}',
                style: TextStyle(fontSize: 16.0),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color:
                        Colors.blue, // Set the color of the edit button to blue
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateFoodPage(food: food),
                        ),
                      ).then((_) => _fetchFoodMenu());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color:
                        Colors.red, // Set the color of the delete button to red
                    onPressed: () {
                      _confirmDeleteFood(context, food);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadFoodPage(),
            ),
          ).then((_) => _fetchFoodMenu());
        },
        backgroundColor: Colors.green, // Set the background color to green
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Adjust the location of the FloatingActionButton
    );
  }

  Future<void> _confirmDeleteFood(BuildContext context, Food food) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Цэс устгах"),
          content: Text("Энэ цэсийг устгахдаа итгэлтэй байна уу ?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Цуцлах",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Устгах",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFood(food.id);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteFood(int foodId) async {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/admin/deletemenu/$foodId'),
    );
    if (response.statusCode == 200) {
      _fetchFoodMenu();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Амжилттай'),
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
    } else {
      throw Exception('Амжилттай устгалаа');
    }
  }
}

class Food {
  final int id;
  final String title;
  final String image;
  final double price;

  Food({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      price: double.tryParse(json['price']) ?? 0.0,
    );
  }
}

class UpdateFoodPage extends StatefulWidget {
  final Food food;

  UpdateFoodPage({required this.food});

  @override
  _UpdateFoodPageState createState() => _UpdateFoodPageState();
}

class _UpdateFoodPageState extends State<UpdateFoodPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.food.title;
    _priceController.text = widget.food.price.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Цэс өөрчлөх', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePicker(),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Хоолны нэр',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Үнэ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateFood,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green)),
              child: Text('Өөрчлөх'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Зураг сонгох:',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            _getImage();
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.add_photo_alternate,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Зураг сонгогдсонгүй.');
      }
    });
  }

  Future<void> _updateFood() async {
    final String title = _titleController.text;
    final double price = double.parse(_priceController.text);

    final uri =
        Uri.parse('http://10.0.2.2:8000/api/admin/update/${widget.food.id}');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['price'] = price.toString();

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Navigator.pop(context); // Navigate back to previous screen
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Амжилттай'),
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
      } else {
        throw Exception('Амжилттай өөрчиллөө');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('$e'),
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
  }
}

class UploadFoodPage extends StatefulWidget {
  @override
  _UploadFoodPageState createState() => _UploadFoodPageState();
}

class _UploadFoodPageState extends State<UploadFoodPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Цэс нэмэх', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              SizedBox(height: 16.0),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Хоолны нэр',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Үнэ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadFood,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green)),
                child: Text('Цэс нэмэх'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Зураг оруулах:',
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(height: 8.0),
        GestureDetector(
          onTap: () {
            _getImage();
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _image != null
                ? Image.file(
                    _image!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.add_photo_alternate,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('Зураг сонгогдсонгүй');
      }
    });
  }

  Future<void> _uploadFood() async {
    final String title = _titleController.text;
    final double price = double.parse(_priceController.text);

    final uri = Uri.parse('http://10.0.2.2:8000/api/admin/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['title'] = title
      ..fields['price'] = price.toString();

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Navigator.pop(context); // Navigate back to previous screen
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Амжилттай'),
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
      } else {
        throw Exception('Амжилттай орууллаа');
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('$e'),
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
  }
}

void main() {
  runApp(MaterialApp(
    home: FoodMenuPage(),
  ));
}
