import 'package:flutter/material.dart';
import 'package:chefsysproject/menu/foodmenu.dart';
import 'package:chefsysproject/chefs/chefs.dart';
import 'package:chefsysproject/pages/login.dart';
import 'package:chefsysproject/pages/orders.dart';
import 'package:chefsysproject/reservation.dart';
import 'package:chefsysproject/userscreen.dart';
import 'package:chefsysproject/pages/userinfo/user_info.dart';
import 'package:http/http.dart' as http;

class UIParameters {
  static const double cardBorderRadius = 40.0;
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "Tseveen"; // Placeholder for name variable

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Та гарахдаа итгэлтэй байна уу ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Цуцлах',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // Call the logout function
                await _performLogout();
              },
              child: Text(
                'Гарах',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/logout'),
        // Add any required headers here
      );

      if (response.statusCode == 200) {
        // Logout successful, navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        // Handle errors
      }
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: WillPopScope(
        onWillPop: () async {
          // Prevent app from quitting when back button is pressed
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 10, 68, 216),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 65),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Сайн уу! $name", // Used placeholder name
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserInfoScreen(),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage("assets/logo.png"),
                                ),
                              ),
                              IconButton(
                                onPressed: _logout,
                                icon: Icon(Icons.logout),
                                style: ButtonStyle(
                                    iconColor: MaterialStateProperty.all<Color>(
                                        Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20), // Add padding around the GridView
                child: GridView(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5, // Adjust aspect ratio as needed
                  ),
                  children: [
                    _buildAnimatedContainer(
                      context,
                      'Хэрэглэгчид',
                      'assets/employees.png',
                      UserListPage(),
                    ),
                    _buildAnimatedContainer(
                      context,
                      'Цэс',
                      'assets/menu.png',
                      FoodMenuPage(),
                    ),
                    _buildAnimatedContainer(
                      context,
                      'Тогоочид',
                      'assets/chef.png',
                      ChefsPage(),
                    ),
                    _buildAnimatedContainer(
                      context,
                      'Цаг авсан',
                      'assets/time.png',
                      ReservationListPage(),
                    ),
                    _buildAnimatedContainer(
                      context,
                      'Захиалга',
                      'assets/tax.png',
                      OrderListPage(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(
    BuildContext context,
    String label,
    String imagePath,
    Widget destination,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(UIParameters.cardBorderRadius),
          color: Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 2.0,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 243, 222, 222).withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 80,
                height: 80,
              ),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
