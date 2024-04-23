import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Reservation {
  final String date;
  final String time;
  final String name;
  final String number;
  final int guest;

  Reservation({
    required this.date,
    required this.time,
    required this.name,
    required this.number,
    required this.guest,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      name: json['name'] ?? '',
      number: json['number'] ?? '',
      guest: json['guest'] != null ? int.parse(json['guest'].toString()) : 0,
    );
  }
}

class ReservationListPage extends StatefulWidget {
  @override
  _ReservationListPageState createState() => _ReservationListPageState();
}

class _ReservationListPageState extends State<ReservationListPage> {
  Future<List<Reservation>> fetchReservations() async {
    final url = Uri.parse('http://10.0.2.2:8000/admin/viewreservation');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final List<dynamic>? reservationList = responseData['reservations'];
      if (reservationList != null) {
        return reservationList
            .map((data) => Reservation.fromJson(data))
            .toList();
      } else {
        throw Exception('No reservations found');
      }
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 10, 68, 216),
        title: Text(
          'Цаг авсан жагсаалт',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: fetchReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final reservations = snapshot.data ?? [];
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      reservation.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text('Огноо: ${reservation.date}'),
                        Text('Цаг: ${reservation.time}'),
                        SizedBox(height: 4),
                        Text(
                          'Хүний тоо: ${reservation.guest}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Дугаар: ${reservation.number}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ReservationListPage(),
  ));
}
