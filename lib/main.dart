import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:for_her/CheckOut/Singlecheckout.dart';
import 'package:for_her/Firebase/firebase_options.dart';
import 'package:for_her/MyCart/cartview.dart';
import 'package:for_her/Wishlist/Removewish.dart';
import 'package:for_her/product/productview.dart';
import 'AddtoCart/Cart.dart';
import 'Adress/add_singleadress.dart';
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
          'singleaddress':(context)=>SingleAddress(),
          "singlecheckout":(context)=>Buynow()
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
