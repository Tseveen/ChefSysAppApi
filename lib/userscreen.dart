import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<dynamic> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _loggedInUserId = 123; // Placeholder for logged-in user ID

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final uri = Uri.parse('http://10.0.2.2:8000/api/admin/users');
    try {
      final response = await http.get(uri, headers: <String, String>{
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // Filter out the logged-in user
        _users = jsonData['users']
            .where(
                (user) => user['id'].toString() != _loggedInUserId.toString())
            .toList();
        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Хэрэглэгч ачааллахад алдаа гарлаа');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text('Хэрэглэгчид', style: TextStyle(color: Colors.white)),
        actions: [],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(_errorMessage),
                )
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(user['profile_photo_url']),
                        ),
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(user['id']);
                              },
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDeleteConfirmationDialog(int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Хэрэглэгч устгах'),
          content: Text('Энэ хэрэглэгчийг устгахдаа итгэлтэй байна уу ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Цуцлах'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteUser(userId);
                Navigator.of(context).pop();
              },
              child: Text('Устгах'),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(int userId) async {
    final uri = Uri.parse('http://10.0.2.2:8000/api/admin/user/$userId');
    try {
      final response = await http.delete(uri, headers: <String, String>{
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        _fetchUsers();
      } else {
        throw Exception('Амжилттай устгалаа');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }
}
