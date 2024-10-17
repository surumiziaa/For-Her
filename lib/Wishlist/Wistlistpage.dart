import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/AddtoCart/Cart.dart';
import 'package:google_fonts/google_fonts.dart';

NavigatorPage(context, pp) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pp));
}

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<String> wishlistIds = [];
  List cartIds = [];
  // List to store wishlist product IDs

  @override
  void initState() {
    super.initState();
    _getWishlistIds();
    fetchCartItems();
    // Load wishlist IDs
  }

  // Fetch wishlist IDs from Firestore
  Future<void> _getWishlistIds() async {
    final user = FirebaseAuth.instance.currentUser;
    final wishlistSnapshot = await FirebaseFirestore.instance.collection('Wishlist').where('userId', isEqualTo: user!.email).get();
    final ids = wishlistSnapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      wishlistIds = ids;
    });
  }


  Future<void> fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('Cart')
          .where('userId', isEqualTo: user!.email)
          .get();
      final ids = cartSnapshot.docs.map((doc) => doc['ProductId']).toList();
      setState(() {
        cartIds = ids;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 30,
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            color: Color(0xff00295d),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Wishlist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator());
          }
          return GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 40,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                mainAxisExtent: 250.0
            ),
            itemBuilder: (BuildContext context, int index) {
              final snap = snapshot.data!.docs[index];
              final productId = snap['ProductId'];
              bool isInWishlist = wishlistIds.contains(snap.id); // Check if the item is in wishlist
              bool istocart = cartIds.contains(productId);
              return GestureDetector(
                onTap: () {
                      Navigator.pushNamed(context,  'wishview',arguments: {
                        'ProductId': snap['ProductId'],
                        'ProductName': snap['ProductName'],
                        'image': snap['image'],
                        'Price': snap['Price'],
                        'Description': snap['Description'],
                        'Brand': snap['Brand'],
                        'Categories': snap['Categories'],
                        'Rating': snap['Rating'],
                        'Stock': snap['Stock'],
                        'wishId': snap.id,
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0xff9fd5e0),
                    ),
                    height:500,
                    width: 100,
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        ClipRRect(
                          child: Image(
                            image: NetworkImage(snap['image'][0]),
                            height: 250,
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
                              onPressed: ()async{
                                if(istocart == false){
                                  try{
                                    await FirebaseFirestore.instance.collection('Cart')
                                        .add({
                                      'ProductId': snap['ProductId'],
                                      'ProductName': snap['ProductName'],
                                      'image': snap['image'],
                                      'Price': snap['Price'],
                                      'Description': snap['Description'],
                                      'Brand': snap['Brand'],
                                      'Categories': snap['Categories'],
                                      'Rating': snap['Rating'],
                                      'Stock': snap['Stock'],
                                      'userId': FirebaseAuth
                                          .instance.currentUser!.email,
                                    });
                                    setState(() {
                                      cartIds.add(snap['ProductId']);
                                      istocart = cartIds.contains(snap['ProductId']);
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
                              color: Colors.white,
                              child:Text(istocart ? 'Go to cart' : 'Add to cart'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: IconButton(
                                onPressed: () async{
                                  await FirebaseFirestore.instance.collection('Wishlist').doc(snap.id).delete();
                                  setState(() {
                                    isInWishlist=false;
                                  });
                                  },
                                icon: Icon(
                                  Icons.favorite,
                                  color: isInWishlist
                                      ? Color(0xff7b0001)
                                      : Colors.white, // Change color based on selection
                                  size: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}
//
// class ListContainerDesign extends StatefulWidget {
//   ListContainerDesign({
//     super.key,
//     required this.onTap,
//     required this.img,
//     required this.proname,
//     required this.rupee,
//     required this.isInWishlist, // Added this parameter
//   });
//
//   final Function? onTap;
//   final ImageProvider img;
//   final String proname;
//   final String rupee;
//   final bool isInWishlist; // Wishlist status
//
//   @override
//   State<ListContainerDesign> createState() => _ListContainerDesignState();
// }
//
// class _ListContainerDesignState extends State<ListContainerDesign> {
//   bool isIconSelected = false;
//
//   @override
//   void initState() {
//     super.initState();
//     isIconSelected = widget.isInWishlist;
//     // [ Initialize icon selection based on wishlist status ]
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => widget.onTap!(),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10.0),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             color: Color(0xff9fd5e0),
//           ),
//           height:5,
//           width: 100,
//           child: Column(
//             children: [
//               SizedBox(height: 12),
//               ClipRRect(
//                 child: Image(
//                   image: widget.img,
//                   height: 280,
//                   width: 170,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Text(
//                 widget.proname,
//                 style: TextStyle(
//                   overflow: TextOverflow.ellipsis,
//                   fontSize: 20,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {},
//                     color: Colors.white,
//                     child: Text('Add to cart'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: IconButton(
//                       onPressed: () async{
//                         setState(() {
//                           isIconSelected = !isIconSelected;
//                           // Update wishlist status here
//                         });
//                         if(isIconSelected == true){
//                           await FirebaseFirestore.instance.collection('Wishlist').doc(args['wishId']).delete();
//                           setState(() {
//                             isIconSelected=false;
//                           });
//                         }
//                       },
//                       icon: Icon(
//                         Icons.favorite,
//                         color: isIconSelected
//                             ? Color(0xff7b0001)
//                             : Colors.white, // Change color based on selection
//                         size: 30.0,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }