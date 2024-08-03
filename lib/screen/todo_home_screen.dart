import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../widgets/search_bar.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           const Icon(Icons.menu , size: 30,),
           const Text("TODO" , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold , fontFamily: "myFont"),),
            Container(
              height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  image: const DecorationImage(
                    image: AssetImage("assets/image/devrahul.jpg" , ) , fit: BoxFit.cover
                  )
                ),
            )
          ],
        ),centerTitle: true,
      ),

      body: Column(
        children: [
          SizedBox(height: 20,),
          Search()
        ],
      ),
    );
  }
}
