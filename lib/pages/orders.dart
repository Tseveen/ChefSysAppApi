import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Захиалгийн жагсаалт',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrderListPage(),
    );
  }
}

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<dynamic> orders = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/admin/orders'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        orders = jsonData['orders'];
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = 'Failed to load orders';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title:
            Text('Захиалгийн жагсаалт', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          'Order ID: ${order['id']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('Хоолны нэр: ${order['foodname']}'),
                            Text('Үнэ: \₮${order['price']}'),
                            Text('Тоо ширхэг: ${order['quantity']}'),
                            Text('Үйлчлүүлэгчийн нэр: ${order['name']}'),
                            Text('Утас: ${order['phone']}'),
                            Text('Хаяг: ${order['address']}'),
                            SizedBox(height: 5),
                            Text('Ordered At: ${order['created_at']}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
