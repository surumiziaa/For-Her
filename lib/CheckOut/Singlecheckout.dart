import 'dart:developer';
import 'package:for_her/CheckOut/OrderConfirmed.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:for_her/Core/utilities.dart';

class Buynow extends StatefulWidget {
  const Buynow({super.key});

  @override
  State<Buynow> createState() => _BuynowState();
}


class _BuynowState extends State<Buynow> {
  String Quantity='1';
  String ? Payment;
  String ? PaymentMethods;
  late Razorpay razorpay;

 @override
  void initState() {
    super.initState();
    razorpay = Razorpay();
  }

  void checkOut(int price)async{
   var options = {
     "key":'rzp_test_i8E92v8glQDYCV',
     'amount':100*price,
     'name':'ForHer PVT.Ltd',
     'description':'ForHer PVT.Ltd',
     'prefill':{
       'contact':"7356476921",
       'email':'surumiziya818@gmil.com',
     }
   };
   try{
     razorpay.open(options);
   }catch (e){
     log(e.toString());
   }
  }

 DateFormat outputFormat = DateFormat('dd//MM//yyyy');



  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    List<String> items =[];
    stock(){
      for(int i = 1;i<=args['Stock'];i++){
        items.add(i.toString());
      }
    }
    stock();
    
    
    Future stockupdate() async{
      try{
        await FirebaseFirestore.instance.collection('Products').doc(
          args['ProductId']
        ).update({
          'Stock':args['Stock'] - int.parse(Quantity)
        });
      }catch (e){
     log(e.toString());
      }
    }

    Future orderPlacing() async{
      try{
        await FirebaseFirestore.instance.collection('orders').add({
          'ProductId': args['ProductId'],
          'quantity':Quantity,
          'ProductName':args['ProductName'],
          'image': args['image'],
          'totalPrice': PaymentMethods == 'razorpay'
                       ?'${args['totalPrice']}'
                       :'${int.parse(args['totalPrice'])*int.parse(Quantity)+50}',
          'address':args['address'],
          'payment':PaymentMethods,
          'Description':args['Description'],
          'Brand': args['Brand'],
          'Categories': args['Categories'],
          'Rating': args['Rating'],
         'placed_date': outputFormat.format(DateTime.now()),
          'Stock': args['Stock'],
          'phone':args['phone'],
          'track':'pending',
          'expected':DateFormat('dd//MM/yyyy').
          format(DateTime.now().add(Duration(days: 7))),
          'userId': FirebaseAuth.instance.currentUser!.email,
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context)=>OrderConformed()));
      }catch(e){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Something went wrong"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("check later?"))
              ],
            );
          },
        );
      }
    }

    void handlepaymentsuccess(PaymentSuccessResponse response) {
      log(response.toString());
      orderPlacing();
    }

    void handlepaymentError(PaymentFailureResponse response) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Something went wrong ! Please try again"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Go back"))
            ],
          );
        },
      );
    }

    void handleExternalWallet(ExternalWalletResponse response) {}
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlepaymentsuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlepaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Card(
                elevation: 10,
                shadowColor: Colors.grey,
                child: Container(
                  //color:bkgnd,
                  width: 380,
                  height: 280,
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                        child: Text(
                      args['ProductName'].split("+").join('\n'),
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
                                args['image'][0],
                                fit: BoxFit.fill,
                                height: 200,
                                width: 150,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 38.0,top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 130,
                                  child: DropdownButtonFormField(
                                    // value: selectedQuantity,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      hintText: 'Quantity',
                                      labelText: 'Select Quantity'
                                    ),
                                    items: items.map((String value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newvalue) {
                                      setState(() {
                                        Quantity=newvalue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      shadowColor: Colors.grey,
                      child: Container(
                        height:200,
                        width: 380,
                        child: Padding(
                          padding: const EdgeInsets.all(38.0),
                          child: Text(
                            args['address'].split('+').join('\n'),
                            style: TextStyle(
                              color: Colors.black
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  right: 30,
                    top: 30,
                    child:TextButton(
                      child:Text('EDIT') ,
                      onPressed: (){
                        Navigator.pushNamed(context,'singleaddress',
                        arguments: {
                          'ProductId': args['ProductId'],
                          'ProductName': args['ProductName'],
                          'image': args['image'],
                          'totalPrice': args['totalPrice'],
                          'Description': args['Description'],
                          'Brand':args['Brands'],
                          'Categories': args['Categories'],
                          'Rating': args['Rating'],
                          'Stock': args['Stock'],
                          'userId':FirebaseAuth.instance.currentUser!.email,

                        });
                      },
                    )
                )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment:MainAxisAlignment.start,
                  children: [
                    Text("Select Payment Method",
                    style:TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              Card(
                elevation: 10,
                child: RadioListTile(
                    value:'Cash on Delivery' ,
                    groupValue:Payment,
                    onChanged:(value){
                     setState(() {
                       Payment= value!;
                       PaymentMethods='Cash on Delivery';
                     });
                    },
                title: Text('Cash on Delivery'),
                ),
              ),
              height,
              Card(
                elevation: 10,
                child: RadioListTile(
                  value:'Razorpay' ,
                  groupValue:Payment,
                  onChanged:(value){
                  setState(() {
                    Payment= value!;
                    PaymentMethods ='razorpay';
                  });
                  },
                  title: Text('Razorpay'),
                ),
              ),
              height,
              ExpansionTile(
                  title:Text('View Price Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Total Price",
                      style: TextStyle(
                        color: green,
                        fontSize: 17
                      ),),
                      Spacer(),
                       Text(
                        ": ₹ ${int.parse(args['totalPrice'].toString()) * int.parse(Quantity)} /-",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15
                      ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "Delivery Charge",
                        style:TextStyle(
                            fontSize: 18,
                            color: PaymentMethods == "razorpay"
                                ? Colors.black
                                : Red),
                      ),
                      Spacer(),
                      Text(
                        PaymentMethods == "razorpay" ?
                            '₹ 0 /-': '₹ 50 /-',
                        style:TextStyle(
                            fontSize: 18,
                            color: PaymentMethods == "razorpay"
                                ? Colors.black
                                : Red),
                      ),

                    ],
                  ),
                ),
                Divider(
                  thickness: 3,
                  color:pur
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text("Order Total",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                      Spacer(),
                      Text(
                        PaymentMethods == "razorpay"
                            ? "₹ ${int.parse(args['totalPrice']) * int.parse(Quantity)} /-"
                            : ": ₹ ${int.parse(args['totalPrice']) * int.parse(Quantity) + 50} /-",
                        style: TextStyle(
                          fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),),
                    ],
                  ),
                ),
           height,
              ],
              ),
              height,
              MaterialButton(
                minWidth: 250,
                height: 40,
                onPressed: (){
                  if(Payment == null){
                    showDialog(context: context,
                        builder: (context){
                      return  AlertDialog(
                        content: Text("Select a payment method"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Back"))
                        ],
                      );
                        });
                  }else{
                    if(args['address'] !=
                    "Add+New+Address+for Delivery"){
                      if(PaymentMethods == 'razorpay'){
                        checkOut(int.parse(args['totalPrice']));
                      }else{
                        orderPlacing();
                        stockupdate();
                      }
                    }
                    stockupdate();
                  }
                },
              color: pur,
              child: Text(
                PaymentMethods == "razorpay"
                ?"Proceed to Pay"
                : 'Place Order',
                style:TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ) ,),)
            ]
          ),
        ),
        // bottomSheet: BottomSheet(
        //   onClosing: () {},
        //   builder: (BuildContext context) {
        //     return Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         const Padding(
        //           padding: EdgeInsets.all(8.0),
        //           child: Text(
        //             'Total Price\n₹500',
        //             style: TextStyle(fontSize: 20, color: Colors.black),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: MaterialButton(
        //             onPressed: () {
        //              // Navigator.push(context,MaterialPageRoute(builder: (context)=>const Checkoutdetails()));
        //               Navigator.push(context,MaterialPageRoute(builder: (context)=>Address()));
        //             },
        //             child: const Text('CheckOut',
        //               style: TextStyle(
        //                 color:Color(0xff7b0001),
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }
}
