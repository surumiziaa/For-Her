import 'package:flutter/material.dart';
import 'package:for_her/Home/Listview.dart';

import '../Carousal Slider.dart';
import 'Gridview.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              cursorColor: Color(0xff8f6152),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                ),
                hintText: 'Search Here',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xff8f6152),
                    )
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xff8f6152),
                    )
                ),
              ),
            ),
          ),
          Carousals(),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text('Products',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff8f6152),
                  ),),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Items(),
          Homecontainer(),
        ],
      ),
    );
  }
}