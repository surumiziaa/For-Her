import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Adress/AddAdress.dart';
import 'package:for_her/Adress/newaddress.dart';
import 'package:for_her/Payment/paymentpage.dart';
import 'package:google_fonts/google_fonts.dart';

class Checkoutdetails extends StatefulWidget {
  const Checkoutdetails({super.key});

  @override
  State<Checkoutdetails> createState() => _CheckoutdetailsState();
}

class _CheckoutdetailsState extends State<Checkoutdetails> {
  final CollectionReference address = FirebaseFirestore.instance.collection("Address");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Address',
            style: TextStyle(
              fontSize: 30,
              fontFamily: GoogleFonts.playfairDisplay().fontFamily,
              color: Color(0xff00295d),
            ),),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 230,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: StreamBuilder(
                      stream: address.snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(child: Text('Something went wrong'));
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No address found'));
                        }

                        final DocumentSnapshot snap = snapshot.data!.docs[0];

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Text(
                                    snap['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    snap['address']
                                        .split("+")
                                        .join('\n'),
                                  ),
                                ],
                              ),
                            ),
                             Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Row(
                                children: [
                                  Text(snap['pincode']),
                                ],
                              ),

                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Row(
                              children: [
                              Text(snap['phone']),
                              ],
                              ),),
                             Padding(
                              padding: EdgeInsets.only(
                                left: 15.0,
                                right: 15,
                                top: 10,
                              ),
                              child: Divider(
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: 18.0, right: 18),
                              child: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                     Navigator.pushNamed(context,'editaddress',
                                     arguments: {
                                       'EdName':snap['name'],
                                       'EdPhone':snap['phone'],
                                       'Edadress':snap['address'],
                                       'EdPin':snap['pincode'],
                                       'id':FirebaseAuth.instance.currentUser!.email,
                                     });
                                    },
                                    child: Text(
                                      'Edit Address',
                                      style: TextStyle(
                                        color: Color(0xff7b0001),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>NewAddress()));
                                    },
                                    child: const Text(
                                      'Add New Address',
                                      style: TextStyle(
                                        color: Color(0xff057d05),
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Row(
                children: [
                  SizedBox(width: 10,),
                  Text('Price Details',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Product Price',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                    Text('₹100',
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 8,),
              const Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charge',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff057d05),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('₹100',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff057d05),
                            fontWeight: FontWeight.bold
                        ))
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12.0, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Total',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff7b0001),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text('₹100',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff7b0001),
                            fontWeight: FontWeight.bold
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 35,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: MaterialButton(
                  color: const Color(0xff057d05),
                  minWidth: 400,
                  child: const Text('Proceed'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
