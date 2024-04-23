import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemsWidget extends StatefulWidget {
  @override
  _ItemsWidgetState createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  List<dynamic> menuItems = [];

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin/foodmenu'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);
      if (responseData.containsKey('foods')) {
        setState(() {
          menuItems = responseData['foods'];
        });
      } else {
        throw Exception('Invalid response format: Missing "foods" key');
      }
    } else {
      throw Exception('Failed to load menu items');
    }
  }

  Future<void> deleteMenuItem(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/admin/deletemenu/$id'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        // Refresh menu items after deletion
        fetchMenuItems();
        // Show a success Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu item deleted successfully'),
            duration: Duration(seconds: 2), // Adjust duration as needed
          ),
        );
      } else {
        throw Exception('Failed to delete menu item');
      }
    } catch (e) {
      print('$e');
      // Show an error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Амжилттай устгалаа.'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 0.75,
      children: [
        for (var item in menuItems)
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    // Handle tap on menu item
                  },
                  child: Container(
                    margin: EdgeInsets.all(20),
                    child: Image.network(
                      'http://10.0.2.2:8000/storage/${item['image']}',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item['price']}₮',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Implement update functionality
                        },
                        child: Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 0, 255, 47),
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteMenuItem(item['id']);
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: ItemsWidget(),
      ),
    );
  }
}
