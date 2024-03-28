import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(top: 25, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 32),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.search, size: 32),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Image.asset(
                "assets/2.jpg",
                height: MediaQuery.of(context).size.height / 2.5,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hot and Fresh Burger",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.minus,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "2",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () {},
                            child: Container(
                                alignment: Alignment.center,
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Icon(
                                  CupertinoIcons.plus,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "dsadasdsadasdsa dsad sad sad ad sad asd sadsad as",
                  style: TextStyle(color: Colors.black, fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
