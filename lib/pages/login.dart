import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chefsysproject/pages/forgetpassword.dart';
import 'package:chefsysproject/pages/signup.dart';
import 'package:chefsysproject/reusables/reusables.dart';
import 'home.dart';

void main() {
  runApp(Login());
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  height: 150,
                ),
              ),
              Text(
                'ChefSys',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontFamily: 'Indie',
                  fontSize: 80.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10), // Add vertical spacing

              reusableTextField(context, "Цахим хаяг", Icons.email, false,
                  _emailTextController),
              const SizedBox(
                height: 10.0,
              ),
              reusableTextField(context, "Нууц үг", Icons.password_outlined,
                  true, _passwordTextController),

              const SizedBox(
                height: 10,
              ),
              //nuuts ug martsan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ForgetPasswordPage();
                        }));
                      },
                      child: Text(
                        " Нууц үгээ мартсан уу ?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _login, // Call login function
                child: Text('Нэвтрэх'),
              ),
              burtguuleh(),

              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle the login button press
  void _login() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Send a POST request to your Laravel backend with email and password
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailTextController.text,
          'password': _passwordTextController.text,
        }),
      );

      // Check if request was successful (status code 200)
      if (response.statusCode == 200) {
        // If login successful, parse the response JSON and navigate to home screen
        jsonDecode(response.body);
        // Assuming your backend returns a token upon successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        // If login fails, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Нэвтрэх нэр болон нууц үг буруу байна.")),
        );
      }
    } catch (error) {
      print(error);
      // If an error occurs, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Алдаа гарлаа дахин оролдоно уу.")),
      );
    }
  }

  Padding burtguuleh() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Шинээр бүртгүүлэх үү?",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignUp()));
            },
            child: Text(
              " Бүртгүүлэх",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
