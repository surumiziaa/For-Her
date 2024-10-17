import 'package:flutter/material.dart';
import 'package:for_her/Search.dart';
import 'package:for_her/Tutorials/Tutorials.dart';
import 'package:for_her/Drawer/drawer.dart';
import 'package:for_her/Home/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../Category/Categories.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selected =0;
  List Pages =[
    Homepage(),
    Categories(),
    Search(),
    Tutorials(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:Card(
        elevation: 6,
        margin: EdgeInsets.all(16),
        child: SalomonBottomBar(
          onTap: (index){
            setState(() {
              selected=index;
            });
          },
          currentIndex: selected,
          items: [
            SalomonBottomBarItem(
              selectedColor:Color(0xff7b0001),
                icon:Icon(Icons.home) ,
                title:Text('Home') ,
            ),
            SalomonBottomBarItem(
                icon:Icon(Icons.category) ,
                title:Text('Category') ,
            selectedColor:Color(0xff057d05)
            ),
            SalomonBottomBarItem(
                icon:Icon(Icons.search_off) ,
                title:Text('Search'),
            selectedColor:Color(0xff8a92cd),),
            SalomonBottomBarItem(
                icon:Icon(Icons.video_collection_rounded) ,
                title:Text('Tutorial'),
            selectedColor:Colors.orangeAccent
            ),
          ],
        ),
      ),
     // endDrawer: Drawerset(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              child: Image(
                image: AssetImage('lib/images/make-up.png'),
                color: Color(0xff8f6152),
                height: 22,
                width: 22,
              ),
            ),
          ),
        title:Center(
          child: Text('F4_Her',
            style: TextStyle(
                fontFamily: GoogleFonts.gwendolyn().fontFamily,
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Color(0xff8f6152),
            ),),
        ),
        actions: [
          Drawerset()
          // DD(),
        ],
      ),
      body:SingleChildScrollView(
        child: Pages[selected],
      )
    );
  }
}
