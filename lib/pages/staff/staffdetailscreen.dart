import 'package:flutter/material.dart';

class StaffDetailsScreen extends StatefulWidget {
  final Map<String, dynamic>? staffData;

  const StaffDetailsScreen({Key? key, required this.staffData})
      : super(key: key);

  @override
  _StaffDetailsScreenState createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTextController.text = widget.staffData?['name'] ?? '';
    _emailTextController.text = widget.staffData?['email'] ?? '';
  }

  void _updateData() {
    // Implement your update logic here
    // This function should replace the Firebase functionality.
    // You can update data to a local database or any other data source.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ажилчдийн мэдээлэл засах'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameTextController,
                decoration: InputDecoration(labelText: 'Нэр'),
                onChanged: (value) {
                  _nameTextController.text = value;
                },
              ),
              TextField(
                controller: _emailTextController,
                decoration: InputDecoration(labelText: 'Цахим хаяг'),
                onChanged: (value) {
                  _emailTextController.text = value;
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _updateData,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Хадгалах'),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
