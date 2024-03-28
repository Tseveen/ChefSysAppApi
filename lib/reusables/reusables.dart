import 'package:flutter/material.dart';

TextField reusableTextField(BuildContext context, String text, IconData icon,
    bool isPasswordType, TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Theme.of(context).colorScheme.tertiary,
    style: TextStyle(
      color: Theme.of(context).colorScheme.tertiary,
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      labelText: text,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.tertiary,
      ),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Theme.of(context).colorScheme.primary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType:
        isPasswordType ? TextInputType.visiblePassword : TextInputType.text,
  );
}

Container button(BuildContext context, ButtonType buttonType, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Theme.of(context).colorScheme.secondary;
            }
            return Theme.of(context).colorScheme.primary;
          }),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
      child: Text(
        buttonType == ButtonType.SignUp ? 'Бүртгүүлэх' : 'Нэвтрэх',
        style: TextStyle(
          color: Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ),
  );
}

enum ButtonType { SignUp, Login }
