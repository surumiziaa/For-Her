import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:for_her/Wishlist/Wistlistpage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../AddtoCart/Cart.dart';

class CDrop extends StatefulWidget {
  final String brandcategory;
  const CDrop({super.key, required this.brandcategory});

  @override
  State<CDrop> createState() => _CDropState();
}

class _CDropState extends State<CDrop> {
  bool isIconSelected = false;
  List<String> cartProductIds = [];
  List<String> wishlistIds = [];
@override
  void initState() {
    super.initState();
    fetchCartItems();
    fetchwishitems();
  }
  Future<void> fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final cartsnapshot = await FirebaseFirestore.instance
            .collection('Cart')
            .where('userId', isEqualTo: user.email)
            .get();

        setState(() {
          cartProductIds = cartsnapshot.docs
              .map((doc) => doc['ProductId'] as String)
              .toList();
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchwishitems() async{
  try{
    final user = await FirebaseAuth.instance.currentUser!;
    if(user != null){
      final wishlistsnap = await FirebaseFirestore.instance.collection('Wishlist')
          .where('userId',isEqualTo:user.email).get();
      setState(() {
        wishlistIds =wishlistsnap.docs.map((doc)=>doc['ProductId'] as String).toList();
      });
    }
  }catch (e){
    log(e.toString());
  }
  }
  bool isInwish(String productId){
  return wishlistIds.contains(productId);
  }
  
  bool isInCart(String productId) {
    return cartProductIds.contains(productId);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.brandcategory,
            style: TextStyle(
              fontSize: 30,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              color:pur,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child:
          Column(
            children: [
              SizedBox(height: 10),
              // ✅ DEBUG: Print selected category before querying Firestore
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('Products').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    print("🔥 ALL PRODUCTS IN DATABASE: ");
                    for (var doc in snapshot.data!.docs) {
                      print(doc.data()); // Print all products to debug
                    }
                  }
                  return SizedBox(); // Hide widget after debug
                },
              ),
          
              //✅ StreamBuilder to get products based on selected category
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Products') // ✅ Ensure collection name is correct
                    .where('Categories', isEqualTo: widget.brandcategory.trim()) // ✅ Trim spaces
                    .snapshots(),
                builder: (context, snapshot) {
                  // ✅ Handle errors
                  if (snapshot.hasError) {
                    return Center(child: Text('❌ Error loading products'));
                  }
          
                  // ✅ Show loading indicator
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
          
                  // ✅ Print query results for debugging
                  print("🔍 Query Results: ${snapshot.data!.docs}");
          
                  // ✅ Check if products exist
                  if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                    print("🚨 No products found for category: ${widget.brandcategory}");
                    return Center(child: Text('No products found for this category'));
                  }
          
                  //  Display products in Carousel Slider

                        return SizedBox(
                          height: MediaQuery.of(context).size.height*1.2*8.5,
                          width: MediaQuery.of(context).size.width*2.5,
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:snapshot.data!.docs.length,
                            itemBuilder: (context,index) {
                              final snap =snapshot.data!.docs[index];
                              final istocart =isInCart(snap.id);
                              final istowish = isInwish(snap.id);
                              return Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'productview', arguments: {
                                      'ProductId': snap.id,
                                      'ProductName': snap['ProductName'],
                                      'image': snap['image'],
                                      'Price': snap['Price'],
                                      'Description': snap['Description'],
                                      'Brand': snap['Brands'],
                                      'Categories': snap['Categories'],
                                      'Rating': snap['Rating'],
                                      'Stock': snap['Stock'],
                                      'userId': FirebaseAuth.instance.currentUser!.email,
                                    }).then((_) {
                                      fetchCartItems(); 
                                      fetchwishitems();
                                      setState(() {});
                                    });
                                  },
                                  child: Card(
                                    color: Colors.white,
                                    shadowColor: Colors.grey,
                                    elevation: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white70,
                                      ),
                                      height: 400,
                                      width: 100,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12),
                                          ClipRRect(
                                            child: Image(
                                              image: NetworkImage(snap['image'][0]),
                                              height: 150,
                                              width: 120,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0,left: 8),
                                            child: Text(
                                              snap['ProductName'],
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                onPressed: ()async{
                                                  if(istocart == false){
                                                    try{
                                                      await FirebaseFirestore.instance.collection('Cart')
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
                                                        cartProductIds.add(snap.id);
                                                      });
                                                    }
                                                    catch (e) {
                                                      log(e.toString());
                                                    }
                                                  }else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Cartt()
                                                      ),
                                                    );
                                                  }
                                                },
                                                color:pur,
                                                child: Text(istocart ? 'Go to cart' : 'Add to cart',
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: ()async {
                                                  if(istowish == false){
                                                    try{
                                                      await FirebaseFirestore.instance.collection('Wishlist')
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
                                                        wishlistIds.add(snap.id);
                                                      });
                                                    }
                                                    catch (e) {
                                                      log(e.toString());
                                                    }
                                                  }else {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                             WishlistPage()
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: istowish?Color(0xff7b0001) : Colors.grey,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 10,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 250.0
                          ),
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
