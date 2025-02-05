

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../CheckOut/Checkoutpage.dart';

class Cartt extends StatefulWidget {
  const Cartt({super.key});

  @override
  State<Cartt> createState() => _CarttState();
}

class _CarttState extends State<Cartt> {
  Map<String, String> selectedQuantities = {};
  List<String> Quantity = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  double totalAmount = 0.0;

  void _calculateTotalAmount(List<QueryDocumentSnapshot> docs) {
    totalAmount = 0.0;
    for (var snap in docs) {
      final productId = snap['ProductId'];
      final productPrice = snap['Price'].toDouble();
      final selectedQuantity = selectedQuantities[productId] ?? '1';
      final itemTotal = productPrice * int.parse(selectedQuantity);
      totalAmount += itemTotal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
            fontSize: 30,
            fontFamily: GoogleFonts.playfairDisplay().fontFamily,
            color: const Color(0xff00295d),
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Cart')
              .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data!.docs;
            _calculateTotalAmount(docs); // Calculate total amount

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: docs.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        final snap = docs[index];
                        final productId = snap['ProductId'];
                        final productPrice = snap['Price'].toDouble();
                        final selectedQuantity = selectedQuantities[productId] ?? '1';
                        final itemTotal = productPrice * int.parse(selectedQuantity);
                        totalAmount +=itemTotal;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'viewcart', arguments: {
                              'ProductId': snap['ProductId'],
                              'ProductName': snap['ProductName'],
                              'image': snap['image'],
                              'Price': snap['Price'],
                              'Description': snap['Description'],
                              'Brand': snap['Brand'],
                              'Categories': snap['Categories'],
                              'Rating': snap['Rating'],
                              'Stock': snap['Stock'],
                              'cartId': snap.id,
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Card(
                              elevation: 10,
                              shadowColor: Colors.grey,
                              child: Container(
                                width: 380,
                                height: 380,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                                      child: Text(
                                        snap['ProductName'].split("+").join('\n'),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Color(0xff00295d),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            child: Image.network(
                                              snap['image'][0],
                                              fit: BoxFit.fill,
                                              height: 200,
                                              width: 150,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 150,
                                          width: 150,
                                          child: SingleChildScrollView(child: Text(snap['Description'])),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '₹ ${itemTotal.toStringAsFixed(2)} /-',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('Cart')
                                                  .doc(snap.id)
                                                  .delete();
                                              setState(() {
                                                selectedQuantities.remove(productId);
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Color(0xff00295d),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: DropdownButtonFormField(
                                              value: selectedQuantity,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                hintText: 'Quantity',
                                              ),
                                              items: Quantity.map((String value) {
                                                return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedQuantities[productId] = value as String;
                                                  _calculateTotalAmount(docs); // Recalculate total amount when quantity changes
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                BottomSheet(
                  onClosing: () {},
                  builder: (BuildContext context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Price\n₹${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Checkoutdetails()));
                            },
                            child: const Text(
                              'CheckOut',
                              style: TextStyle(
                                color: Color(0xff7b0001),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }
      ),
    );
  }
}

// class Cartt extends StatefulWidget {
//   const Cartt({super.key});
//
//   @override
//   State<Cartt> createState() => _CarttState();
// }
//
// class _CarttState extends State<Cartt> {
//
//   List<String> cartlist = [];
//   List price = [];
//   Map<String, String> selectedQuantities = {};
//   List<String> Quantity = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
//   double totalAmount = 0.0;
//
//
//   Future<void> fetchPrice() async {
// final args = ModalRoute.of(context)!.settings.arguments as Map;
// var productId = args['ProductId'];
// var price = args['Price'];
// final totalquantity = selectedQuantities[productId] ?? '1';
// final itemTotal = price * int.parse(totalquantity);
// setState(() {
//   totalAmount += itemTotal;
//
// });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Cart',
//           style: TextStyle(
//             fontSize: 30,
//             fontFamily: GoogleFonts.playfairDisplay().fontFamily,
//             color: Color(0xff00295d),
//           ),
//         ),
//       ),
//       body: StreamBuilder(
//           stream: FirebaseFirestore.instance.collection('Cart').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             fetchPrice();
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         final snap = snapshot.data!.docs[index];
//                         final productId = snap['ProductId'];
//                         final productPrice = snap['Price'];
//                         final selectedQuantity = selectedQuantities[productId] ?? '1';
//                         final itemTotal = productPrice * int.parse(selectedQuantity);
//                         totalAmount += itemTotal;
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(context, 'viewcart', arguments: {
//                               'ProductId': snap['ProductId'],
//                               'ProductName': snap['ProductName'],
//                               'image': snap['image'],
//                               'Price': snap['Price'],
//                               'Description': snap['Description'],
//                               'Brand': snap['Brand'],
//                               'Categories': snap['Categories'],
//                               'Rating': snap['Rating'],
//                               'Stock': snap['Stock'],
//                               'cartId': snap.id,
//                             });
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(18.0),
//                             child: Card(
//                               elevation: 10,
//                               shadowColor: Colors.grey,
//                               child: Container(
//                                 width: 380,
//                                 height: 380,
//                                 child: Column(
//                                   children: [
//                                     SizedBox(height: 5),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 20.0, bottom: 10),
//                                       child: Text(
//                                         snap['ProductName'].split("+").join('\n'),
//                                         style: const TextStyle(
//                                             fontSize: 15,
//                                             color: Color(0xff00295d),
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     Row(
//                                       children: [
//                                         Padding(
//                                           padding: EdgeInsets.all(8.0),
//                                           child: ClipRRect(
//                                             child: Image(
//                                               image: NetworkImage(snap['image'][0]),
//                                               fit: BoxFit.fill,
//                                               height: 200,
//                                               width: 150,
//                                             ),
//                                           ),
//                                         ),
//                                         Container(
//                                             height: 150,
//                                             width: 150,
//                                             child: SingleChildScrollView(child: Text(snap['Description']))),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 10),
//                                     Padding(
//                                       padding: EdgeInsets.only(left: 25.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             '₹ ${itemTotal.toString()} /-',
//                                             style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           IconButton(
//                                               onPressed: () async {
//                                                 await FirebaseFirestore.instance
//                                                     .collection('Cart')
//                                                     .doc(snap.id)
//                                                     .delete();
//                                                 setState(() {
//                                                   cartlist.remove(productId);
//                                                   selectedQuantities.remove(productId);
//                                                 });
//                                               },
//                                               icon: Icon(
//                                                 Icons.delete,
//                                                 size: 30,
//                                                 color: Color(0xff00295d),
//                                               )),
//                                         ],
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 18.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(
//                                             height: 50,
//                                             width: 100,
//                                             child: DropdownButtonFormField(
//                                               value: selectedQuantity,
//                                               decoration: InputDecoration(
//                                                   border: OutlineInputBorder(
//                                                       borderRadius: BorderRadius.circular(15)),
//                                                   hintText: 'Quantity'),
//                                               items: Quantity.map((String value) {
//                                                 return DropdownMenuItem(
//                                                   child: Text(value),
//                                                   value: value,
//                                                 );
//                                               }).toList(),
//                                               onChanged: (value) {
//                                                 setState(() {
//                                                   selectedQuantities[productId] = value as String;
//                                                   fetchPrice();
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                 ),
//                 BottomSheet(
//                   onClosing: () {},
//                   builder: (BuildContext context) {
//                     return Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'Total Price\n₹${totalAmount.toStringAsFixed(2)}',
//                               style: const TextStyle(fontSize: 20, color: Colors.black),
//                             )
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: MaterialButton(
//                             onPressed: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => const Checkoutdetails()));
//                             },
//                             child: const Text(
//                               'CheckOut',
//                               style: TextStyle(
//                                 color: Color(0xff7b0001),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             );
//           }),
//     );
//   }
// }