
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:for_her/orders/order_details.dart';
import 'package:intl/intl.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white70,
          body:StreamBuilder(
            stream: FirebaseFirestore.instance.collection("orders")
            .where("userId",
                isEqualTo:FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.hasError){
              log(snapshot.error.toString());
            }else if(snapshot.connectionState== ConnectionState.waiting){
              return Center(
                  child: CircularProgressIndicator()
              );
            }
              return ListView.builder(
                itemCount:snapshot.data!.docs.length,
                  itemBuilder:(context,int index){
                    final snap = snapshot.data!.docs[index];
                    DateFormat('dd//MM//yyyy').parse(snap['placed_date']);
                    final expectingDate = snap['expected'];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        elevation: 8,
                        child: ListTile(
                          leading:ClipRRect(
                            child:Image(
                              image:NetworkImage(snap['image'][0]),
                              height: 50,
                              width: 50,
                            ),
                          ),
                          title:Text(
                            snap['track'] != "cancelled"
                                ?"Expected deliver on $expectingDate "
                                :'Cancelled',
                            style: TextStyle(
                              color: snap['track'] !="cancelled"
                                  ?green
                                  :Red
                            ),
                          ),
                          subtitle:Text(
                            snap['ProductName'],
                          ),
                          trailing:IconButton(
                            onPressed: (){
                              setState(() {
                               Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderDetails(orderId: snap.id)));
                              });
                            },
                            icon:Icon(
                              Icons.navigate_next_outlined,
                              color: org,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
          },
          )
        ),
      ),
    );
  }
}
