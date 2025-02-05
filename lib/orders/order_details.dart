
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';
import 'package:for_her/orders/timeline.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final String orderId;
  const OrderDetails({super.key, required this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:AppBar(
          backgroundColor:green,
          title:Text("Order Details",
          style: TextStyle(
            color: Colors.white
          ),),
        ),
        body:StreamBuilder(
          stream:FirebaseFirestore.instance.collection('orders')
          .doc(widget.orderId).snapshots(),
          builder: (BuildContext context,  snapshot) {
            if(snapshot.hasData){
              final snap = snapshot.data!;
              final expectingDate = snap['expected'];
              return  SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children:[
                      height,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Order ID : ${widget.orderId}",style: TextStyle(fontSize:20),),
                        ),
                      ),
                      height,
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left:20),
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.blueGrey,
                          child: ClipRRect(
                            child:Image(
                              image: NetworkImage(snap['image'][0]),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 20),
                        child: Text(snap['ProductName']),
                      ),
                      height,
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,left: 20,right: 20),
                        child: Text(snap['Description']),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10,left: 20),
                            child: Text('Total Price = ',
                              style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0,left: 20),
                            child: Text('${snap['totalPrice']}/-',
                            style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ),),
                          ),
                        ],
                      ),

                      height,
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height/1.5,
                          child:ListView(
                            physics:NeverScrollableScrollPhysics(),
                            children: [
                              TimelineTileWidget(
                                  isFirst:true,
                                  isLast:false,
                                  isPast:true,
                                  text:'Order Placed :\n${snap['placed_date']}'
                              ),
                              TimelineTileWidget(
                                  isFirst: false,
                                  isLast: false,
                                  isPast:snap['track'] == "assigned" ||
                                      snap["track"] == "recieved" ||
                                      snap['track'] == "out for delivery" ||
                                      snap['track'] == "nearset hub" ||
                                      snap['track'] == 'delivered',
                                  text: 'Acknowleged'
                              ),
                              TimelineTileWidget(
                                  isFirst: false,
                                  isLast: false,
                                  isPast:snap['track'] == "recieved" ||
                                      snap["track"] == "out for delivery"||
                                      snap['track'] ==  "nearset hub"||
                                      snap['track'] == 'delivered',
                                  text: 'Received'
                              ),
                              TimelineTileWidget(
                                  isFirst: false,
                                  isLast: false,
                                  isPast:  snap["track"] == "out for delivery"||
                                      snap['track'] ==  "nearset hub"||
                                      snap['track'] == 'delivered' ,
                                  text: 'Out for delivery'
                              ),
                              TimelineTileWidget(
                                  isFirst: false,
                                  isLast: false,
                                  isPast:snap['track'] ==  "nearset hub"||
                                      snap['track'] == 'delivered' ,
                                  text: 'Reached your nearest hub \n Delivery expected today :  $expectingDate'
                              ),
                              TimelineTileWidget(
                                isFirst: false,
                                isLast: false,
                                isPast: snap['track'] == "delivered" ||
                                    snap['track'] == "return" ||
                                    snap['track'] == "cancelled",
                                text: snap['track'] == "delivered"
                                    ? 'Delivered'
                                    : snap['track'] == "return"
                                    ? 'Returned'
                                    : snap['track'] == "cancelled"
                                    ? 'Cancelled'
                                    : 'Delivered',
                              ),

                            ],
                          ),
                        ),
                      ),
                      snap['track'] != "cancelled"
                          ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                MaterialButton(
                                  color: Colors.orangeAccent,
                                  onPressed: () async {
                                    try {
                                      // Debug the current value of snap['expected']
                                      print("snap['expected']: ${snap['expected']}");

                                      // Clean the date string by replacing double slashes with single slashes
                                      String rawDate = snap['expected'].replaceAll('//', '/').trim();

                                      // Parse the cleaned date string
                                      DateTime initialDate = DateFormat('dd/MM/yyyy').parse(rawDate);

                                      // Define the date range
                                      DateTime firstDate = initialDate;
                                      DateTime lastDate = initialDate.add(Duration(days: 7));

                                      // Validate the date range
                                      if (firstDate.isAfter(lastDate)) {
                                        throw Exception("Invalid date range: firstDate is after lastDate");
                                      }

                                      // Show DatePicker with the initial date and limit the selectable date range
                                      DateTime? newDate = await showDatePicker(
                                        context: context,
                                        initialDate: initialDate,
                                        firstDate: firstDate,
                                        lastDate: lastDate,
                                      );

                                      // If a new date is selected, format it to dd/MM/yyyy and update Firestore
                                      if (newDate != null) {
                                        String formattedNewDate = DateFormat('dd/MM/yyyy').format(newDate);

                                        // Update the Firestore document with the new delivery date
                                        await FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(widget.orderId)
                                            .update({'expected': formattedNewDate});

                                        // Show a SnackBar confirming the update
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Delivery date updated to $formattedNewDate"),
                                          ),
                                        );

                                        // Refresh the UI
                                        setState(() {});
                                      }
                                    } catch (e) {
                                      print("Error: $e");
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("An error occurred: $e")),
                                      );
                                    }
                                  },
                                  child: Text(
                                    "Change Delivery Date",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Spacer(),
                            MaterialButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text(
                                        "Do you really want to cancel your order ?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("No")),
                                      TextButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(widget.orderId)
                                                .update(
                                                {'track': "cancelled"});
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes")),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                "Cancel your Order",
                              ),
                            ),
                            Spacer(),
                              ],
                            ),
                          )
                          : height
                    ],
                  ),
                ),

              );
            }
            // if(snapshot.hasError){
            //   log(snapshot.error.toString());
            //   return Center(
            //     child: Text('Something went wrong'),
            //   );
            // }else if(snapshot.connectionState == ConnectionState.waiting){
            //   return Center(
            //     child:CircularProgressIndicator(),
            //   );
            // }
            // if(snapshot.hasData || snapshot.data == null){
            //   return Center(
            //     child: Text("NO order data available"),
            //   );
            // }
            // final snap = snapshot.data!.data() as Map<String,dynamic>?;
            // if(snap == null){
            //   return Center(child: Text("No order data available"));
            // }
            // final expectingDate = snap['expected'];
             return CircularProgressIndicator();
        },
        ),

      ),
    );
  }
}
