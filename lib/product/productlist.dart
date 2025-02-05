import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/AddtoCart/Cart.dart';
import 'package:for_her/Wishlist/Wistlistpage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Category/CategoryDropdown.dart';

NavigatorPage(context, pp) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => pp));
}

class ProductList extends StatefulWidget {
  final String brand;
  const
  ProductList({super.key, required this.brand});

  @override
  State<ProductList> createState() => _ProductListState();
}
class _ProductListState extends State<ProductList> {
  List brandcategorylist = [];
  List<String> wishlistProductIds = [];
  List<String> cartProductIds = [];

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
    fetchCartItems();
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

  Future<void> fetchCartItems() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final wishlistSnapshot = await FirebaseFirestore.instance
            .collection('Cart')
            .where('userId', isEqualTo: user.email)
            .get();

        setState(() {
          cartProductIds = wishlistSnapshot.docs
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
  bool isInCart(String productId) {
    return cartProductIds.contains(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.brand,
          style: TextStyle(
            fontSize: 30,
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            color: Color(0xff057d05),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 130,
            width: 900,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Brand')
                  .where('Brands', isEqualTo: widget.brand)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("ERROR");
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final snap = snapshot.data!.docs[0];
                brandcategorylist = snap['brandcategory'];
                Map<String, dynamic> brandcategory =
                snap['categorypics'] as Map<String, dynamic>;
                return ListView.builder(
                  itemCount: brandcategorylist.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CDrop(brandcategory: brandcategorylist[index]),
                            ),
                          );
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
                                  image: NetworkImage(
                                      brandcategory[brandcategorylist[index]]),
                                ),
                              ),
                            ),
                            Text(
                              brandcategorylist[index],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 600,
            width: double.infinity,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Products')
                  .where('Brands', isEqualTo: widget.brand)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "ERROR ::: ${snapshot.error}",
                    style: TextStyle(color: Colors.black),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 20,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 250.0,
                  ),
                  itemBuilder: (context, index) {
                    final snap = snapshot.data!.docs[index];
                    final iswish = isInWishlist(snap.id);
                    final istocart =isInCart(snap.id);
                    return GestureDetector(
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
                            'userId':FirebaseAuth.instance.currentUser!.email,
                          },
                        );
                        setState(() {
                          cartProductIds.add(snap.id);
                          wishlistProductIds.add(snap.id);
                        });
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
                                    color: Colors.white,
                                    child: Text(istocart ? 'Go to cart' : 'Add to cart'),
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
                                        color:
                                        iswish
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
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
//
// class MMEarth extends StatefulWidget {
//   MMEarth(
//       {super.key,
//         required this.onTap,
//         required this.img,
//         required this.proname,
//         required this.rupee, required this.iswish});
//   bool iswish;
//   final Function? onTap;
//   final ImageProvider img;
//   final String proname;
//   final String rupee;
//
//   @override
//   State<MMEarth> createState() => _MMEarthState();
// }
//
// class _MMEarthState extends State<MMEarth> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => widget.onTap!(),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10.0),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(25),
//             color: Color(0xff8a92cd),
//           ),
//           height: 400,
//           width: 100,
//           child: Column(
//             children: [
//               SizedBox(height: 12),
//               ClipRRect(
//                 child: Image(
//                   image: widget.img,
//                   height: 200,
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
//                       onPressed: () {
//                         if (widget.iswish == false) {
//                           setState(() {
//                             widget.iswish = true;
//                           });
//                         } else {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => WishlistPage(),
//                             ),
//                           );
//                         }
//                       },
//                       icon: Icon(
//                         Icons.favorite,
//                         color: widget.iswish
//                             ? Color(0xff7b0001)
//                             : Colors.white, // Change color based on selection
//                         size: 30.0, // Customize the icon size
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
