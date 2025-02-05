import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Adress/addresspage.dart';
import 'package:for_her/Profile/profilepage.dart';
import 'package:for_her/UrlLauncher/phone.dart';
import 'package:for_her/Wishlist/Wistlistpage.dart';
import 'package:for_her/orders/view_orders.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/Login.dart';

class Drawerset extends StatefulWidget {
  const Drawerset({super.key});

  @override
  State<Drawerset> createState() => _DDState();
}

class _DDState extends State<Drawerset> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon:Icon(
        Icons.drag_handle,
        size: 35,
        color:Color(0xff8f6152),
      ),
        itemBuilder: (BuildContext)=>[
          PopupMenuItem(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyAccount()));
            },
              child: Row(
                children: [
                  Icon(Icons.person,
                    color: Color(0xff8f6152),),
                  Text('My Account',
                    style: TextStyle(
                        fontFamily: GoogleFonts.lora().fontFamily
                    ),)
                ],
              ),),
          PopupMenuItem(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderScreen()));
            },
              child:Row(
                children: [
                  Icon(MdiIcons.package,
                    color:Color(0xff8f6152),),
                  Text('My Orders',
                    style: TextStyle(
                        fontFamily: GoogleFonts.lora().fontFamily
                    ),)
                ],
              ),),
          PopupMenuItem(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context)=>WishlistPage()));
            },
            child:Row(
            children: [
              Icon(Icons.favorite_border,
                color:Color(0xff8f6152),),
              Text(' My Wishlist',
                style: TextStyle(
                    fontFamily: GoogleFonts.lora().fontFamily
                ),)
            ],
          ),),
          PopupMenuItem(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Addresspage()));
            },
              child:Row(
                children: [
                  Icon(Icons.location_city,
                      color:Color(0xff8f6152)),
                  Text('My Address',
                    style: TextStyle(
                        fontFamily: GoogleFonts.lora().fontFamily
                    ),)
                ],
              ),),
          PopupMenuItem(
            onTap: (){
              Navigator.pushNamed(context, 'cartview');
            },
              child:  Row(
                children: [
                  Icon(Icons.shopping_cart,
                      color:Color(0xff8f6152)),
                  Text('My Cart',
                    style: TextStyle(
                        fontFamily: GoogleFonts.lora().fontFamily
                    ),)
                ],
              ),),
          PopupMenuItem(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpCenter()));
            },
            child:  Row(
              children: [
                Icon(Icons.help,
                    color:Color(0xff8f6152)),
                Text('Help Center',
                  style: TextStyle(
                      fontFamily: GoogleFonts.lora().fontFamily
                  ),)
              ],
            ),),
          PopupMenuItem(
            onTap: ()async {
              showDialog(
                context: context,
                builder: (context) {
                  return Card(
                    color: Colors.grey,
                    elevation: 20,
                    child: AlertDialog(
                      backgroundColor: Colors.white,
                      title: const Text("About"),
                      content: Text("Do you want to logout\nthis account?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("No")),
                        TextButton(
                            onPressed: (){
                            signout();
                            },
                            child: const Text("Yes")),
                      ],
                    ),
                  );
                },
              );
            },
            child:Row(
            children: [
              Icon(Icons.logout_outlined,
                  color:Color(0xff8f6152)),
              Text('Logout',
                style: TextStyle(
                    fontFamily: GoogleFonts.lora().fontFamily
                ),),
            ],
          ),),
        ]
    );
  }
  Future signout()async{
    try{
      await FirebaseAuth.instance.signOut();
      final SharedPreferences preferences =
      await SharedPreferences.getInstance();
      preferences.setBool('islogged',false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
    }
    catch (e){
      print(e);
    }
  }
}
