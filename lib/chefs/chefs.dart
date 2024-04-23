import 'dart:convert';
import 'package:chefsysproject/chefs/addchef.dart';
import 'package:chefsysproject/chefs/chefupdate.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chefsdetail.dart'; // Assuming ChefDetailScreen is in chef detail file

class ChefsPage extends StatefulWidget {
  @override
  _ChefsPageState createState() => _ChefsPageState();
}

class _ChefsPageState extends State<ChefsPage> {
  List<dynamic> chefs = [];
  bool isLoading = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchChefs();
  }

  Future<void> fetchChefs() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/admin/viewchef'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          chefs = json.decode(response.body)['chefs'];
        });
      } else {
        setState(() {
          error = 'Failed to load chefs';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteChef(int chefId, int index) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8000/api/admin/deletechef/$chefId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          chefs.removeAt(index);
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _deleteChefConfirmation(int chefId, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Энэ ажилтныг устгах уу ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Үгүй',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteChef(chefId, index); // Proceed with deletion
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Устгах',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Тогоочид', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error.isNotEmpty
              ? Center(child: Text(error))
              : ListView.builder(
                  itemCount: chefs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'http://10.0.2.2:8000/chefimage/${chefs[index]['image']}',
                          ),
                        ),
                        title: Text(
                          chefs[index]['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(chefs[index]['speciality']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChefDetailScreen(chef: chefs[index]),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors
                                  .blue, // Set the color of the edit button to blue
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditChef(chefId: chefs[index]['id']),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors
                                  .red, // Set the color of the delete button to red
                              onPressed: () {
                                _deleteChefConfirmation(
                                    chefs[index]['id'], index);
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
          // Add your action here
          // For example, navigate to another screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddChefScreen(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
