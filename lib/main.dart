import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Adress/AddAdress.dart';
import 'package:for_her/Firebase/firebase_options.dart';
import 'package:for_her/MyCart/cartview.dart';
import 'package:for_her/Wishlist/Removewish.dart';
import 'package:for_her/product/productview.dart';
import 'AddtoCart/Cart.dart';
import 'Adress/EditAddress.dart';
import 'Home/Splash.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ForHer(),
        routes: {
          'productview':(context)=> ProductView(),
          'wishview'   :(context)=> Wishview(),
          'cartview'   :(context)=>Cartt(),
          'viewcart'   :(context)=>Cartview(),
          'editaddress':(context)=>EditAddress(),
        },
      )
  );
}

class ForHer extends StatefulWidget {
  const ForHer({super.key});

  @override
  State<ForHer> createState() => _ForHerState();
}

class _ForHerState extends State<ForHer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Splashscreen(),
      ),
    );
  }
}
