import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Category/CategoryDropdown.dart';
import '../../Wishlist/Wistlistpage.dart';



NavigatorPage(context,pp){
  Navigator.push(context,MaterialPageRoute(builder: (context)=>pp) );
}
class HomeScreenListProduct extends StatefulWidget {
  final String brand;
  const HomeScreenListProduct({super.key, required this.brand});

  @override
  State<HomeScreenListProduct> createState() => _HomeScreenListProductState();
}


class _HomeScreenListProductState extends State<HomeScreenListProduct> {

  List brandcategorylist = [];
  List productIds = [];
  bool iswish = false;
  List<String> wishlistProductIds = [];

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final wishlistSnapshot = await FirebaseFirestore.instance
            .collection('Wishlist')
            .where('userId', isEqualTo: user.email)
            .get();

        setState(() {
          wishlistProductIds = wishlistSnapshot.docs
              .map((doc) => doc['ProductId'] as String)
              .toList();
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  bool isInWishlist(String productId) {
    return wishlistProductIds.contains(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.brand,
          style: TextStyle(
            fontSize: 30,
            fontFamily:GoogleFonts.playfairDisplay().fontFamily,
            color:Color(0xff00295d),
          ),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          SizedBox(
            height: 130,
            width:900,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Brand').where('Brands',isEqualTo: widget.brand).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return  Text("ERROR");
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  final snap = snapshot.data!.docs[0];
                  brandcategorylist = snap['brandcategory'];
                  Map<String,dynamic> brandcategory = snap['categorypics'] as Map<String,dynamic>;
                  print(brandcategorylist);
                  print(brandcategory);
                  return ListView.builder(
                      itemCount: brandcategorylist.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder:(context,index) {
                        return  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => CDrop(brandcategory:brandcategorylist[index])));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black54,
                                      ),
                                      borderRadius: BorderRadius.circular(90),
                                      image: DecorationImage(
                                        image: NetworkImage(brandcategory[brandcategorylist[index]]),
                                      )
                                  ),
                                ),
                                Text(brandcategorylist[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),)
                              ],
                            ),
                          ),
                        );
                      }
                  );
                }
            ),
          ),
          SizedBox(
            height: 600,
            width: double.infinity,
            child: StreamBuilder(
                stream:FirebaseFirestore.instance.collection('Products').where('Brands',isEqualTo: widget.brand).snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Text("ERROR ::: ${snapshot.error}",style: TextStyle(color: Colors.black),);
                  }else if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  return GridView.builder(
                      scrollDirection: Axis.horizontal,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount:snapshot.data!.docs.length,
                      shrinkWrap: true,
                      gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 20,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 250.0
                      ) ,
                      itemBuilder:(BuildContext ,int index){
                        final snap = snapshot.data!.docs[index];
                        final iswish = isInWishlist(snap.id);
                        return
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                'productview',
                                arguments: {
                                  'ProductId': snap.id,
                                  'ProductName': snap['ProductName'],
                                  'image': snap['image'],
                                  'Price': snap['Price'],
                                  'Description': snap['Description'],
                                  'Brand': snap['Brands'],
                                  'Categories': snap['Categories'],
                                  'Rating': snap['Rating'],
                                  'Stock': snap['Stock'],
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(0xff8a92cd),
                                ),
                                height: 400,
                                width: 100,
                                child: Column(
                                  children: [
                                    SizedBox(height: 12),
                                    ClipRRect(
                                      child: Image(
                                        image: NetworkImage(snap['image'][0]),
                                        height: 200,
                                        width: 170,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Text(
                                      snap['ProductName'],
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {},
                                          color: Colors.white,
                                          child: Text('Add to cart'),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: IconButton(
                                            onPressed: () async {
                                              if (iswish == false) {
                                                try {
                                                  await FirebaseFirestore.instance
                                                      .collection('Wishlist')
                                                      .add({
                                                    'ProductId': snap.id,
                                                    'ProductName': snap['ProductName'],
                                                    'image': snap['image'],
                                                    'Price': snap['Price'],
                                                    'Description': snap['Description'],
                                                    'Brand': snap['Brands'],
                                                    'Categories': snap['Categories'],
                                                    'Rating': snap['Rating'],
                                                    'Stock': snap['Stock'],
                                                    'userId': FirebaseAuth
                                                        .instance.currentUser!.email,
                                                  });
                                                  setState(() {
                                                    wishlistProductIds.add(snap.id);
                                                  });
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WishlistPage(),
                                                  ),
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              Icons.favorite,
                                              color: iswish
                                                  ? Color(0xff7b0001)
                                                  : Colors.white, // Change color based on selection
                                              size: 30.0, // Customize the icon size
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                      }
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
